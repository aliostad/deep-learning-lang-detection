(function ($, window) {
   
   var player = window.courrrt.player;
   
   var shot = function (api) {
      return {
         id: api.id,
         title: api.title,
         url: api.url,
         createdAt: new Date(api.created_at),
      
         image: {
            teaser_url: api.image_teaser_url,
            url: api.image_url,
            width: api.width,
            height: api.height
         },
      
         counts: {
            views: api.views_count,
            comments: api.comments_count,
            likes: api.likes_count
         },
      
         player: new player(api.player)
      };
   };
   
   // Export to global namespace: courrrt.shot
   $.extend(window.courrrt, { shot: shot });
   
})(jQuery, window);