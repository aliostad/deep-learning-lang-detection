#include "Item.h"

//Class "PriorityQueueList" based on an unsorted list
//------------------------------------------------------------------------------
class PriorityQueueList {
private:
	std::list<Locator*> elemList;

public:
	PriorityQueueList() {}
	
	void createPriorityQueue(std::string filename, Locator locs[]);
	
	Locator* insert(int k, int e, Locator* loc);
	
	std::list<Locator*> getList() const {return elemList;}
	bool isEmpty();
	Locator* min();	
	void remove(Locator* loc);
    void decreaseKey(Locator& loc, int k);
    int getElement(Locator& loc);
	
	friend std::ostream& operator<<(std::ostream& os, const PriorityQueueList& pq);
};
//------------------------------------------------------------------------------