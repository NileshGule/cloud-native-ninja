# Commands used for Warp REdaction YouTube video

az account show --query 'id' -o tsv

exprt ARM_SUBSCRIPTION_ID=$(az account show --query 'id' -o tsv)

echo $ARM_SUBSCRIPTION_ID

