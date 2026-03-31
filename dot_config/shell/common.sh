path_prepend() {
  case ":$PATH:" in
  *":$1:"*) ;;
  *) PATH="$1${PATH:+:$PATH}" ;;
  esac
}

path_append() {
  case ":$PATH:" in
  *":$1:"*) ;;
  *) PATH="${PATH:+$PATH:}$1" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/bin"

case "$(uname -s)" in
Darwin)
  PNPM_HOME="$HOME/Library/pnpm"
  ;;
*)
  PNPM_HOME="$HOME/.local/share/pnpm"
  ;;
esac
export PNPM_HOME
[ -d "$PNPM_HOME" ] && path_prepend "$PNPM_HOME"

alias sudo='sudo '
alias la='ls -la'

if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
  alias vi='nvim'
  export EDITOR='nvim'
  export SYSTEMD_EDITOR='nvim'
  git config --global core.editor "nvim"
fi

export PATH

[ -r "$HOME/.config/shell/local.sh" ] && . "$HOME/.config/shell/local.sh"
