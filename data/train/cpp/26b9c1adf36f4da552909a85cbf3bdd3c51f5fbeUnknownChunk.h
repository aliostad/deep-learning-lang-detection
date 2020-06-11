/* 
 * File:   UnknownChunk.h
 * Author: rd
 *
 * Created on 2 Июнь 2010 г., 22:35
 */

#ifndef _UNKNOWNCHUNK_H
#define	_UNKNOWNCHUNK_H

#include "WaveChunk.h"

class UnknownChunk: public WaveChunk {
public:
    UnknownChunk();
    UnknownChunk(const UnknownChunk& orig);
    virtual ~UnknownChunk();


    virtual char *getData();
    

protected:
    virtual void loadData(std::ifstream& in);
    virtual void saveData(std::ofstream& out)const;

private:
    char *data;

};

#endif	/* _UNKNOWNCHUNK_H */

