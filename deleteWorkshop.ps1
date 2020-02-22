Select-AzureRmSubscription -Subscription "Microsoft Azure Sponsorship"
$counter=1
$nrUsers = 20
$maxUsers = $startCounter + $nrUsers
for (;$counter -le $maxUsers; $counter++)
{
    $rgName ="sec-st-rg"+$counter
    Remove-AzureRmResourceGroup -Name $rgName -Force -AsJob
}
