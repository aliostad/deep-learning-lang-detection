#ifndef NETWORK_CHUNKDATAMESSAGE_H
#define NETWORK_CHUNKDATAMESSAGE_H
#include <Chunk/Chunk.h>
#include <Network/AbstractMessage.h>
namespace Network
{
    /**
      * Envoyé du serveur au client, stocke les informations
      * sur un chunk
      * @brief Stocke les informations sur un chunk
      * @author Sam101
      */
    class ChunkDataMessage : public AbstractMessage
    {
        public:
            /**
              * MagicNumber de ChunkDataMessage
              */
            static const qint32 MAGICNUMBER_CHUNKDATA = 0x4213;
        protected:
            /**
              * Données du chunk
              */
            Chunk::Chunk _chunk;
        public:
            /**
              * Constructeur sans paramètres
              */
            ChunkDataMessage();
            /**
              * Constructeur
              */
            ChunkDataMessage(const Chunk::Chunk &chunk);
            /**
              * Renvoie le chunk
              */
            Chunk::Chunk& getChunk();
            /**
              * Renvoie le chunk, surchargé constant
              */
            const Chunk::Chunk& getChunk() const;
            /**
              * Envoie le message dans un QDataStream
              */
            friend QDataStream& operator<<(QDataStream &out, const ChunkDataMessage &m);
            /**
              * Recupère le message d'un QDataStream
              */
            friend QDataStream& operator>>(QDataStream &in, ChunkDataMessage &m);
    };
}
#endif //NETWORK_CHUNKDATAMESSAGE_H
