#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FUNCTION_APP="resumebackend-dev-function-app"
PROJECT_DIR="$SCRIPT_DIR/../VisitorCountFunction"

echo "Publish Function"
cd $PROJECT_DIR
func azure functionapp publish $FUNCTION_APP