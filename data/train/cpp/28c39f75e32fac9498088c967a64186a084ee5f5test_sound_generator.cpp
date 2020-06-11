// Test Code For sound_generator.
#include <fmod.hpp>
#include <fmod_errors.h>
#include "sound_generator.h"
#include "bit_rep.h"
#include <vector>
#include <Windows.h>
#include <stdio.h>
#include <conio.h>

int testSoundGenerator() {
    SoundGenerator  *test = new SoundGenerator();
    BitRep          *sample = new BitRep(6,10);
    int             key;

    // Init sound:
    test->init();
    // Create a bit rep (hardcoded):
    //___0_1_2_3_4_5
    //0: 1 1 1 1 0 0 
    //1: 0 0 0 0 1 0 
    //2: 0 0 0 0 0 1 
    //3: 0 0 0 0 0 1 
    //4: 0 0 0 0 1 0 
    //5: 0 0 0 1 0 0 
    //6: 0 0 1 0 0 0 
    //7: 0 1 0 0 0 0 
    //8: 1 0 0 0 0 0 
    //9: 0 0 0 0 0 0 
    // col 1:
    sample->setBit(0,0,true);
    sample->setBit(1,0,false);
    sample->setBit(2,0,false);
    sample->setBit(3,0,false);
    sample->setBit(4,0,false);
    sample->setBit(5,0,false);
    sample->setBit(6,0,false);
    sample->setBit(7,0,false);
    sample->setBit(8,0,true);
    sample->setBit(9,0,false);
    // col 2:
    sample->setBit(0,1,true);
    sample->setBit(1,1,false);
    sample->setBit(2,1,false);
    sample->setBit(3,1,false);
    sample->setBit(4,1,false);
    sample->setBit(5,1,false);
    sample->setBit(6,1,false);
    sample->setBit(7,1,true);
    sample->setBit(8,1,false);
    sample->setBit(9,1,false);
    // col 3:
    sample->setBit(0,2,true);
    sample->setBit(1,2,false);
    sample->setBit(2,2,false);
    sample->setBit(3,2,false);
    sample->setBit(4,2,false);
    sample->setBit(5,2,false);
    sample->setBit(6,2,true);
    sample->setBit(7,2,false);
    sample->setBit(8,2,false);
    sample->setBit(9,2,false);
    // col 4:
    sample->setBit(0,3,true);
    sample->setBit(1,3,false);
    sample->setBit(2,3,false);
    sample->setBit(3,3,false);
    sample->setBit(4,3,false);
    sample->setBit(5,3,true);
    sample->setBit(6,3,false);
    sample->setBit(7,3,false);
    sample->setBit(8,3,false);
    sample->setBit(9,3,false);
    // col 5:
    sample->setBit(0,4,false);
    sample->setBit(1,4,true);
    sample->setBit(2,4,false);
    sample->setBit(3,4,false);
    sample->setBit(4,4,true);
    sample->setBit(5,4,false);
    sample->setBit(6,4,false);
    sample->setBit(7,4,false);
    sample->setBit(8,4,false);
    sample->setBit(9,4,false);
    // col 6:
    sample->setBit(0,5,false);
    sample->setBit(1,5,false);
    sample->setBit(2,5,true);
    sample->setBit(3,5,true);
    sample->setBit(4,5,false);
    sample->setBit(5,5,false);
    sample->setBit(6,5,false);
    sample->setBit(7,5,false);
    sample->setBit(8,5,false);
    sample->setBit(9,5,false);
    printf("===================================================================\n");
    printf("                       SoundGenerator example.                     \n");
    printf("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n");
    printf("                                                                   \n");
    printf("Press 'N' to play next sound column.\n");
    printf("Press 'ESC' to quit\n");
    printf("\n");

    vector<bool> to_play = sample->getCurrentVector();

    /*
        Main loop.
    */

    do {
        if (_kbhit()) {
            key = _getch();
            switch (key) {
            case 'n':
            case 'N':
                to_play = sample->getCurrentVector();
                test->play(to_play);
                sample->display();
                sample->incrementCol();
                break;
            }
        }

        //Sleep(10);

    } while (key != 27);

    delete test;


    return 0;
}