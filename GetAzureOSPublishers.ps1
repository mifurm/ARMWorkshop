
$locName="West Europe"
$pubName="MicrosoftWindowsServer"
#Get-AzVMImageOffer -Location $locName -PublisherName $pubName | Select Offer
$offerName="WindowsServer"
#Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select Skus
$skuName="2019-Datacenter"
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version

$pubName="MicrosoftWindowsServer"
#Get-AzVMImageOffer -Location $locName -PublisherName $pubName | Select Offer
$offerName="WindowsServer"
#Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select Skus
$skuName="2019-Datacenter"
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select Version

$locName="West Europe"
Get-AzVMImagePublisher -Location $locName | Select PublisherName
