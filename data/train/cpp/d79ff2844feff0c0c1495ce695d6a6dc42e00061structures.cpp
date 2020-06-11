// -*-c++-*-

#include "structures.h"

#include <iostream>


std::ostream& operator<<(std::ostream& stream, Mappable ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Unit ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "owner: " << ob.owner  <<'\n';
  stream << "health: " << ob.health  <<'\n';
  stream << "strength: " << ob.strength  <<'\n';
  stream << "movesLeft: " << ob.movesLeft  <<'\n';
  stream << "attacksLeft: " << ob.attacksLeft  <<'\n';
  stream << "gold: " << ob.gold  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Pirate ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "owner: " << ob.owner  <<'\n';
  stream << "health: " << ob.health  <<'\n';
  stream << "strength: " << ob.strength  <<'\n';
  stream << "movesLeft: " << ob.movesLeft  <<'\n';
  stream << "attacksLeft: " << ob.attacksLeft  <<'\n';
  stream << "gold: " << ob.gold  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Player ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "playerName: " << ob.playerName  <<'\n';
  stream << "gold: " << ob.gold  <<'\n';
  stream << "time: " << ob.time  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Port ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "owner: " << ob.owner  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Ship ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "owner: " << ob.owner  <<'\n';
  stream << "health: " << ob.health  <<'\n';
  stream << "strength: " << ob.strength  <<'\n';
  stream << "movesLeft: " << ob.movesLeft  <<'\n';
  stream << "attacksLeft: " << ob.attacksLeft  <<'\n';
  stream << "gold: " << ob.gold  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Tile ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "type: " << ob.type  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Treasure ob)
{
  stream << "id: " << ob.id  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  stream << "gold: " << ob.gold  <<'\n';
  return stream;
}



std::ostream& operator<<(std::ostream& stream, Move ob)
{
  stream << "Move" << "\n";
  stream << "unit: " << ob.unit  <<'\n';
  stream << "x: " << ob.x  <<'\n';
  stream << "y: " << ob.y  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Pirateattack ob)
{
  stream << "Pirateattack" << "\n";
  stream << "attacker: " << ob.attacker  <<'\n';
  stream << "attackx: " << ob.attackx  <<'\n';
  stream << "attacky: " << ob.attacky  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Shipattack ob)
{
  stream << "Shipattack" << "\n";
  stream << "attacker: " << ob.attacker  <<'\n';
  stream << "attackx: " << ob.attackx  <<'\n';
  stream << "attacky: " << ob.attacky  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, Talk ob)
{
  stream << "Talk" << "\n";
  stream << "speaker: " << ob.speaker  <<'\n';
  stream << "message: " << ob.message  <<'\n';
  return stream;
}


std::ostream& operator<<(std::ostream& stream, GameState ob)
{
  stream << "turnNumber: " << ob.turnNumber  <<'\n';
  stream << "playerID: " << ob.playerID  <<'\n';
  stream << "gameNumber: " << ob.gameNumber  <<'\n';
  stream << "pirateCost: " << ob.pirateCost  <<'\n';
  stream << "shipCost: " << ob.shipCost  <<'\n';
  stream << "portCost: " << ob.portCost  <<'\n';
  stream << "mapSize: " << ob.mapSize  <<'\n';

  stream << "\n\nMappables:\n";
  for(std::map<int,Mappable>::iterator i = ob.mappables.begin(); i != ob.mappables.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nUnits:\n";
  for(std::map<int,Unit>::iterator i = ob.units.begin(); i != ob.units.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nPirates:\n";
  for(std::map<int,Pirate>::iterator i = ob.pirates.begin(); i != ob.pirates.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nPlayers:\n";
  for(std::map<int,Player>::iterator i = ob.players.begin(); i != ob.players.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nPorts:\n";
  for(std::map<int,Port>::iterator i = ob.ports.begin(); i != ob.ports.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nShips:\n";
  for(std::map<int,Ship>::iterator i = ob.ships.begin(); i != ob.ships.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nTiles:\n";
  for(std::map<int,Tile>::iterator i = ob.tiles.begin(); i != ob.tiles.end(); i++)
    stream << i->second << '\n';
  stream << "\n\nTreasures:\n";
  for(std::map<int,Treasure>::iterator i = ob.treasures.begin(); i != ob.treasures.end(); i++)
    stream << i->second << '\n';
  stream << "\nAnimation\n";
  for
    (
    std::map< int, std::vector<Animation*> >::iterator j = ob.animations.begin(); 
    j != ob.animations.end(); 
    j++ 
    )
  {
  for(std::vector<Animation*>::iterator i = j->second.begin(); i != j->second.end(); i++)
  {
    if((**i).type == MOVE)
      stream << *((Move*)*i) << "\n";
    if((**i).type == PIRATEATTACK)
      stream << *((Pirateattack*)*i) << "\n";
    if((**i).type == SHIPATTACK)
      stream << *((Shipattack*)*i) << "\n";
    if((**i).type == TALK)
      stream << *((Talk*)*i) << "\n";
  }
  

  }
  return stream;
}

Game::Game()
{
  winner = -1;
}
