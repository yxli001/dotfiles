CONDA_ROOT="$HOME/miniconda3"

if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
  . "$CONDA_ROOT/etc/profile.d/conda.sh"
elif [ -d "$CONDA_ROOT/condabin" ]; then
  path_prepend "$CONDA_ROOT/condabin"
fi
