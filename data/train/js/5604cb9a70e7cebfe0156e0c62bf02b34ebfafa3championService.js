angular.module('ApData').factory('ChampionService', function() {
   var ChampionService = {};

   ChampionService.isLoading = true;

   ChampionService.repopulateData = function(champion, region, ranked, stat){
      ChampionService.id = champion.id;
      ChampionService.name = champion.name;
      ChampionService.image = champion.image;
      ChampionService.labels = ['a',"b","c","d","e","f","g","h","i"]
      if(ranked){
        ChampionService.data = [[1,6,2,4,8,2,2,4,9],
                                  [2,6,4,8,2,2,9,3,3]]
      }
      if(region == 'NA'){
        ChampionService.data = [[5,2,8,3,9,3,2,3,4],
                                  [2,3,4,2,1,3,6,7,8]]
      }
      if(stat == "Deaths"){
        ChampionService.data = [[5,8,2,3,9,3,2,3,4],
                                  [2,3,4,2,1,3,6,7,8]]
      }

      ChampionService.isLoading = false;
   }
   return ChampionService;
 });
