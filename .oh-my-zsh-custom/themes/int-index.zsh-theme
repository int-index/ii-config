function nix_shell_info() {
  if [[ "$IN_NIX_SHELL" == "impure" ]]; then
    echo "[nix] "
  elif [[ -v IN_NIX_SHELL ]]; then
    echo "[nix:$IN_NIX_SHELL] "
  fi
}

PROMPT='%{$fg[green]%}$(nix_shell_info)%{$fg[cyan]%}%c%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}% %{$reset_color%}$ '

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
