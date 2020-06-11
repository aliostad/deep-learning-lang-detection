import {frameChange, pageChange, trackChange} from './constants';
import {audio, analyser, waveData} from './_player';

let frame = 0;
let execDispatch = () => {};
if (!window.tickerRunning) {
    window.tickerRunning = true;
    requestAnimationFrame(function draw () {execDispatch(requestAnimationFrame(draw))});
}

export function _init (store) {
    const dispatch = store.dispatch.bind(store);
    audio.addEventListener('canplay', () =>
        dispatch({type: trackChange, result: audio.currentTrack}));

    execDispatch = () => dispatch({type: frameChange, result: frame++}); //to trigger the store change
}
