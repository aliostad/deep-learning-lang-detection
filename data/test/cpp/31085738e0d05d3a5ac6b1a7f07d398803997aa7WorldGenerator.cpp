#include <World/WorldGenerator.h>
#include <World/World.h>

#include <Config/BaseConfig.h>
#include <Config/Config.h>
#include <Chunk/DesertLandChunkGenerator.h>
#include <Chunk/IslandChunkGenerator.h>
#include <Chunk/LandChunkGenerator.h>
#include <Chunk/SeaChunkGenerator.h>
#include <Tools/Random.h>

#include <QtCore/QDebug>

using namespace Config;
using namespace Tools;
namespace World
{
    /**
      * Constructeur
      */
    WorldGenerator::WorldGenerator(World *world) :
    _world(world)
    {
        _initChunkGenerator();
    }
    /**
      * Destructeur
      */
    WorldGenerator::~WorldGenerator()
    {
        /**
          * On détruit les générateurs de chunk
          */
        for (int i = 0; i < _generators.size(); i++)
        {
            delete _generators[i];
        }
    }
    /**
      * Initialise les générateurs de chunk
      */
    void WorldGenerator::_initChunkGenerator()
    {
        //Générateur de Chunk Mer.
        _generators.append(new Chunk::SeaChunkGenerator);
        //Générateur de Chunk "Land".
        _generators.append(new Chunk::LandChunkGenerator);
        //Générateur de Chunk "Island"
        _generators.append(new Chunk::IslandChunkGenerator);
        //Générateur de Chunk "Land"
        _generators.append(new Chunk::LandChunkGenerator);
    }
    /**
      * Redimensionne la taille des tableaux de chunk.
      * Positionne aussi la position des chunk nouvellement conçus.
      * @return La liste des chunk à générer
      */
    QList<Chunk::Chunk*> WorldGenerator::_redim(qint32 x, qint32 y)
    {
        QList<Chunk::Chunk*> list;
        int oldSize;
        if (y < 0)
        {
            if (x < 0)
            {
                x = abs(x);
                if (abs(y) >= _world->_chunkTL.size())
                {
                    _world->_chunkTL.resize(abs(y) + 2);
                }
                for (int i = 0; i <= abs(y) + 1; i++)
                {
                    oldSize = _world->_chunkTL[i].size();
                    oldSize = oldSize == 0 ? 1 : oldSize;
                    _world->_chunkTL[i].resize(abs(x) + 2);
                    for (int j = oldSize; j <= x + 1; j++)
                    {
                        _world->_chunkTL[i][j] = new Chunk::Chunk(-1 * (j - 1) * BaseConfig::CHUNK_SIZE - 1, -1 * (i - 1) * BaseConfig::CHUNK_SIZE - 1);
                        list.push_back(_world->_chunkTL[i][j]);
                    }
                }
            }
            else
            {
                if (abs(y) >= _world->_chunkTR.size())
                {
                    _world->_chunkTR.resize(abs(y) + 2);
                }
                for (int i = 0; i <= abs(y) + 1; i++)
                {
                    oldSize = _world->_chunkTR[i].size();
                    oldSize = oldSize == 0 ? 1 : oldSize;
                    _world->_chunkTR[i].resize(x + 2);
                    for (int j = oldSize; j <= x + 1; j++)
                    {                      
                        _world->_chunkTR[i][j] = new Chunk::Chunk((j - 1) * BaseConfig::CHUNK_SIZE, -1 * (i - 1) * BaseConfig::CHUNK_SIZE - 1);
                        list.push_back(_world->_chunkTR[i][j]);
                    }

                }

            }
        }
        else
        {
            if (x < 0)
            {
                x = abs(x);
                if (y >= _world->_chunkBL.size())
                {
                    _world->_chunkBL.resize(y + 2);
                }
                for (int i = 0; i <= y + 1; i++)
                {
                    oldSize = _world->_chunkBL[i].size();
                    oldSize = oldSize == 0 ? 1 : oldSize;
                    _world->_chunkBL[i].resize(abs(x) + 2);
                    for (int j = oldSize; j <= abs(x) + 1; j++)
                    {                        
                        _world->_chunkBL[i][j] = new Chunk::Chunk(-1 * (j - 1) * BaseConfig::CHUNK_SIZE - 1, (i - 1)  * BaseConfig::CHUNK_SIZE);
                        list.push_back(_world->_chunkBL[i][j]);
                    }
                }
            }
            else
            {
                if (y >= _world->_chunkBR.size())
                {
                    _world->_chunkBR.resize(y + 2);
                }
                for (int i = 0; i <= y + 1; i++)
                {
                    oldSize = _world->_chunkBR[i].size();
                    oldSize = oldSize == 0 ? 1 : oldSize;
                    _world->_chunkBR[i].resize(x + 2);
                    for (int j = oldSize; j <= x + 1; j++)
                    {
                        _world->_chunkBR[i][j] = new Chunk::Chunk((j - 1) * BaseConfig::CHUNK_SIZE, (i - 1) * BaseConfig::CHUNK_SIZE);
                        list.push_back(_world->_chunkBR[i][j]);
                    }
                }

            }
        }
        return list;

    }
    /**
      * Demande la génération d'un chunk.
      * Peut entrainer en cascade la génération d'autres
      * chunk.
      * @param x Position X du chunk à générer.
      * @param y Position Y du chunk à générer.
      */
    void WorldGenerator::generate(qint32 x, qint32 y)
    {
        QList<Chunk::Chunk*> listToGenerate = _redim(x,y);

        Chunk::Chunk *current;
        int chunkType;

        QListIterator<Chunk::Chunk*> it(listToGenerate);

        /*
         * On itère sur chaque élément de la liste des chunk à générer
         */
        while (it.hasNext())
        {
            current = it.next();
            //On genère le type du chunk.
            //TODO: Faire un truc moins aléatoire
            chunkType = Random::next(0,Chunk::LAST);
            current->setType((Chunk::ChunkType)chunkType);
            //On genère le chunk.
            _generators[chunkType]->generate(current);
        }

    }
}
