# Steps for integrating Azure Key Vault (AKV) with Azure Kubernetes Service (AKS)

## Configure Secret Store CSI driver

### Create Kubernetes cluster with `Azure keayvault secrets provider` addon

```bash
az aks create \
--name myAKSCluster \
--node-count 2 \
--resource-group demo-azure-singapore-rg \
--kubernetes-version 1.28.3 \
--attach-acr ngAcrRegistry \
--enable-managed-identity \
--enable-keda \
--enable-addons azure-keyvault-secrets-provider \
--output jsonc 
                
```

### Verify the `Azure keyvault secrets provider` CSI driver installation

```bash

kubectl get pods \
--namespace kube-system \
--selector 'app in (secrets-store-csi-driver,secrets-store-provider-azure)'

```

### View details of Azure Kubernetes Service (AKS) cluster

```bash

az aks show \
--resource-group demo-azure-singapore-rg \
--name azure-singapore-cluster \
--output jsonc

```

### Create Azure Key Vault and enable RBAC authorization

```bash

az keyvault create \
--name demo-akv-ng \
--resource-group demo-azure-singapore-rg \
--location southeastasia \
--enable-rbac-authorization

```

### Store a secret in Azure Key Vault

```bash

az keyvault secret set \
--vault-name demo-akv-ng \
--name AzureOpenAIAPIKey \
--value $AZURE_OPENAI_TOKEN

```

## Provide Azure Key Vault access

### Get the name of the identity associate with AKV secret Store CSI driver

```bash

az aks show \
--resource-group demo-azure-singapore-rg \
--name azure-singapore-cluster \
--query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId \
--output tsv

```

### Assign the identity access to the Azure Key Vault

```bash

export IDENTITY_OBJECT_ID="$(az identity show -g MC_demo-azure-singapore-rg_azure-singapore-cluster_southeastasia --name azurekeyvaultsecretsprovider-azure-singapore-cluster --query 'clientId' -o tsv)"

export KEYVAULT_SCOPE=$(az keyvault show --name demo-akv-ng --query id -o tsv)

az role assignment create \
--role "Key Vault Administrator" \
--assignee $IDENTITY_OBJECT_ID \
--scope $KEYVAULT_SCOPE


# get tenant id for azure subscription
export TENANTID=$(az account show --query tenantId -o tsv)

```

### Create SecretProviderClass
    
    ```yaml

    # This is a SecretProviderClass example using user-assigned identity to access your key vault
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname-user-msi
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"          # Set to true for using managed identity
    userAssignedIdentityID: $CLIENT_ID   # Set the clientID of the user-assigned managed identity to use
    keyvaultName: ngAkv        # Set to the name of your key vault
    
    objects:  |
      array:
        - |
          objectName: AzureOpenAIAPI
          objectType: secret              # object types: secret, key, or cert
    tenantId: $TENANTID                 # The tenant ID of the key vault

    ```

    ### Apply the SecretProviderClass

    ```bash

    kubectl apply -f secretproviderclass.yaml

    ```

    ### Use the secret

    ```bash

    kubectl apply -f k8s/akv-integration/test-pod.yaml

    ```

