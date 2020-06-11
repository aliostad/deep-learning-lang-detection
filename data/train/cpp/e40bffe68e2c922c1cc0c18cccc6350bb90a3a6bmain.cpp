#include <Component.h>
#include <Angle.h>
#include <iostream>

#include <AudioVault.h>

using std::cout;
using std::endl;

int main() {

    SDL_Init(SDL_INIT_AUDIO);
    Mix_OpenAudio( 22050, MIX_DEFAULT_FORMAT, 2, 4096 );

    AudioVault av;

    Mix_Chunk* unsafe_chunk = av.CheckChunk("beat.wav");
    //Mix_Chunk* unsafe_chunk = Mix_LoadWAV("beat.wav");

    cout<<"unsafe_chunk "<< unsafe_chunk <<endl;

    std::shared_ptr<Mix_Chunk*> chunk = av.GetChunk("beat.wav");

    cout<<"chunk "<< *chunk <<endl;

    std::shared_ptr<Mix_Chunk*> chunk2 = av.GetChunk("beat.wav");

    cout<<"chunk2 "<< *chunk2 <<endl;

    unsafe_chunk = av.CheckChunk("beat.wav");

    cout<<"unsafe_chunk 2 "<< unsafe_chunk <<endl;

    av.Purge();
//    cout<<""<<  <<endl;

    return 0;

}
