﻿Add-Type –Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll" 
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

$web = $ctx.Web;
[Microsoft.SharePoint.Client.WebCreationInformation] $webInfo = New-Object Microsoft.SharePoint.Client.WebCreationInformation; 
$webInfo.Url = "spsclt15"; 
$webInfo.Title = "SharePoint saturday CLT 2016"; 
[Microsoft.SharePoint.Client.Web] $newWeb = $web.Webs.Add($webInfo); 
$ctx.ExecuteQuery() ;

