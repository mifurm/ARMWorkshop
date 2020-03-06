#Set-AzContext -Subscription "Microsoft Azure Sponsorship"
#Connect-AzureAD
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Testtest123!@#"
$counter=1
$nrUsers = 20
$maxUsers = $startCounter + $nrUsers
for (;$counter -le $maxUsers; $counter++)
{
    $userName = "student"+$counter
    $upn = $userName +"@<TWOJA DOMENA>.onmicrosoft.com"
    $rgName ="st-rg"+$counter
    New-AzureADUser -DisplayName $userName -PasswordProfile $PasswordProfile -UserPrincipalName $upn -AccountEnabled $true -MailNickName $userName
    New-AzureRmResourceGroup -Name $rgName -Location 'West Europe'
    New-AzureRmRoleAssignment -SignInName $upn ` -RoleDefinitionName "Contributor" -ResourceGroupName $rgName
}
