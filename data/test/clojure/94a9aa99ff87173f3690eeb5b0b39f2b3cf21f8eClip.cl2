#include ccl/jaudio/Audio.cl2

{
    def Clip(AudioStream, AudioPlayer, source){
        var stream = AudioStream(source);
        var player = AudioPlayer.player;
        
        def start(player, stream){
            player.start(stream);
        }
        def stop(player, stream){
            player.stop(stream);
        }
        
        return [
            stream:stream,
            player:player,
            start:start.bind(player, stream),
            stop:stop.bind(player, stream)
        ];
    }
    
    Audio.push(Clip.bind(
        java("sun.audio.AudioStream"), java("sun.audio.AudioPlayer")
    ), "Clip");
}