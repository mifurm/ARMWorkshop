$resourceProviders=Get-AzResourceProvider -ListAvailable | Select-Object ProviderNamespace
foreach ($r in $resourceProviders) 
{ 
  $resources=(Get-AzResourceProvider -ProviderNamespace $r.ProviderNamespace).ResourceTypes.ResourceTypeName; 
  foreach($rs in $resources) 
  {
    $s=[string]::Format("""{0}/{1}"",",$r.ProviderNamespace,$rs); 
    Write-Output $s;
  }
}
