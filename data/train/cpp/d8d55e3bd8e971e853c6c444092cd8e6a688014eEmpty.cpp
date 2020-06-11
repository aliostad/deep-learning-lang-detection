#include <windows.h>
#include <stdio.h>
#include <math.h>
#include "g4c.h"
#include "HangMan.h"

void main()
{
	
//////////////////////////////////////////////////////////
	    load_sprite("images/0.bmp",0);
		load_sprite("images/1.bmp",1);
		load_sprite("images/2.bmp",2);
		load_sprite("images/3.bmp",3);
		load_sprite("images/4.bmp",4);
		load_sprite("images/5.bmp",5);
		load_sprite("images/6.bmp",6);
		load_sprite("images/7.bmp",7);
		load_sprite("images/8.bmp",8);
		load_sprite("images/9.bmp",9);
		load_sprite("images/10.bmp",10);
		load_sprite("images/11.bmp",11);
		load_sprite("images/12.bmp",12);
		load_sprite("images/13.bmp",13);
///////////////////////////////////////////////////////////
		HangMan Game ;
		PlaySound(TEXT("3.wav"), NULL, SND_ASYNC|SND_FILENAME|SND_LOOP);  //for the music.
		Game.startGame();


}