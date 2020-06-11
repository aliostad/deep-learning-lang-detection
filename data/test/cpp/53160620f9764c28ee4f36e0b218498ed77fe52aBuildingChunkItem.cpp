#include <Graphics/BuildingChunkItem.h>
#include <Graphics/Provider.h>
#include <Config/BaseConfig.h>
#include <QtGui/QPainter>
#include <QtCore/QDebug>
using namespace Config;
namespace Graphics
{
    /**
      * Constructeur
      */
    BuildingChunkItem::BuildingChunkItem(Chunk::Chunk *chunk) :
    _chunk(chunk)
    {
        //On construit le boundingRect de l'objet
        _boundingRect = QRectF(0,0,BaseConfig::CHUNK_SIZE * BaseConfig::TILE_SIZE,BaseConfig::CHUNK_SIZE * BaseConfig::TILE_SIZE);
        //On charge le tableau des batiments
        //TODO: Faire un truc mieux
        _tiles.append(Provider::getBuilding("none").toImage());
        _tiles.append(Provider::getBuilding("house").toImage());
        _tiles.append(Provider::getBuilding("farmland").toImage());
        _tiles.append(Provider::getBuilding("road").toImage());
        //On définit la position.
        int x,y;
        if (_chunk->getX() < 0)
        {
            _xChunk = (_chunk->getX() - BaseConfig::CHUNK_SIZE + 1);
            x = _xChunk * BaseConfig::TILE_SIZE;
        }
        else
        {
            _xChunk = _chunk->getX();
            x = _chunk->getX() * BaseConfig::TILE_SIZE;
        }
        if (_chunk->getY() < 0)
        {
            _yChunk = _chunk->getY() - BaseConfig::CHUNK_SIZE + 1;
            y = (_yChunk + 1) * BaseConfig::TILE_SIZE;
        }
        else
        {
            _yChunk = _chunk->getY();
            y = (_yChunk + 1) *  BaseConfig::TILE_SIZE;
        }
        setPos(x,y);
    }
    /**
      * Renvoie le boundingRect de l'objet
      */
    QRectF BuildingChunkItem::boundingRect() const
    {
        return _boundingRect;
    }
    /**
      * Change le chunk de l'objet.
      * Part du principe qu'il est à la même position
      */
    void BuildingChunkItem::setChunk(Chunk::Chunk *chunk)
    {
        _chunk = chunk;
        update();
    }

    /**
      * Repaint l'objet
      */
    void BuildingChunkItem::paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
    {
        Q_UNUSED(option)
        Q_UNUSED(widget)
        qint32 current;

        for (int i = _xChunk; i < _xChunk + BaseConfig::CHUNK_SIZE; i++)
        {
            for (int j = _yChunk; j < _yChunk + BaseConfig::CHUNK_SIZE; j++)
            {
                current = _chunk->getBuilding(i,j).getType();
                painter->drawImage(QPoint( (i - _xChunk) * BaseConfig::TILE_SIZE,(j - _yChunk) * BaseConfig::TILE_SIZE),_tiles[current]);
            }
        }
    }
}
