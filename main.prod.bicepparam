using 'main.bicep'

param resourceGroupName = 'Arc-enabledserver-RG'
param resourceGroupLocation = 'japaneast'
// ---- for Firewall Rule ----
// your ip address for RDP (ex. xxx.xxx.xxx.xxx)
param myipaddress = '124.37.254.233'
// ---- param for Hub ----
param hubVNetName = 'Hub-VNet'
param hubVNetAddress = '10.0.0.0/16'
param hubSubnetName1 = 'Hub-VMSubnet'
param hubSubnetAddress1 = '10.0.0.0/24'
param hubvmName1 = 'hub-jump-win-01'
// ---- param for Onpre ----
param onpreVNetName = 'Onpre-VNet' 
param onpreVNetAddress = '172.16.0.0/16'
param onpreSubnetName1 = 'Onpre-VMSubnet'
param onpreSubnetAddress1 = '172.16.0.0/24'
param onprevmName1 = 'onpre-win-01'
// ---- Common param for VM ----
param vmSizeWindows = 'Standard_B2ms'
param adminUserName = 'cloudadmin'
param adminPassword = 'msjapan1!msjapan1!'
