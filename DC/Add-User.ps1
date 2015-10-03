Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll" 

$siteUrl = “https://liyanage.sharepoint.com/sites/developer” ;
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) ;

<# Authenticate with the SharePoint Online site. #>
if ($global:spoCred -eq $null) { 
    $password = Read-Host -Prompt "Enter password" -AsSecureString;
    #$cred = Get-Credential -Message "Enter your credentials for SharePoint Online:" ;
    $spoCred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("bhakthil@liyanage.onmicrosoft.com", $password) ;
} 

$ctx.Credentials = $spoCred;

[Microsoft.SharePoint.Client.UserCreationInformation] $userCreateInfo = New-Object Microsoft.SharePoint.Client.UserCreationInformation; 
$userCreateInfo.Email = "aston.martin@liyanage.onmicrosoft.com";
$userCreateInfo.Title = "Aston Martin";
$userCreateInfo.LoginName = "aston.martin@liyanage.onmicrosoft.com";
                       
$spGroups=$ctx.Web.SiteGroups ;
$ctx.Load($spGroups);
$ctx.ExecuteQuery()   ;
                 
#Getting the specific SharePoint Group where we want to add the user 
$spGroup=$spGroups.GetByName("Developer Site Visitors"); 
$ctx.Load($spGroup) ;
$ctx.ExecuteQuery()   ; 
              
#Ensuring the user we want to add exists 
$user = $ctx.Web.EnsureUser("aston.martin@liyanage.onmicrosoft.com") ;
$ctx.Load($user) ;
$ctx.ExecuteQuery()   ;
        
$spUserToAdd=$spGroup.Users.AddUser($user) ;
$ctx.Load($spUserToAdd) ;
$ctx.ExecuteQuery()   ;   
      