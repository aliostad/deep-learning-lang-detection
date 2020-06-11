#include "loadgame.h"
#include <iostream>
LoadGame::LoadGame()
{}

LoadGame::LoadGame(Writer* tempWriter_, int days_, int hours_, int minutes_, int seconds_)
{
    tempWriter=tempWriter_;
    tempTimes.days=days_;
    tempTimes.hours=hours_;
    tempTimes.minutes=minutes_;
    tempTimes.seconds=seconds_;
}

TimeStruct LoadGame::getTimes(){
    return tempTimes;
}
std::string LoadGame::toStr(){
    return "Writer: " + tempWriter->toStr();
}
Writer* LoadGame::getWriter(){
    return tempWriter;
}
LoadGame::~LoadGame(){}