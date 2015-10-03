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

$list = $ctx.Web.Lists.getByTitle('Announcements');

[Microsoft.SharePoint.Client.ListItemCreationInformation] $itemCreateInfo = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation; 
[Microsoft.SharePoint.Client.ListItem] $newItem = $list.AddItem($itemCreateInfo); 
$newItem["Title"] = "My New Item!"; 
$newItem["Body"] = "PowerShell automation rocks"; 
$newItem["Expires"] = [System.DateTime]::Now;
$newItem.Update(); 
$ctx.ExecuteQuery() ;


