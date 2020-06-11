<?php
require_once("manageParentEntry.php");
$user = $_SESSION['authUser'];
if($user==null)
{
    header("HTTP/1.0 403 Forbidden");
    echo "Error:no user set!";
    return;
}

if(isset($_REQUEST['copySourceUUID']))
{
    $copySourceUUID = $_REQUEST["copySourceUUID"];
    $copySource =$em->getRepository('library\doctrine\Entities\DocumentEntry')->find($copySourceUUID);
}
// TODO: Check to see if a copy or a link to this entry already exists.  If So, then abort.

if($copySource->getItem()->getRoot()!=$parentEntry->getItem()->getRoot())
{
    $copy = $copySource->copy($user);
    $parentEntry->getItem()->addEntry($copy);
    if($copySource->getType()=="MedicationEntry")
    {
        foreach($copySource->getSIGs() as $SIG)
        {
            $copy->getItem()->addEntry($SIG->copy($user));
        }
    }
    $em->flush();
    
}
else
{
    $link = new library\doctrine\Entities\DocumentLink($copySource->getMetadata(),$pat,$user,$copySource);
    $parentEntry->getItem()->addEntry($link);
    $em->flush();
}

require_once("refreshCheck.php");
?>
