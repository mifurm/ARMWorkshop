#Install-Module AzureAD
#Connect-AzureAD
 
#$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
#$PasswordProfile.Password = "bardzoskomplikowanehaslo123!@#"
 
#id pierwszego użytkownika
#$startCounter=1
#$counter=$startCounter
#konwencja nazewnicza dla Twoich użytkowników
#$userName = "student"+$counter
#UPN. Uważaj: sprawdź, czy taki UPN istnieje w Twojej domenie w Azure AD. 
#$upn = $userName +"@mbankk8s.onmicrosoft.com"
#konwencja nazewnicza dla Twoich grup zasobów
#$rgName ="st-rg"+$counter
#maksymalna liczba użytkowników 
#$nrUsers = 2
#$maxUsers = $startCounter + $nrUsers

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
