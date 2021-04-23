#!/bin/bash

# Script for setting up an Azure App Service app with SQL Server

LOCATION="UK South"
RG_NAME="rg-coolbananas-shared-uks"
APP_PLAN="coolbananas"
APP_NAME="coolbananas-123"
SQL_SERVER_NAME="sql-coolbananas-shared-uks"
SQL_USER="adamadmin"
SQL_PWD="Comeon123"
SQL_DB_NAME="coolbananas-main"
MY_IP_ADDRESS="85.255.237.90"
CONN_STRING_NAME="DbConnection"

set -x

az group create --name $RG_NAME --location "$LOCATION"

az appservice plan create --resource-group $RG_NAME --name $APP_PLAN --sku FREE

az webapp create --resource-group $RG_NAME --plan $APP_PLAN --name $APP_NAME

az sql server create --name $SQL_SERVER_NAME --resource-group $RG_NAME --location "$LOCATION" \
   --admin-user $SQL_USER --admin-password $SQL_PWD

az sql server firewall-rule create --name AllowAzureIps --server $SQL_SERVER_NAME --resource-group $RG_NAME \
   --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

az sql server firewall-rule create --name AllowLocalClient --server $SQL_SERVER_NAME --resource-group $RG_NAME \
   --start-ip-address=$MY_IP_ADDRESS --end-ip-address=$MY_IP_ADDRESS

az sql db create --resource-group $RG_NAME --server $SQL_SERVER_NAME --name $SQL_DB_NAME --service-objective S0

CONN_STRING="Server=tcp:$SQL_SERVER_NAME.database.windows.net,1433;Database=$SQL_DB_NAME;User ID=$SQL_USER;Password=$SQL_PWD;Encrypt=true;Connection Timeout=30;"

az webapp config connection-string set --resource-group $RG_NAME --name $APP_NAME \
   --settings $CONN_STRING_NAME="$CONN_STRING" --connection-string-type SQLAzure

az webapp log config --name $APP_NAME --resource-group $RG_NAME --application-logging filesystem --level warning

set +x

echo "\nCopy and store the following connection string:"
echo "$CONN_STRING"