namespace PnpGrid

open WebSharper.JavaScript
open WebSharper.UI.Next

open Entities

module DroppedTileset =   
    [<Sealed>]
    type Page = 
        member content : Doc View
        ///Sets the position of the tileset from the lower left corner.
        member setPosition : Rectangle -> unit
        member setDragHandler : (Dom.Element -> Dom.MouseEvent -> unit) -> (Dom.Element -> Dom.Event -> unit) -> 
                                (Dom.Element -> Dom.Event -> unit) -> unit
        member setCancelHandler : (unit -> unit) -> unit
        member setAcceptHandler : (PlacedTile list -> unit) -> unit
        member data : Tileset
        member position : unit -> Rectangle
        member getTilesetView : unit -> TilesetDoc.Page
    val mkPage : Tileset -> Rectangle -> Page
    val dropPage : TilesetDoc.Page -> Page