// resource storageaccount1 'Microsoft.Storage/storageAccounts@2021-02-01' = {
//   name: 'seperatestorage234tg2r45'
//   location: 'eastus'
//   kind: 'StorageV2'
//   sku: {
//     name: 'Premium_LRS'
//   }
// }

// resource blob1 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
//   name: 'default'
//   parent: storageaccount1
// }

// resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
//   name: 'seperatecontainer'
//   parent: blob1
// }

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: 'name'
  location: 'eastus'
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
  resource blob2 'blobServices@2022-09-01' = {
    name: 'default'

    resource container2 'containers@2022-09-01' = {
      name: 'nestedcontainer'
      
    }
    
  }
}

