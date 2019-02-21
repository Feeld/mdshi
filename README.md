# mdshi - interactive, executable documentation.

`mdshi` is an extension of [mdsh](https://github.com/bashup/mdsh)

It can be used in exactly the same way as `mdsh` however a script ran/compiled
with it is turned into an "interactive" walk-through.

During execution, the script will pause before each `sh` code block, displaying
its content in terminal (colorised using pygmentize), and let you decide if
the code should be ran or skipped. It will also allow you edit the command in
text editor (based on EDITOR/VISUAL env var via `vipe`), or to cleanly quit the
entire script at each prompt.

In addition to displaying the code blocks, the markdown content immediately
preceding each block is also displayed at the prompt, so that you can read the
documentation concerning the block of code before deciding to execute the it.

Note that currently only the content preceding the `sh` blocks will be displayed
(although you are free to change this behaviour). The `shell` blocks are still
executed however they are nod displayed since they are meant to be used for
supporting code which is not part of the documentation.


## Runtime dependencies

The following executables need to be on you `PATH` at the time the `mdshi`
compiled scripts are executed:

1. [mdless](https://github.com/ttscoff/mdless) - used for rendering markdown.
2. [pygmentize](http://pygments.org/) - used for code coloring.
3. `vipe` from [moreutils](https://joeyh.name/code/moreutils/) - used in edit
  mode.

In order to use the edit mode, you will need to have the `EDITOR` or `VISUAL`
env var set.


## Installation

You can install `mdshi` with [basher](https://github.com/basherpm/basher):

  ```shell
  basher install feeld/mdshi
  ```

Otherwise simply download the `mdshi` executable (in `bin/`), `chmod +x` it, and
put it in a directory on your `PATH`.


## Usage

You can use `mdshi` in the same way as `mdsh` itself. For example (assuming that
`mdshi` is on your `PATH`, you can run this file with:

  ```shell
  mdshi README.md
  ```

Is your script starts with: `#!/usr/bin/env mdshi`, you will be able to execute
it directly (as long as it's been `chmoded`):

  ```shell
  ./examples/mkdir_tutorial
  ```

The difference between running it with `mdshi` vs `mdsh`, is that the former
will print rendered markdown in your terminal, and pause before executing the
`sh` code block at the bottom of this file, asking for confirmation whether
it should execute the code or not. On the other hand `mdsh` will simply ignore
the non-code content and execute all the code block one after without stopping
in between. Please note that both `mdshi` and `mdsh` execute only non-indented
code blocks (`mdshi` will display them as part of the markdown, but will not
pause at them).


## TODOs

- [ ] instruct editor about the language used to enable syntax highlighting etc.
- [ ] add an easy way of requesting the user to manually enter values for
  variables at code block prompt
- [ ] add code block editing before execution using EDITOR/VISUAL
- [ ] add a way to start execution from a specific block (could be based on
  label added after language tag)
- [ ] add a way of listing TOC: listing code blocks (showing first line of block
  and its index/label)
- [ ] add a way to enter interactive shell for executing current command (not
  sure how it would work for scripts which rely on setting variables to be used
  by subsequent blocks)


## Customising/extending `mdshi`.

You can use `mdshi` in the similar way to `mdsh`. Once you familiarise yourself
with [mdsh](https://github.com/bashup/mdsh), look in `mdshi.md` to understand
how `mdshi` accomplishes what it does, and which functions to implement/override
in order to customise its behaviour.


## Generating `mdshi` executable.

Assuming that `mdsh` executable is on the $PATH, and that MDSH_PACKAGES_PATH is
set to path where mdsh.md can be found, the `mdshi` executable can be generated
with the following command:

```sh
mkdir -p bin
MDSH_PACKAGE_PATH=$MDSH_PACKAGE_PATH mdsh --compile mdshi.md > bin/mdshi
chmod +x bin/mdshi
```
