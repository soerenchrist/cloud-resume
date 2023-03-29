#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FUNCTION_APP="resume-backend-dev-function-app"
PROJECT_DIR="$SCRIPT_DIR/../backend"

echo "Publish Function"
cd $PROJECT_DIR
func azure functionapp publish $FUNCTION_APP
