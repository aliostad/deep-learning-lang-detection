#include <iostream>


class ChunkID {
public:
        int getChunkDepth(int local_depth);
};

struct ChunkHeader {
        ChunkID id;
};

class Chunk {
public:
        static const short NULL_DEPTH = -50;
private:
        ChunkHeader hdr;
};

// I declare once more this routine here, because I want to include
// the default argument value, now that Chunk has been defined.
int ChunkID::getChunkDepth(int local_depth = Chunk::NULL_DEPTH);

main(){
        ChunkID id;
        cout << id.getChunkDepth() << endl;
}

int ChunkID::getChunkDepth(int local_depth){
        return local_depth;
}


