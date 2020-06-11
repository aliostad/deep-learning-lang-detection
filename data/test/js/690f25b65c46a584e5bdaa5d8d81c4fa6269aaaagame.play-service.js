class PlayService {
    constructor($http,serviceUrlForplay,serviceUrlForComputerInput) {
        this.$http = $http;
        this.serviceUrlForplay = serviceUrlForplay;
        this.serviceUrlForComputerInput = serviceUrlForComputerInput;
    }

    getComputerChoice(){
       return this.$http.get(`${this.serviceUrlForComputerInput}`);
    }

    play(player1Choice,player2Choice){
       return this.$http.get(`${this.serviceUrlForplay}/${player1Choice}/${player2Choice}/`);
    }
}

PlayService.$inject = ["$http","serviceUrlForplay","serviceUrlForComputerInput"];
module.exports = PlayService;