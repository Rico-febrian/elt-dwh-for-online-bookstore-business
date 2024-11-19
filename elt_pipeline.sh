#!/bin/bash

echo "========== Start Orchestration Process =========="

# Set Virtual Environment Path
VENV_PATH="/home/ricofebrian/data-warehouse-labs/project/pacbook_store/pacbook_ven/bin/activate"

# Activate Virtual Environment
source="$VENV_PATH"

# Set Python script
PYTHON_SCRIPT="/home/ricofebrian/data-warehouse-labs/project/pacbook_store/main_elt_pipeline.py"

# Run Python script
python "$PYTHON_SCRIPT"

echo "========== End of Orchestration Process =========="