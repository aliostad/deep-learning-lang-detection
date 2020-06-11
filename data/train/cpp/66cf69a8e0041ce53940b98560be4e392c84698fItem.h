#include <cstdlib>
#include <list>
#include <vector>
#include <string>
#include <fstream>
#include <iostream>

class Locator; //forward declaration so that each Item can hold its own Locator

//Class "Item" to hold the data to be stored in our Priority Queue
//------------------------------------------------------------------------------
class Item {
private:
	int key, elem;
	Locator* loc;
public:
	Item();
	Item(int k, int e);
    ~Item();
	
	void setKey(int k) {key = k;}
	void setElem(int e) {elem = e;}
	void setLocator(Locator* l) {loc = l;}
	const int getKey() const {return key;}
	const int getElem() const {return elem;}
	Locator* getLocator() const {return loc;}
		
	friend bool operator<(const Item& a, const Item& b);
	friend bool operator==(const Item& a, const Item& b);
    Item& operator=(const Item& it);
	
	friend std::ostream& operator<<(std::ostream& os, const Item& item);
};

//Class "Locator," used to point to an Item and help store and modify data in our Priority Queue
//------------------------------------------------------------------------------
class Locator {
private:
	Item* i;

public: 
	Locator(Item* item = NULL): i(item) { }
    ~Locator();
	
	Item* getItem() const {return i;}
    void setItem(Item* item) {i = item;}
    
	friend bool operator<(const Locator& a, const Locator& b);
	friend bool operator==(const Locator& a, const Locator& b);
    Locator& operator=(const Locator& it);
    
	friend std::ostream& operator<<(std::ostream& os, const Locator& loc);

};
//------------------------------------------------------------------------------