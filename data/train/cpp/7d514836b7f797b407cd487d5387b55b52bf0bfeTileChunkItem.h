#ifndef GRAPHICS_TILECHUNKITEM_H
#define GRAPHICS_TILECHUNKITEM_H
#include <Chunk/Chunk.h>
#include <QtCore/QList>
#include <QtGui/QGraphicsItem>
#include <QtGui/QPixmap>
namespace Graphics
{
    /**
      * Gère l'affichage des tiles d'un chunk dans un QGraphicsItem
      * @brief Gère l'affichage des tiles d'un chunk
      * @author Sam101
      */
    class TileChunkItem : public QGraphicsItem
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
              * Pointeur vers le Chunk duquel on doit dessiner les tiles
              */
            Chunk::Chunk *_chunk;
            /**
              * Tableau contenant les pixmap des tiles
              */
            static QVector<QImage> _tiles;
            /**
              * BoundingRect de l'item
              */
            QRectF _boundingRect;
        public:
            /**
              * Constructeur
              */
            TileChunkItem(Chunk::Chunk *chunk);
            /**
              * Renvoie le boundingRect de l'item.
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
#endif //GRAPHICS_TILECHUNKITEM_H
