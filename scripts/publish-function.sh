#!/bin/bash
ENV=$1

if [ -z $ENV ]; then ENV="dev"; fi
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

FUNCTION_APP="resume-backend-$ENV-function-app"
PROJECT_DIR="$SCRIPT_DIR/../backend"

echo "Publish Function to environment: $ENV, function app: $FUNCTION_APP"
cd $PROJECT_DIR
func azure functionapp publish $FUNCTION_APP