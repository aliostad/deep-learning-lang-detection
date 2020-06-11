#ifndef CHUNK_ACTION_STREAM_
#define CHUNK_ACTION_STREAM_

#include <queue>
using std::priority_queue;

#include "blocking_queue.h"
#include "../chunk/chunk_loader.h"

#include <vector>

struct OrderPairInt {
    bool operator()(pair<Chunk_Action_Res*, unsigned int> const& a, 
                    pair<Chunk_Action_Res*, unsigned int> const& b) const {
        return a.second > b.second;
    }
};


typedef priority_queue<pair<Chunk_Action_Res*, unsigned int>,   
                      vector<pair<Chunk_Action_Res*, unsigned int>>, 
                      OrderPairInt> Chunk_Action_Res_PQ;

class Async_Chunk_Action_Stream {
  public:
    Async_Chunk_Action_Stream(): next_req(0), next_res(0){ }

    void push_req(Chunk_Action_Req* req);
    void push_res(Chunk_Action_Res* res, unsigned int i);

    vector<Chunk_Action_Res*> multi_nowait_pop_res();
    pair<Chunk_Action_Req*, unsigned int> pop_req();

  private:
    Blocking_Queue<pair<Chunk_Action_Res*, unsigned int>> chunk_action_ress;
    Blocking_Queue<pair<Chunk_Action_Req*, unsigned int>> chunk_action_reqs;
    Chunk_Action_Res_PQ chunk_action_ress_pq;

    unsigned int next_req;
    unsigned int next_res;
};


#endif
