#!/bin/sh

set -e

echo "Login"
az login --service-principal --username "${SERVICE_PRINCIPAL}" --password "${SERVICE_PASS}" --tenant "${TENANT_ID}"

echo "Creating resource group ${APPID}-group"
az group create -n ${APPID}-group -l westcentralus

echo "Creating app service plan ${APPID}-plan"
az appservice plan create -g ${APPID}-group -n ${APPID}-plan --sku FREE

echo "Creating webapp ${APPID}"
az webapp create -g ${APPID}-group -p ${APPID}-plan -n ${APPID} --deployment-local-git

echo "Getting username/password for deployment"
DEPLOYUSER=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userName' -o tsv`
DEPLOYPASS=`az webapp deployment list-publishing-profiles -n ${APPID} -g ${APPID}-group --query '[0].userPWD' -o tsv`

git remote add azure https://${DEPLOYUSER}:${DEPLOYPASS}@${APPID}.scm.azurewebsites.net/${APPID}.git

git push azure master
