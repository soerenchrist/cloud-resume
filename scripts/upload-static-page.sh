#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DIST_DIR="$SCRIPT_DIR/../frontend/dist"
NPM_DIR="$SCRIPT_DIR/../frontend/"
ENV=$1

if [ -z $ENV ]; then ENV="dev"; fi

STORAGE_ACCOUNT="resumefrontend${ENV}sa"
RESOURCE_GROUP="resume-frontend-$ENV-rg"

echo "Deploying to environment $ENV"

echo 'Building project'
cd $NPM_DIR 
npm run build

echo 'Uploading static page'
az storage blob upload-batch -s $DIST_DIR -d '$web' --account-name $STORAGE_ACCOUNT --overwrite

az storage account show -n $STORAGE_ACCOUNT -g $RESOURCE_GROUP --query "primaryEndpoints.web" --output tsv