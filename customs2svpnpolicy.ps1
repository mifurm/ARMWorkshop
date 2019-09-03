$VNet1       = "VNet1"
$Connection1 = "corenetwork_s2sconnection"
$RG1         = "sharedservices_rg"
$Gw1         = "corenetwork_vpngw"
$LNG1        = "corenetwork_lclnetworkgw"

$vng1 = Get-AzVirtualNetworkGateway -Name $GW1  -ResourceGroupName $RG1
$lng1 = Get-AzLocalNetworkGateway   -Name $LNG1 -ResourceGroupName $RG1

#New-AzVirtualNetworkGatewayConnection -Name $Connection1 -ResourceGroupName $RG1 -Location $Location1 -VirtualNetworkGateway1 $vng1 -LocalNetworkGateway2 $lng1 -ConnectionType IPsec -SharedKey "Azure@!b2C3"
$Connection1 = "corenetwork_s2sconnection"
$connection = Get-AzVirtualNetworkGatewayConnection -Name $Connection1 -ResourceGroupName $RG1

$newpolicy  = New-AzIpsecPolicy `
  -IkeEncryption AES256 -IkeIntegrity SHA256 -DhGroup DHGroup24 `
  -IpsecEncryption AES256 -IpsecIntegrity SHA256 -PfsGroup PFS2048

Set-AzVirtualNetworkGatewayConnection -VirtualNetworkGatewayConnection $connection `
-IpsecPolicies $newpolicy -UsePolicyBasedTrafficSelectors $True
