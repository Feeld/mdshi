#!/usr/bin/env bash
: '
<!-- ex: set syntax=markdown : '; eval "$(mdsh -E "$BASH_SOURCE")"; # -->


# mdshi - interactive, executable documentation.

`mdshi` is an extension of [mdsh](https://github.com/bashup/mdsh)

It can be used in exactly the same way as `mdsh` however the resulting script
will be "interactive".

During execution, the script will pause before each `sh` code block, displaying
its content in terminal (colorised using pygmentize), and let user decide if
the block should be ran or skipped. It will also allow the user to cleanly exit
at each prompt.

In addition to displaying the code blocks, rendered markdown content is also
displayed in the terminal, so that the user can read the preceding block of
documentation before deciding to execute the code block. Note that only content
preceding the `sh` blocks will be displayed.


## Compiling `mdshi` executable.

Assuming that `mdsh` executable is on the $PATH, and that `MDSH_PACKAGE_PATH` is
set to path where `mdsh.md` can be found, the `mdshi` executable can be generated
with the following command:

  ```sh
  MDSH_PACKAGE_PATH=$MDSH_PACKAGE_PATH mdsh --compile mdshi.md > bin/mdshi
  chmond +x bin/mdshi
  ```


## Runtime

```shell mdsh
@module mdshi.md
@main mdsh-main

echo \
"# The MIT licence below applies to code imported from mdsh (in between the
# 'MDSH BEGIN', 'MDSH END' lines)."
echo ""
echo "# The rest of the code is public domain (see: http://unlicense.org/)."
echo ""
echo "# MDSH BEGIN ==================================================================="
echo ""

@require bashup/mdsh   mdsh-source "$MDSH_PACKAGES_PATH/mdsh.md"

echo ""
echo "# MDSH END ====================================================================="
echo ""
```

### Compile time helpers.

Compiles `sh` code blocks, adding interactive prompt in front of each one.
During script execution, the content of the block is displayed in terminal
before the prompt. Support for other languages can be added by implementing
a similar functions for those language as documented
[here](https://github.com/bashup/mdsh#processing-non-shell-languages).
Note: `run_skip_exit` is defined in lib/runtime_helpers.sh, which content
is added at the head of all compiled scripts.

```shell
count=0
mdsh-compile-sh() {
  count=$((count+1))
  echo "bold 'Code block ${count} (${2}):'"
  echo "echo ''"
  printf "echo %q | pygmentize -l \"$2\"\n" "$1"
  echo "echo ''"
  printf "run_skip_exit %q && eval %q\n" "$1" "$1"
  echo "echo ''"
}
```

Function used by `mdsh` to find code blocks. Added functionality is the
accumulation of markdown content in between code blocks and calling of
compile-markdown with accumulated markdown once code block if found.

```shell
mdsh-find-block(){
  local md_block

  while ((lno++));
    IFS= read -r ln;
    do if [[ $ln =~ $mdsh_fence ]]; then
      local lang=${BASH_REMATCH[3]}
      lang="${lang%"${lang##*[![:space:]]}"}"
      compile-markdown "$md_block" "$lang"
      return;
    else
      # Accumulate markdown content, skip initial shebang line (if present).
      if ! [[ $lno -eq 1 && $ln == \#\!* ]]; then
        md_block+=$ln$'\n'
      fi;
    fi;
  done; false
}
```

Compiles markdown content in front of each non `shell` code block.
Generated script will output markdown content to terminal (rendered using
[mdless](https://github.com/ttscoff/mdless)), before executing along the
following code block before the interactive prompt.

```shell
compile-markdown() {
  # Don't print md content in fron of `shell` blocks since those are
  # not part of the spinnaker instructions.
  if [ "$2" != "shell" ]; then
    printf "echo %q | mdless | cat\n" "$1"
  fi
}
```

### Run-time helpers.

A library of helper function used during execution. They are appended at the
end of each compiled script.

```shell mdsh
echo "mdsh:file-header() {"
value=`cat ./lib/runtime_helpers.sh`
printf "echo %q\n" "$value"
echo "}"
```


Boilerplate recommended when [extending mdsh](https://github.com/bashup/mdsh#extending-mdsh-or-reusing-its-functions).

[[ $0 == $BASH_SOURCE ]] && mdsh-main "$@"
