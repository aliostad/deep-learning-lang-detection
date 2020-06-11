//
//  undo.hpp
//  exam2
//


#pragma once 
#include "Repository.hpp"

class Undo {
    
public:
    virtual void executeUndo() = 0;
    virtual ~Undo() {}
};



class UndoRemove : public Undo {
    
    Repository& repo;
    Painting item;

public:
    
    UndoRemove(Repository& r, Painting& item) : repo{ r}, item{item} {}
    
    void executeUndo() override {
        this->repo.addPainting(item);
    }

};


class UndoMove : public Undo {
    
    Repository& repo;
    Repository& special;
    
public:
    UndoMove(Repository& r,Repository& special) : repo{r}, special{special} {}
    
    void executeUndo() override {
        Painting p = this->special.getAll().back();
        this->special.removePainting(p);
        this->repo.addPainting(p);
    }
};

