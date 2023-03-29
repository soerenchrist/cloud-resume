#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DIST_DIR="$SCRIPT_DIR/../dist"

STORAGE_ACCOUNT="resumefrontenddevstorage"
RESOURCE_GROUP="resumefrontend-dev-rg"

echo 'Building project'
npm run build

echo 'Uploading static page'
az storage blob upload-batch -s $DIST_DIR -d '$web' --account-name $STORAGE_ACCOUNT --overwrite

az storage account show -n $STORAGE_ACCOUNT -g $RESOURCE_GROUP --query "primaryEndpoints.web" --output tsv