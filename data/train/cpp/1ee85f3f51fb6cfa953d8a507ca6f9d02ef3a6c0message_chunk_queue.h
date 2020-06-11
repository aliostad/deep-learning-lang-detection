

#ifndef WTAF__NET__MESSAGE_CHUNK_QUEUE_
#define WTAF__NET__MESSAGE_CHUNK_QUEUE_

#include <mutex>
#include <deque>
#include "net/message_chunk.h"

namespace wtaf {
namespace net {

class Message_Chunk_Queue
{
public:
	Message_Chunk_Queue()=default;
	
    void push(Message_Chunk *message_chunk);    
    void push_front(Message_Chunk *message_chunk);
    Message_Chunk* pop();
    uint32 length();
    
private:
    std::deque<Message_Chunk*> m_queue;
    std::mutex m_mutex;
    uint32 m_length = 0;
};

}
}

#endif
