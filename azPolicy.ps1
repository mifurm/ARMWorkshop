$subId="a58b60a2-5cca-4e6f-8a14-821effa10570"
$tenantId="3af927be-96cb-44c3-8f37-8af22dcac359"

Connect-AzAccount -Tenant $tenantId -SubscriptionId $subId

Get-AzPolicyDefinition -Name "Allowed resource types" 
Get-AzPolicyDefinition -Id "/providers/Microsoft.Authorization/policyDefinitions/a08ec900-254a-4555-9bf5-e42af04b5c5c"

Get-AzPolicyAssignment 

$l=Get-AzPolicyAssignment
$l[0]
foreach ($p in $l[0].Properties.parameters.listOfResourceTypesAllowed.value) {Write-Output $p}
