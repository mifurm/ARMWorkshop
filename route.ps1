
$MikrotikVHD = "C:\Users\Administrator\Downloads\chr-6.42.12.vhd"
$ResourceGroup = "mikrotikrg"
$Location = "westeurope"
$VNETName = "vnet01-mng"
$SubnetName_ether1 = "wfe-subnet"
$SubnetName_ether2 = "backend-subnet"
$VMName = "mikrotikrouter-vm01"
$VMSize = "Standard_DS1_v2"
$StorageAccountName = "mikrotikvhdsa"
$urlOfUploadedVhd = "https://"+$StorageAccountName+".blob.core.windows.net/vhds/"+$(Split-Path $MikrotikVHD -Leaf)

# Select VNET
$VNET = Get-AzureRmVirtualNetwork | Where-Object { $_.Name -like $VNETName }

# Select Subnets
$Subnet_ether1 = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $SubnetName_ether1
$Subnet_ether2 = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $SubnetName_ether2

# Create Public IP
$PublicIP = New-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroup -Location $Location -AllocationMethod Dynamic -IdleTimeoutInMinutes 4 -Name "mt$(Get-Random)"

# Create an inbound network security group rule for port 8291
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name MTManage -Protocol Tcp -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 8291 -Access Allow
# Create an inbound network security group rule for port 80
$nsgRuleWeb = New-AzureRmNetworkSecurityRuleConfig -Name MTWWW -Protocol Tcp -Direction Inbound -Priority 1010 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $ResourceGroup -Location $Location -Name Mikrotik_NSG -SecurityRules $nsgRuleRDP,$nsgRuleWeb

# Create a virtual network card and associate with public IP address and NSG
$nic_ether1 = New-AzureRmNetworkInterface -Name ether1 -ResourceGroupName $ResourceGroup -Location $Location -SubnetId $Subnet_ether1.Id -PublicIpAddressId $PublicIP.Id -NetworkSecurityGroupId $nsg.Id -EnableIPForwarding
# Create additional virtual network card
$nic_ether2 = New-AzureRmNetworkInterface -Name ether2 -ResourceGroupName $ResourceGroup -Location $Location -SubnetId $Subnet_ether2.Id -EnableIPForwarding


# Prepare VM Config
$vm = New-AzureRmVMConfig -VMName $VMName -VMSize $VMSize

# Add NIC
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic_ether1.Id -Primary
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic_ether2.Id

# Attach Disk
$vm = Set-AzureRmVMOSDisk -VM $vm -Name "MT_OS" -VhdUri $urlOfUploadedVhd -Caching ReadWrite -CreateOption Attach -Linux
$vm.OSProfile = $null

# Create the new VM
New-AzureRmVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vm -Verbose

