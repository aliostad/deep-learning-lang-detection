<?php
//BindEvents Method @1-9C2DAAF1
function BindEvents()
{
    global $events;
    global $events1;
    $events->Records->CCSEvents["BeforeShow"] = "events_Records_BeforeShow";
    $events->CCSEvents["BeforeShow"] = "events_BeforeShow";
    $events1->CCSEvents["BeforeShow"] = "events1_BeforeShow";
}
//End BindEvents Method

//events_Records_BeforeShow @81-DE975317
function events_Records_BeforeShow(& $sender)
{
    $events_Records_BeforeShow = true;
    $Component = & $sender;
    $Container = & CCGetParentContainer($sender);
    global $events; //Compatibility
//End events_Records_BeforeShow

//Retrieve number of records @82-ABE656B4
    $Component->SetValue($Container->DataSource->RecordsCount);
//End Retrieve number of records

//Close events_Records_BeforeShow @81-410E8374
    return $events_Records_BeforeShow;
}
//End Close events_Records_BeforeShow

//events_BeforeShow @60-D1EA5CBB
function events_BeforeShow(& $sender)
{
    $events_BeforeShow = true;
    $Component = & $sender;
    $Container = & CCGetParentContainer($sender);
    global $events; //Compatibility
//End events_BeforeShow

//Hide-Show Component @90-4176DB5D
    $Parameter1 = $Container->Records->GetValue();
    $Parameter2 = 1;
    if (0 == CCCompareValues($Parameter1, $Parameter2, ccsInteger))
        $Component->Visible = false;
//End Hide-Show Component

//Close events_BeforeShow @60-D2B27383
    return $events_BeforeShow;
}
//End Close events_BeforeShow

//events1_BeforeShow @45-84A61581
function events1_BeforeShow(& $sender)
{
    $events1_BeforeShow = true;
    $Component = & $sender;
    $Container = & CCGetParentContainer($sender);
    global $events1; //Compatibility
//End events1_BeforeShow

//Hide-Show Component @91-1F8E5136
    $Parameter1 = CCGetFromGet("event_id", "");
    $Parameter2 = "";
    if (0 == CCCompareValues($Parameter1, $Parameter2, ccsText))
        $Component->Visible = false;
//End Hide-Show Component

//Close events1_BeforeShow @45-43372401
    return $events1_BeforeShow;
}
//End Close events1_BeforeShow


?>
