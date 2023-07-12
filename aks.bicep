@description('The name of the Managed Cluster resource.')
param clusterName string = 'malyadri-cluster'

@description('The location of the Managed Cluster resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 30

@description('The number of nodes for the cluster. This static value will be taken when Autoscaling is OFF.')
@minValue(1)
@maxValue(50)
param nodeCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string = 'azureuser'

@description('Configure all linux machines with the SSH RSA public key string. Your key should include three parts, for example \'ssh-rsa AAAAB...snip...UcyupgH azureuser@linuxvm\'')
param sshRSAPublicKey string

@description('Kubernetes version for the cluster.')
@allowed([
  '1.26.3'
  '1.26.0'
  '1.25.6'
  '1.25.5'
  '1.24.10'
  '1.24.9'
])
param kubernetesVersion string = '1.25.6'

@description('Node Autoscaling')
param enableAutoScaling bool

@description('Min node count. Should be atleast 1.')
param minCount int = 1

@description('Max node count. Should be atmost 1000.')
param maxCount int = 3

resource cluster 'Microsoft.ContainerService/managedClusters@2022-05-02-preview' = {
  name: clusterName
  tags: {
    'Created By': 'Malyadri'
  }
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: dnsPrefix
    kubernetesVersion: kubernetesVersion
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        enableNodePublicIP: true
        tags: {
          'Created By': 'Malyadri'
        }
        count: nodeCount
        enableAutoScaling: enableAutoScaling
        minCount: (enableAutoScaling ? minCount : null)
        maxCount: (enableAutoScaling ? maxCount : null)
      }
    ]
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    } 
    addonProfiles: {
    azurepolicy: {
      enabled: true
      config: {
        version: 'v2'
      }
    } 
   }
  } 
  
}

output controlPlaneFQDN string = cluster.properties.fqdn
