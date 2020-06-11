--Declare/assign our example xml blob
DECLARE @XML XML
SET @XML = '
<Order Id="1234">
    <Items>
        <Item PartId="A1111" Qty="1">
            <Description>Motherboard</Description>
        </Item>
        <Item PartId="B2222" Qty="2">
            <Description>Graphics Card</Description>
        </Item>
        <Item PartId="C3333" Qty="4">
            <Description>2gb Ram</Description>
        </Item>
        <Item PartId="D4444" Qty="1">
            <Description>700w PSU</Description>
        </Item>
        <Item PartId="E5555" Qty="2">
            <Description>300gb SSD</Description>
        </Item>
    </Items>
</Order>'
 
--Main xquery to enumerate the <Item> nodes and to return them with a new Position attribute
SELECT @XML.query('
for $Items in /Order/Items
 
return
 
(: safety check to return <Error/> if array is smaller than node count. Ensures nodes are not lost :)
if 
    (count( (1,2,3,4,5,6,7,8,9,10) ) < count($Items/*))
 
then
    <Error>Array too small.</Error>
 
else
    <Order>
        { /Order/@* }
        <Items>
            {
                for $SeqItem in (1,2,3,4,5,6,7,8,9,10)[. le count($Items/*)]
                return
                    (: add new Position attribute to <Item> node and append all other attributes and nodes :)
                    <Item Postition="{$SeqItem}">
                        { $Items/*[$SeqItem]/@* }
                        { $Items/*[$SeqItem]/node() }
                    </Item>
            }
        </Items>
    </Order>
')