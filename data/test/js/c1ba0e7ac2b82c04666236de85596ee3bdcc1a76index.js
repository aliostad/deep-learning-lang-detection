import constants from '../constants';
import Dispatcher from '../dispatcher';

export default {
    select( index )
    {
        Dispatcher.dispatch( {
            actionType: constants.SELECT,
            index: index
        } );
    },

    addSong( data )
    {
        Dispatcher.dispatch( {
            actionType: constants.ADD_SONG,
            data: data
        } );
    },

    addSongs( data )
    {
        if ( data.length > 0 )
        {
            Dispatcher.dispatch( {
                actionType: constants.ADD_SONGS,
                data: data
            } );
        }
    },

    removeSong( index )
    {
        Dispatcher.dispatch( {
            actionType: constants.REMOVE_SONG,
            index: index
        } );
    },

    removeAll()
    {
        Dispatcher.dispatch( {
            actionType: constants.REMOVE_ALL
        } );
    },

    stop()
    {
        Dispatcher.dispatch( {
            actionType: constants.STOP
        } );
    },

    togglePlay()
    {
        Dispatcher.dispatch( {
            actionType: constants.PLAY
        } );
    },

    next()
    {
        Dispatcher.dispatch( {
            actionType: constants.NEXT
        } );
    },

    previous()
    {
        Dispatcher.dispatch( {
            actionType: constants.PREVIOUS
        } );
    },

    toggleShuffle()
    {
        Dispatcher.dispatch( {
            actionType: constants.SHUFFLE
        } );
    },

    circleRepeat()
    {
        Dispatcher.dispatch( {
            actionType: constants.REPEAT
        } );
    }
};
