param rgLocation string = resourceGroup().location
param storageCount int 

resource createStorages 'Microsoft.Storage/storageAccounts@2021-06-01' = [for i in range(1, storageCount): {
  name: '${i}storage${uniqueString(resourceGroup().id)}'
  location: rgLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]

output names array = [for i in range(0,storageCount) : {
  name: createStorages[i].name
} ]
