#ifndef MYDEQ
#define MYDEQ

#include <vector>
#define DEQUE_CHUNK_SIZE 8

using namespace std;
template <typename T>
class MyDeque{
    
    struct chunkStorage{
        int next,
        prev;
        T dataArray[DEQUE_CHUNK_SIZE];
        
        chunkStorage(){
            next = -1;
            prev = -1;
        }
        
        chunkStorage(int p, int n){
            prev = p;
            next = n;
        }
    };
    
    vector<chunkStorage> connector;
    
    int topIndex ,
    bottomIndex,
    indexPrevChunk,
    indexNextChunk,
    counter;
    
    chunkStorage *topChunk ;
    chunkStorage *bottomChunk;
    
public:
    MyDeque() {
        topIndex = 0;
        bottomIndex = DEQUE_CHUNK_SIZE-1;
        
        indexPrevChunk = 1;
        indexNextChunk = 0;
        
        counter = 0;
        
        topChunk = new chunkStorage(0, -1);
        bottomChunk = new chunkStorage(-1, 1);
        
        connector.push_back(*bottomChunk);
        connector.push_back(*topChunk);
    }
    
    void allocTopChunk(){
        int nextPos = connector.size();
        topChunk->next = nextPos;
        topChunk = new chunkStorage(indexPrevChunk, -1);
        connector.push_back(*topChunk);
        indexPrevChunk = nextPos;
        topIndex = 0;
    }
    
    void push_front(T value){
        if(topIndex == DEQUE_CHUNK_SIZE) allocTopChunk();
        topChunk->dataArray[topIndex++] = value;
        counter++;
    }
    
    void deleteTopChunk(){
        chunkStorage* temp = &connector[topChunk->prev];
        delete topChunk;
        topChunk = temp;
        topChunk->next = -1;
        topIndex = DEQUE_CHUNK_SIZE ;
    }
    
    void pop_front(){
        if(topIndex == 0 && topChunk->prev != -1){
            deleteTopChunk();
        }
        topIndex-- ;
    }
    
    void deleteBottChunk(){
        chunkStorage *temp = &connector[bottomChunk->next];
        delete bottomChunk;
        bottomChunk = temp;
        bottomChunk->prev = -1;
        bottomIndex = 0;
    }
    
    void pop_back(){
        if(bottomIndex == DEQUE_CHUNK_SIZE -1 &&
                topChunk->next != -1) deleteBottChunk();
        bottomIndex++;
    }
    
    void allocBottChunk(){
        int prevPos = connector.size();
        bottomChunk->prev = prevPos;
        bottomChunk = new chunkStorage(-1, indexNextChunk);
        connector.push_back(*bottomChunk);
        indexNextChunk = prevPos;
        bottomIndex = DEQUE_CHUNK_SIZE-1;
    }
    
    void push_back(T value){
        if(bottomIndex == 0){
            allocBottChunk();
        }
        bottomChunk->dataArray[bottomIndex--] = value;
        counter++;
    }
    
    bool empty(){
        return !counter;
    }
    
    int size(){
        return counter;
    }
    
   T front(){
        return !empty() ? topChunk->chunk[topIndex-1] : false;
    }


    T back(){
       return !empty() ? bottomChunk->chunk[bottomIndex+1] : false;
    }
    
    
    //only for debuging
    void showFront(){
        topIndex--;
        while (topChunk->prev != 0){
            cout << topChunk->chunk[topIndex--] << " ";
            if(topIndex == -1){
                cout << "prev" << topChunk->prev<< endl;
                topChunk = &connector[topChunk->prev];
                topIndex = DEQUE_CHUNK_SIZE-1;
            }
        }
    }
    //only for debuging
    void showBottom(){
        bottomIndex++;
        while (bottomChunk->next != 1){
            cout << bottomChunk->chunk[bottomIndex++] << " ";
            if(bottomIndex == DEQUE_CHUNK_SIZE){
                bottomChunk = &connector[bottomChunk->next ];
                bottomIndex = 1;
                cout << endl;
            }
        }
    }
    
};

#endif MYDEQ

