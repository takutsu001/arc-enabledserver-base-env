/*
------------------
param section
------------------
*/
param location string
param myipaddress string
param onpreVNetName string 
param onpreVNetAddress string
// VM Subnet
param onpreSubnetName1 string
param onpreSubnetAddress1 string
// for VM
param onprevmName1 string
param vmSizeWindows string
@secure()
param adminUserName string
@secure()
param adminPassword string

/*
------------------
var section
------------------
*/
// VM Subnet
var onpreSubnet1 = { 
  name: onpreSubnetName1 
  properties: { 
    addressPrefix: onpreSubnetAddress1
    networkSecurityGroup: {
    id: nsgDefault.id
    }
  }
}

/*
------------------
resource section
------------------
*/

// create network security group for onpre vnet
resource nsgDefault 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: 'onpre-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
        description: 'RDP access permission from your own PC.'
        protocol: 'TCP'
        sourcePortRange: '*'
        destinationPortRange: '3389'
        sourceAddressPrefix: myipaddress
        destinationAddressPrefix: '*'
        access: 'Allow'
        priority: 1000
        direction: 'Inbound'
        }
      }
    ]
  }
}

// create onpreVNet & onpreSubnet
resource onpreVNet 'Microsoft.Network/virtualNetworks@2021-05-01' = { 
  name: onpreVNetName 
  location: location 
  properties: { 
    addressSpace: { 
      addressPrefixes: [ 
        onpreVNetAddress 
      ] 
    } 
    subnets: [ 
      onpreSubnet1
    ]
  }
  // Get subnet information where VMs are connected.
  resource onpreVMSubnet 'subnets' existing = {
    name: onpreSubnetName1
  }
}

// create VM in onpreVNet
// create public ip address for Windows VM
resource publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: '${onprevmName1}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

// create network interface for Windows VM
resource networkInterface 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${onprevmName1}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: onpreVNet::onpreVMSubnet.id
          }
        }
      }
    ]
  }
}

// create Windows vm in onpre vnet
resource centosVM1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: onprevmName1
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSizeWindows
    }
    osProfile: {
      computerName: onprevmName1
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
       offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: '${onprevmName1}-disk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

/*
------------------
output section
------------------
*/

// return the private ip address of the vm to use from parent template
@description('return the private ip address of the vm to use from parent template')
output vmPrivateIp string = networkInterface.properties.ipConfigurations[0].properties.privateIPAddress
