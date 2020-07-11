Select-AzureRmSubscription -Subscription "Microsoft Azure Sponsorship"
$counter=1
$nrUsers = 20
$maxUsers = $startCounter + $nrUsers
for (;$counter -le $maxUsers; $counter++)
{
    $rgName ="sec-st-rg"+$counter
    Remove-AzureRmResourceGroup -Name $rgName -Force -AsJob
}

#
#
# az group list --query "[?starts_with(name, 'stk8srg')].[name]" --output tsv | xargs -n 1 bash -c 'az group delete -n $0 --yes --no-wait'
#
