#ifndef CHUNKSERVERSTATE_H
#define CHUNKSERVERSTATE_H


#include "ChunkInfo.h"
#include <list>
#include <string>
using std::list;
using std::string;

namespace myfs {
class ChunkServerState {
public:
	ChunkServerState(ChunkServerAddr &, int, int);
	ChunkServerState(ChunkServerAddr &, list<string> &, int, int);
	
	const ChunkServerAddr &serverAddr();
	const list<string> &chunkList();
	double load() const;
	int used();
	int size();

	void addChunk(string);
	void delChunk(string);
	void setUsed(int);
	void setSize(int);

	//friend bool operator<(const ChunkServerState &, const ChunkServerState &);
private:
	ChunkServerAddr serverAddr_;
	list<string> chunks_;
	int used_;
	int size_;
};
bool operator<(const ChunkServerState&, const ChunkServerState&);
}
#endif
