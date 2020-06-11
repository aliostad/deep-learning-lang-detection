#include <Network/ChunkDataMessage.h>
#include <QtCore/QDebug>
namespace Network
{
    /**
      * Constructeur sans paramètres
      */
    ChunkDataMessage::ChunkDataMessage() :
    AbstractMessage(Network::CHUNKDATA)
    {

    }
    /**
      * Constructeur
      */
    ChunkDataMessage::ChunkDataMessage(const Chunk::Chunk &chunk) :
    AbstractMessage(CHUNKDATA),
    _chunk(chunk)
    {

    }
    /**
      * Renvoie le chunk
      */
    Chunk::Chunk& ChunkDataMessage::getChunk()
    {
        return _chunk;
    }
    /**
      * Renvoie le chunk, surchargé constant
      */
    const Chunk::Chunk& ChunkDataMessage::getChunk() const
    {
        return _chunk;
    }
    /**
      * Envoie le message dans un QDataStream
      */
    QDataStream& operator<<(QDataStream &out, const ChunkDataMessage &m)
    {
        //On écrit le magicNumber
        out << m.MAGICNUMBER_CHUNKDATA;
        //On écrit les données
        out << m._chunk;

        return out;
    }
    /**
      * Recupère le message d'un QDataStream
      */
    QDataStream& operator>>(QDataStream &in, ChunkDataMessage &m)
    {
        //On vérifie le magicNumber
        qint32 magicNumber;
        in >> magicNumber;
        if (magicNumber != m.MAGICNUMBER_CHUNKDATA)
        {
            qDebug() << "Message ChunkData incorrect reçu";
            return in;
        }
        //On recupère les données
        in >> m._chunk;

        return in;
    }
}
