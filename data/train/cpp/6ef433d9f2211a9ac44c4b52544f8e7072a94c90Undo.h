#pragma once

#include "Song.h"
#include "Repository.h"

/* 
	Generic class for an undo action.
	For each type of action (add, delete, update), a new class will be created, inheriting from this UndoAction.
*/
class UndoAction 
{
public:
	virtual void executeUndo() = 0;
	// virtual destructor!
	virtual ~UndoAction() {};
};

class UndoAdd : public UndoAction
{
private:
	Song addedSong;
	Repository& repo;	// we keep a reference to the repository to be able to undo the action
public:
	UndoAdd(Repository& _repo, const Song& s): repo{ _repo }, addedSong { s } {}
	
	/*
		For the add operation, the reverse operation that must be executed is "remove".
	*/
	void executeUndo() override
	{
		this->repo.removeSong(addedSong);
	}
};

class UndoRemove : public UndoAction
{
private:
	Song deletedSong;
	Repository& repo;
public:
	UndoRemove(Repository& _repo, const Song& s): repo{ _repo }, deletedSong{ s } {}
	
	void executeUndo() override 
	{
		this->repo.addSong(deletedSong);
	}
};