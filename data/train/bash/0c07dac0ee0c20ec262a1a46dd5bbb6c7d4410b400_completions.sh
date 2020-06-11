# Import default completions

load_completion() {
  [[ -s "$1" ]] && source "$1"
}

load_completions_under() {
  [[ ! -d "$1" ]] && return 1
  while read -r completion_file; do
    source "$completion_file"
  done < <(find "$1" -type f)
  unset completion_file
}

load_all_completions() {
  if command -v brew > /dev/null; then
    homebrew_prefix="$(brew --prefix)"
    load_completion "$homebrew_prefix/Library/Contributions/brew_bash_completion.sh"
    load_completion "$homebrew_prefix/etc/bash_completion"
    load_completion "$homebrew_prefix/Cellar/git/1.8.3.1/etc/bash_completion.d/git-completion.bash"
  fi
  load_completions_under ~/.bash/profile-ext/completions/
}

