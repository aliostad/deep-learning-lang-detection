#ifndef GRAPHICS_BUILDINGCHUNKITEM_H
#define GRAPHICS_BUILDINGCHUNKITEM_H
#include <Chunk/Chunk.h>

#include <QtCore/QList>
#include <QtGui/QGraphicsItem>
#include <QtGui/QImage>
namespace Graphics
{
    /**
      * Gère l'affichage des batiments d'un chunk dans un QGraphicsItem
      * @brief Gère l'affichage des batiments d'un chunk
      * @author Sam101
      */
    class BuildingChunkItem : public QGraphicsItem
    {
        protected:
            /**
              * Position X du chunk
              */
            qint32 _xChunk;
            /**
              * Position Y du chunk
              */
            qint32 _yChunk;
            /**
              * Pointeur vers le Chunk
              */
            Chunk::Chunk *_chunk;
            /**
              * Tableau contenant les pixmap des batiments
              */
            QList<QImage> _tiles;
            /**
              * BoudingRect de l'objet
              */
            QRectF _boundingRect;
        public:
            /**
              * Constructeur
              */
            BuildingChunkItem(Chunk::Chunk *chunk);
            /**
              * Renvoie le boundingRect de l'objet
              */
            QRectF boundingRect() const;
            /**
              * Change le chunk de l'objet.
              * Part du principe qu'il est à la même position
              */
            void setChunk(Chunk::Chunk *chunk);
            /**
              * Repaint l'objet
              */
            void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget);
    };
}
#endif //GRAPHICS_BUILDINGCHUNKITEM_H
