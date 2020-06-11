package main

import (
	"sdl"
	"sdl/mixer"
)

var IM *Images
var MU *Sound

type Images struct {
	Cecil [][]*sdl.Surface
	Shots []*sdl.Surface
	Monsters [][]*sdl.Surface
	Misc	[]*sdl.Surface
	BG []*sdl.Surface
	Tiles map[int]*sdl.Surface
	Obj	[]*sdl.Surface
}

func LoadImages() *Images {
	i := new(Images)
	//Setup Cecil
	stand := []*sdl.Surface{loadImage("img/cecil-stand-left.gif"),loadImage("img/cecil-stand-right.gif")}
	
	walk := []*sdl.Surface{loadImage("img/cecil-walk-left.gif"),loadImage("img/cecil-stand-left.gif"),
							loadImage("img/cecil-walk-right.gif"),loadImage("img/cecil-stand-right.gif")}
	
	shoot := []*sdl.Surface{loadImage("img/cecil-shoot-left.gif"), loadImage("img/cecil-shoot-right.gif")}
	
	i.Cecil = [][]*sdl.Surface{stand, walk, shoot}
	
	//Setup Shots
	i.Shots = []*sdl.Surface{loadImage("img/shot-1.gif"),
							loadImage("img/shot-2.gif"),
							loadImage("img/shot-3.gif")}
							
	//Setup Monsters
	ghost := []*sdl.Surface{loadImage("img/ghost.gif")}
	deathshell := []*sdl.Surface{loadImage("img/deathshell.gif"), 
								loadImage("img/boss-2-left.gif"), loadImage("img/boss-2-right.gif")}
	robot := []*sdl.Surface{loadImage("img/robot-left.gif"),loadImage("img/robot-right.gif"),
							loadImage("img/boss-1-left.gif"),loadImage("img/boss-1-right.gif")}
							
	malboro := []*sdl.Surface{loadImage("img/malboro.gif")}
	i.Monsters = [][]*sdl.Surface{ghost, deathshell,robot,malboro}
	
	//Setup Misc
	i.Misc = []*sdl.Surface{loadImage("img/heart.gif"), 
							loadImage("img/gameover.png"),
							loadImage("img/nextlvl.png"),
							loadImage("img/win.png"),
	}
	
	//setup Backgrounds
	i.BG = []*sdl.Surface{loadImage("img/mainscreen.png")}
	
	//Load Tiles
	i.Tiles = map[int]*sdl.Surface{'.':loadImage("img/tiles/bg-1.png"),
								'W':loadImage("img/tiles/wall-1.png"),
								'Q':loadImage("img/tiles/misc.png"),}
								
	//Objects
	i.Obj = []*sdl.Surface{loadImage("img/teleport-h.gif"), loadImage("img/teleport-v.gif")}
	
	return i
}

type Sound struct {
	Music []*mixer.Music
	Sound map[string]*mixer.Chunk
}

func LoadSound() *Sound {
	out := new(Sound)
	
	//out.Music = []*mixer.Music{loadMusic("ogg/bgm.ogg")}
	out.Sound = map[string]*mixer.Chunk{
		"enemyshot": loadSound("ogg/enemyshot.ogg"),
		"shot": loadSound("ogg/shot.ogg"),
	}
	return out
}