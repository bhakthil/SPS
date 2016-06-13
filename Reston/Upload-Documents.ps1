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
$Folder = "C:\Development\csomdemo"
$web = $ctx.Web;




[Microsoft.SharePoint.Client.List] $docs = $web.Lists.GetByTitle("Documents");
$ctx.Load($docs);
$ctx.ExecuteQuery();

Foreach ($File in (dir $Folder -File))
{
    Write-Host "Uploading " $File.FullName;
    $newFile = New-Object Microsoft.SharePoint.Client.FileCreationInformation;
    $newFile.ContentStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open) ;
    $newFile.Url = $File ;
    $newFile.Overwrite = $true;


    $uploadFile = $docs.RootFolder.Files.Add($newFile);
    $ctx.Load($uploadFile);
    #$ctx.ExecuteQuery();

    $item = $uploadFile.ListItemAllFields;
   # $item[“Title”] = "SPSDC2015-csom-powershell.pptx" ;
    $item.Update();
    $ctx.ExecuteQuery();
}













