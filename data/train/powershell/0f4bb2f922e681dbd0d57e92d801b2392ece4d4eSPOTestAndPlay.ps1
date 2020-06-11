SP.List oList = clientContext.Web.Lists.GetByTitle("List Title Here"); 
SP.FieldCollection fieldColl = oList.Fields;
clientContext.Load(fieldColl);
clientContext.ExecuteQuery();

foreach (SP.Field fieldTemp in fieldColl)
{
    MessageBox.Show(fieldTemp.InternalName.ToString()); //I used MessageBox to show, but you can do whatever you like with it here.
}

$list = $ctx.Web.Lists.GetByTitle("Shared Documents")
$fieldCol = $list.Fields
$ctx.Load($fieldCol)
$ctx.ExecuteQuery()
foreach($field in $fieldCol){$field.InternalName}
$field = $fieldCol | ? {$_.InternalName -eq "Title"}

#Get List Items (need to loop through each item to get each one and get them one at a time)
$query = New-Object Microsoft.SharePoint.Client.CamlQuery
$query.ViewXml = "<View><Query><OrderBy><FieldRef Name='ID' /></OrderBy></Query></View>"
$listitems = $list.GetItems($query)
$ctx.Load($listitems)
$ctx.ExecuteQuery()
$listitems.Count

#Get an Item
$item = $list.GetItemById(32)
$ctx.Load($item)
$ctx.ExecuteQuery()
$item.FieldValues

#Content Types
$list = $ctx.Web.Lists.GetByTitle("Shared Documents")
$contentTypes = $list.ContentTypes
$ctx.Load($contentTypes)
$ctx.ExecuteQuery()
$contentTypes
foreach($ct in $contentTypes){$ct.Name}