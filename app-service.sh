#!/bin/bash

# Script for setting up an Azure App Service app

RG_NAME=rg-coolbananas-shared
APP_PLAN=coolbananas
APP_NAME=coolbananas-123

set -x

az group create --name $RG_NAME --location "UK South"

az appservice plan create --resource-group $RG_NAME --name $APP_PLAN --sku FREE

az webapp create --resource-group $RG_NAME --plan $APP_PLAN --name $APP_NAME