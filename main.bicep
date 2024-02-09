targetScope = 'subscription'

/*
------------------
param section
------------------
*/
// ---- param for Common ----
param resourceGroupName string
param resourceGroupLocation string
param myipaddress string

// ----param for Hub----
param hubVNetName string
param hubVNetAddress string
// VM Subnet
param hubSubnetName1 string 
param hubSubnetAddress1 string

// ---- param for Onpre ----
param onpreVNetName string 
param onpreVNetAddress string
// VM Subnet
param onpreSubnetName1 string
param onpreSubnetAddress1 string

// ----param for VM----
param vmSizeWindows string
param hubvmName1 string
param onprevmName1 string
@secure()
param adminUserName string
@secure()
param adminPassword string

/*
------------------
resource section
------------------
*/

resource newRG 'Microsoft.Resources/resourceGroups@2021-04-01' = { 
  name: resourceGroupName 
  location: resourceGroupLocation 
} 

/*
---------------
module section
---------------
*/

// Create Hub Environment (VM-Windows, VNet, Subnet, NSG)
module HubModule './modules/hubEnv.bicep' = { 
  scope: newRG 
  name: 'CreateHubEnv' 
  params: { 
    location: resourceGroupLocation
    hubVNetName: hubVNetName
    hubVNetAddress: hubVNetAddress
    myipaddress: myipaddress
    hubSubnetName1: hubSubnetName1
    hubSubnetAddress1: hubSubnetAddress1
    hubvmName1: hubvmName1
    vmSizeWindows: vmSizeWindows
    adminUserName: adminUserName
    adminPassword: adminPassword
  } 
}

// Create Onpre Environment (VM-Windows, VNet, Subnet, NSG)
module OnpreModule './modules/onpreEnv.bicep' = { 
  scope: newRG 
  name: 'CreateOnpreEnv' 
  params: { 
    location: resourceGroupLocation
    onpreVNetName: onpreVNetName
    onpreVNetAddress: onpreVNetAddress
    myipaddress: myipaddress
    onpreSubnetName1: onpreSubnetName1
    onpreSubnetAddress1: onpreSubnetAddress1
    onprevmName1: onprevmName1
    vmSizeWindows: vmSizeWindows
    adminUserName: adminUserName
    adminPassword: adminPassword
  } 
}
