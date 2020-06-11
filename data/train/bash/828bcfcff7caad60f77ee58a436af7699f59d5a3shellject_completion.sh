_shellject()
{
  local cur prev opts base save_dir
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  case "${prev}" in
    shellject)
      COMPREPLY=($(compgen -W "load save setup --help --version" -- ${cur}))
      return 0
      ;;
    save)
      #  Use default filename completion (when combined with -o default below)
      COMPREPLY=()
      return 0
      ;;
    load)
      #
      #  Shelljections we know about, removing save dir as a  prefix.
      #
      save_dir=${SHELLJECT_SAVE_DIR:- $(ls -d ~/.shellject/shelljections)}
      # Escape save_dir for regex
      local prefix=$(echo ${save_dir}/ | sed -e 's/[\/&]/\\&/g')
      local shelljections=$(find ${save_dir} -type f| sed -e "s/${prefix}\(.*\)/\1/")
      COMPREPLY=( $(compgen -W "${shelljections}" -- ${cur}) )
      return 0
      ;;
  esac

}
complete -F _shellject -o default shellject

