'use strict';
import Clone from 'clone';
import ChangeEventEmitter from './utils/changeEventEmitter';
import Dispatcher from '../dispatcher';
import * as BroadcastUtil from './utils/broadcastUtil';

class ShowStore extends ChangeEventEmitter {
    constructor(){
        super();
        this.shows = [];

        var self = this;

        this.setShows = function(shows){
            self.shows = shows;
            self.emitChange();
        };

        this.pushShows = function(_shows){
            for (var i = 0; i < _shows.length; i++){
                this.pushShow(_shows[i]);
            }
        };

        this.pushShow = function(show){
            var clonedShows = Clone(self.shows);
            var remainingShows = clonedShows.filter((s) => s.Id != show.Id);
            remainingShows.push(show);
            self.setShows(remainingShows);
        };

        this.removeShow = function(showId){
            var clonedShows = Clone(self.shows);
            var remainingShows = clonedShows.filter((s) => s.Id != showId);
            self.setShows(remainingShows);
        };

        this.getShows = function(){
            return self.shows.sort((a, b) => a.Id - b.Id);
        };

        this.get = function(showId){
            if(self.shows.find){
                return Clone(self.shows.find((show) => show.Id == showId));
            } else { //browser does not support find
                for (var i = 0; i < self.shows.length; i++) {
                    var show = self.shows[i];
                    if(show.Id == showId){
                        return Clone(show);
                    }
                }
            }
            return null;
        };

        this.handleAction = function(action){
            switch(action.type){
                case "LOAD_SHOWS":
                    //TODO
                    break;
                case "LOAD_SHOWS_SUCCESS":
                    self.pushShows(action.shows);
                    break;
                case "LOAD_SHOWS_FAIL":
                    //TODO
                    break;
                case "LOAD_SHOW":
                    //TODO
                    break;
                case "LOAD_SHOW_SUCCESS":
                    self.pushShow(action.show);
                    break;
                case "LOAD_SHOW_FAIL":
                    //TODO
                    break;
                case "ADD_SHOW":
                    //TODO
                    break;
                case "ADD_SHOW_SUCCESS":
                    self.pushShow(action.show);
                    BroadcastUtil.broadcastShowChange(action.groupName);
                    break;
                case "ADD_SHOW_FAIL":
                    //TODO
                    break;
                case "UPDATE_SHOW":
                    //TODO
                    break;
                case "UPDATE_SHOW_SUCCESS":
                    self.pushShow(action.show);
                    BroadcastUtil.broadcastShowChange(action.groupName);
                    break;
                case "UPDATE_SHOW_FAIL":
                    //TODO
                    break;
                case "REMOVE_SHOW":
                    //TODO
                    break;
                case "REMOVE_SHOW_SUCCESS":
                    self.removeShow(action.showId);
                    BroadcastUtil.broadcastShowChange(action.groupName);
                    break;
                case "REMOVE_SHOW_FAIL":
                    //TODO
                    break;
            }
        };

        Dispatcher.register(this.handleAction.bind(this));
    }  
}

export default new ShowStore();