#ifndef CHUNK_SELECTOR_H
#define CHUNK_SELECTOR_H

#include "job_info.h"
#include <vector>
#include <string>
#include <queue>
#include <Poco/Mutex.h>
#include <Poco/Logger.h>
using std::vector;
using std::priority_queue;
using Poco::FastMutex;
using Poco::Logger;

namespace CoolDown{
    namespace Client{

        class LocalSockManager;

        enum ChunkStatus{
            FREE = 1,
            DOWNLOADING = 2,
            FINISHED = 3,
            FAILED = 4,
            NOOWNER = 5,
        };

        struct ChunkInfo{
            ChunkInfo()
            :status(FREE), priority(0), chunk_num(0){
            }
            ChunkStatus status;
            string fileid;
            int priority;
            int chunk_num;
            vector<FileOwnerInfoPtr> clientLists;
        };
        typedef SharedPtr<ChunkInfo> ChunkInfoPtr;

        
        struct chunk_cmp{
            bool operator()(const ChunkInfoPtr& left, const ChunkInfoPtr& right){
                return left->priority < right->priority;
            }
        };

        class ChunkSelector{
            public:
                ChunkSelector(JobInfo& info, LocalSockManager& sockManager);
                ~ChunkSelector();

                vector<string> fileidlist();
                void init_queue();
                ChunkInfoPtr get_chunk();
                void report_success_chunk(int chunk_num, const string& fileid);
                void report_failed_chunk(int chunk_num, const string& fileid);
                void report_no_owner_chunk(int chunk_num, const string& fileid);

            private:
                void get_priority(ChunkInfoPtr info, int baseline);

                const static int RARE_COUNT = 5;
                enum Priority{
                    HIGHEST = 20,
                    NORMAL = 10,
                    BUSY = 5,
                    UNAVAILABLE = 0
                };
                JobInfo& jobInfo_;
                //LocalSockManager& sockManager_;

                typedef priority_queue<ChunkInfoPtr, vector<ChunkInfoPtr>, chunk_cmp> chunk_priority_queue_t;
                chunk_priority_queue_t chunk_queue_;
                FastMutex chunk_queue_mutex_;
                Logger& logger_;
        };
    }
}

#endif
