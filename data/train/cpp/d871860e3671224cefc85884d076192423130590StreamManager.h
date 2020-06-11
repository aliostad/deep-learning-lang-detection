
#ifndef _STREAMMANAGER_H_
#define _STREAMMANAGER_H_

#include <list>
using namespace std;

class WebStream;

/* control the stream */
class StreamManager{
private:
    list<WebStream *> idleStream;
    list<WebStream *> readStream;
    list<WebStream *> taskStream;
    list<WebStream *> writeStream;

public:
    StreamManager();

    /* get an idle webstream from idleStream, if no idleStream
       new a WebStream */
    WebStream *GetIdleWebStream();

    /* add an idle webStream into idleStream */
    int AddIdleStream( WebStream *idleWebStream);

    /* Get idle Stream size */
    int GetIdleStreamSize();



    /* get the taskStream according to the fd */
    WebStream *GetReadWebStream( int fd );

    /* add an task webStream into taskStream */
    int AddReadWebStream( WebStream *readWebStream );

    /* is the taskWebStream in the taskStream */
    bool IsReadWebStreamExist( WebStream *readWebStream );

    /* is the readStream set has uninitlize stream */
    bool IsExistUninitilizeReadStream();

    /* is exit readStream set has read status */
    bool IsExistReadStatusStream();

    /* delete an webWrite Stream in the pool */
    int DeleteReadWebStream( WebStream *readWebStream );

    /* Get the readWebStream size */
    int GetReadWebStreamSize();

    /* Loop the readStream list, and return the already stream */
    int HttpParseHeader();

    /* clip the readStream has taskStream */
    int ClipReadToTaskStream();

    /* clip the readStream to idle stream */
    int ClipReadToIdleStream();


    /* delete an webWrite Stream in the pool */
    int DeleteWriteWebStream( WebStream *writeWebStream );

    /* add an webStream into taskStream */
    int AddTaskWebStream( WebStream *taskStream );

    /* Get the next undispatcher TaskStream */
    WebStream * GetNextUndispatherTaskStream();

    /* Get the taskWebStream size */
    int GetTaskWebStreamSize();

    /* clip the taskStream has writeStream */
    int ClipTaskToWriteStream();

    /* add an writeStream */
    int AddWriteWebStream(WebStream *webStream);

    /* delete from webStream from taskWebStream  */
    int DeleteTaskWebStream(WebStream *webStream );

};



#endif
