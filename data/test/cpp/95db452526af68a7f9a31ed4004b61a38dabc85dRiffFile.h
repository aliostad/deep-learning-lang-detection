#ifndef RIFFFILE_H
#define RIFFFILE_H

#include <QtCore>
#include "chunk.h"

using namespace RiffChunk;

typedef unsigned short int2b;
typedef unsigned long int4b;

class RiffFile {

protected:
    QFile* file;
    QStringList* errorsList;
    Chunk* rootChunk;

public:
    RiffFile(QFile* file);
    ~RiffFile(void);
    bool open(QIODevice::OpenModeFlag flag);
    bool close();
    Chunk*  getRootChunk();
    bool    setRootChunk(Chunk* rootChunk);

    QStringList getErrors();
    Chunk* findChunkByName(QString name, uint pos=0);

protected:
    bool readChunks(void);
    bool writeChunk(Chunk*);
    void processError(QString errorMessage);
    Chunk* createRootChunk();

};

#endif
