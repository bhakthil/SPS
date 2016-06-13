Add-Type –Path "C:\Development\SharePoint\Client\Microsoft.SharePoint.Client.dll" 
Add-Type –Path "C:\Development\SharePoint\Client\Microsoft.SharePoint.Client.Runtime.dll"

$siteUrl = “” ;
$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($siteUrl) ;

<# Authenticate with the SharePoint Online site. 
if ($global:spoCred -eq $null) { 
    $password = Read-Host -Prompt "Enter password" -AsSecureString;
    #$cred = Get-Credential -Message "Enter your credentials for SharePoint Online:" ;
    $spoCred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials("bhakthil@liyanage.onmicrosoft.com", $password) ;
} 

$ctx.Credentials = $spoCred;
#>

$web = $ctx.Web;


$newFile = New-Object Microsoft.SharePoint.Client.FileCreationInformation;
$newFile.ContentStream = New-Object IO.FileStream("C:\Development\spsevents\SPS-master\Reston\SPSDC2015-csom-powershell.pptx",[System.IO.FileMode]::Open) ;
$newFile.Url = "SPSDC2015-csom-powershell.pptx" ;
$newFile.Overwrite = $true;

[Microsoft.SharePoint.Client.List] $docs = $web.Lists.GetByTitle("Documents");
$ctx.Load($docs);
$ctx.ExecuteQuery();

$uploadFile = $docs.RootFolder.Files.Add($newFile);
$ctx.Load($uploadFile);
$ctx.ExecuteQuery();

$item = $uploadFile.ListItemAllFields;

$item[“Title”] = "SPSDC2015-csom-powershell.pptx" ;
#$item[“Created by”] = ;
$item.Update();

$ctx.ExecuteQuery();







