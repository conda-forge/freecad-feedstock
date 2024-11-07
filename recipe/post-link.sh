#!/bin/sh
# ----------------------------------------------------------------------------------------------------------------
#
# By adding the $CONDA_PREFIX/lib directory to $PYTHONPATH, python is able to find
# FreeCAD, FreeCADGui, and other various FreeCAD-related modules during execution.
#
# This script is executed after the freecad package is installed.
# See:
# https://docs.conda.io/projects/conda-build/en/latest/resources/link-scripts.html
# 
# It creates scripts which are executed upon activating and deactivating the conda environment containing freecad.
# See:
# https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#saving-environment-variables
#
# ----------------------------------------------------------------------------------------------------------------
cd $CONDA_PREFIX
mkdir -p ./etc/conda/activate.d
mkdir -p ./etc/conda/deactivate.d

echo '#!/bin/sh' > ./etc/conda/activate.d/env_vars.sh
echo 'export INITIAL_PYTHONPATH=${PYTHONPATH}' >> ./etc/conda/activate.d/env_vars.sh
echo "export PYTHONPATH=$CONDA_PREFIX/lib:\${PYTHONPATH}" >> ./etc/conda/activate.d/env_vars.sh

echo '#!/bin/sh' > ./etc/conda/deactivate.d/env_vars.sh
echo 'export PYTHONPATH=${INITIAL_PYTHONPATH}' >> ./etc/conda/deactivate.d/env_vars.sh
echo 'unset INITIAL_PYTHONPATH' >> ./etc/conda/deactivate.d/env_vars.sh

# Issue describing conda activation scripts for fish shell:
# https://github.com/conda/conda/issues/7993#issuecomment-459453605
echo '#!/usr/bin/env fish' > ./etc/conda/activate.d/env_vars.fish
echo 'set -gx INITIAL_PYTHONPATH $PYTHONPATH' > ./etc/conda/activate.d/env_vars.fish
echo "set -gx PYTHONPATH $CONDA_PREFIX/lib $PYTHONPATH" >> ./etc/conda/activate.d/env_vars.fish

echo '#!/usr/bin/env fish' > ./etc/conda/deactivate.d/env_vars.fish
echo 'set -gx PYTHONPATH $INITIAL_PYTHONPATH' >> ./etc/conda/deactivate.d/env_vars.fish
echo 'set -e INITIAL_PYTHONPATH' >> ./etc/conda/deactivate.d/env_vars.fish

