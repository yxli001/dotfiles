export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

nvm_auto_use() {
  local node_version
  local nvmrc_path
  local nvmrc_node_version

  node_version="$(nvm version)"
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    nvmrc_node_version="$(nvm version "$(cat "$nvmrc_path")")"
    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    nvm use default
  fi
}

if [[ $- == *i* ]] && command -v nvm >/dev/null 2>&1; then
  nvm_auto_use
  PROMPT_COMMAND="nvm_auto_use${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi
