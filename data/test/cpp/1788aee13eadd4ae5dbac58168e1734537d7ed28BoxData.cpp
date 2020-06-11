#include "BoxData.h"

BoxException::BoxException() : logic_error("Box is already full.\n")
{ }

BoxData::BoxData() : load(0.0), seqNum(0)
{}

BoxData::BoxData(int _seqNum) : load(0.0), seqNum(_seqNum)
{}

int BoxData::getSeqNum() const
{
	return seqNum;
}

list<double> BoxData::getLoads() const
{
	return loads;
}

void BoxData::addLoad(const double& _load)
{
	if( !willFit(_load) )
		throw BoxException();
	
	load += _load;
	loads.push_back(_load);
}

double BoxData::getLoad() const
{
	return load;
}

bool BoxData::willFill(const double& _load) const
{
	return (load + _load) > 0.99 && willFit(_load);
}

bool BoxData::willFit(const double& _load) const
{
	return (load + _load) <= 1.0;
}

bool BoxData::isFull() const
{
	return willFill(0.0); //if adding nothing fills the box, the box must be full!
}

bool BoxData::operator < (const BoxData& aBox) const
{
	return load < aBox.load;
}
bool BoxData::operator <= (const BoxData&  aBox) const
{
	return load <= aBox.load;
}
bool BoxData::operator > (const BoxData& aBox) const
{
	return load > aBox.load;
}
bool BoxData::operator >= (const BoxData& aBox) const
{
	return load >= aBox.load;
}

ostream& operator << (ostream& os, const BoxData& box)
{
	list<double> loads = box.getLoads();
	os << "For box " << box.getSeqNum() << ", Total Items:   " << loads.size()
	   << ", Total Load:   " << box.getLoad() << ", consisting of ";
	for(list<double>::iterator it = loads.begin(); it != loads.end(); ++it)
	{
		os << *it << " ";
	}
	os << "\n";
	return os;
}

bool BoxPointerLoadGreater::operator () (BoxData* x, BoxData* y)
{
	return x->getLoad() > y->getLoad();
}
