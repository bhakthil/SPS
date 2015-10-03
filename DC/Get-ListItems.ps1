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

#$query = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery(10000, 'UniqueId','ID','Created','Modified','FileLeafRef','Title');
$query = New-Object Microsoft.SharePoint.Client.CamlQuery;
$query.ViewXml = "<View><Query></Query></View>";

$listItems = $list.GetItems($query);
$ctx.Load($listItems);
$ctx.ExecuteQuery() ;

$tasks =@();
foreach ($listItem in $listItems)
{
    
    $o = new-object psobject
    $o | Add-Member -MemberType noteproperty -Name Title -value $listItem['Title'];
    $o | Add-Member -MemberType noteproperty -Name ID -value $listItem['ID'];
    $o | Add-Member -MemberType noteproperty -Name Modified -value $listItem['Modified'];
    $tasks += $o;
    
}
 
$tasks | export-csv "C:\spsevents\Tasks_Export.csv" -noTypeInformation;


