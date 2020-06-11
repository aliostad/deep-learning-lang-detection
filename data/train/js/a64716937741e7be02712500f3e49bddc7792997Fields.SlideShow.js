Fields.SlideShow={
    edit:function(slideShowModel){
        ModalSlideShow.open(slideShowModel.id());
        
        ModalSlideShow.onSave=function(slideShowId){
            slideShowModel.jq.attr(Model.CTRL.DATA_MODEL_ID,slideShowId);
            slideShowModel.refresh();
            }
    }
}

Fields.SlideShow.CTRL={
    EDIT:"a[href='#Fields.SlideShow.edit']"
}


JQ.bo.on("click",Fields.SlideShow.CTRL.EDIT,function(e){
    e.preventDefault();
    var slideShowModel=Model.getParent($(this));
    Fields.SlideShow.edit(slideShowModel);
})



/*
*  this content it will be the new sldieshow later without ajax request and data insertion 
*  @author : francois
*/

/*
Fields.SlideShow={
    edit:function(block){
        
            
        var slideShow = block.find('[data-model-type]');
                
        var slideShowId = slideShow.attr("data-model-id");

        ModalSlideShow.open(slideShowId);
        
        ModalSlideShow.onSave=function(slideShowId){
            
            var slideShowContent = $("#" + slideShowId);
            
            if( slideShowContent.length > 0 ) {                        
                // the block type 
                var blockType = $("<div/>", {
                "data-model-type":"SlideShow",
                "data-model-id":slideShowId
                })

                 // insertion html 
                slideShowContent.html("");
                
                blockType.appendTo(slideShowContent);

                // insertion html 
                ModalSlideShow.ajaxTarget.find(".data-block-menu").clone().appendTo(slideShowContent);
                ModalSlideShow.ajaxTarget.find(".slideshow-edit-button").clone().appendTo(blockType);                        
                ModalSlideShow.ajaxTarget.find(".slides_container").clone().appendTo(blockType)

                blockType.find(".slides_container").find(".block-menu").addClass("hidden");
                blockType.find(".slideshow-edit-button").removeClass("hidden");                        
                blockType.appendTo(slideShowContent);                        
                slideShowContent.find(".data-block-menu").removeClass("hidden");

                // start the slideshow       
                slideShowContent.slides({
                    paginationClass: 'pagination_slides',
                    effect: 'fade',
                    play: 5000,
                    bigTarget: true
                });    
                                   
            }   
        }
    }
}
Fields.SlideShow.CTRL={
    EDIT:"a[href='#Fields.SlideShow.edit']"
}

JQ.bo.on("click",Fields.SlideShow.CTRL.EDIT,function(e){
    e.preventDefault();
    
    var block = $(this).parent().closest(".block-SlideShow");
                           
    Fields.SlideShow.edit(block);
})*/