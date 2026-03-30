if command -v brew >/dev/null 2>&1; then
  brew() {
    local -a conda_envs

    while [ "${CONDA_SHLVL:-0}" -gt 0 ]; do
      conda_envs=("$CONDA_DEFAULT_ENV" $conda_envs)
      conda deactivate
    done

    command brew "$@"
    local brew_status=$?

    for env in $conda_envs; do
      conda activate "$env"
    done

    unset env
    return "$brew_status"
  }
fi
