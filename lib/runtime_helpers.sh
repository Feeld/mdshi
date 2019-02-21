bold() {
  echo "$(tput bold)$*" "$(tput sgr0)";
}

boldp() {
  printf "$(tput bold)$*$(tput sgr0)";
}

prompt_to_continue()
{
  if [[ $1 ]]; then echo "$1"; fi

  bold "Do you wish to continue? (y/n): "

  while true; do
      read yn
      case $yn in
          [Yy]* ) break;;
          [Nn]* ) exit;;
          * ) bold "Please answer: (y)es or (n)o: ";;
      esac
  done
}

run_skip_exit()
{
  # The `${2:--}` variable expansion is used to avoid `$2: unbound variable` error.
  if [[ ${2:--} != '-' ]]; then echo "$2"; fi

  local ret=0

  boldp "What to do next? (r)un/(s)kip/(e)dit/(q)uit: "

  while true; do
      read cse
      case $cse in
          [Rr]* ) echo ''; break;;
          [Ss]* ) ret=1; break;;
          [Ee]* ) echo ''; if [[ ${1:--} != '-' ]];
            then
              local edited=$( echo "$1" | vipe )
              eval "$edited"
            else
              echo "Nothing to edit!"
            fi;
            ret=1; break;;
          [Qq]* ) exit;;
          * ) boldp "Please choose one of: (r)un, (s)kip, (e)dit or (q)uit: ";;
      esac
  done

  return $ret;
}
