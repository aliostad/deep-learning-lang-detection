/* 
 * File:   InputHandler.h
 * Author: jonathan
 *
 * Created on 31. Oktober 2011, 14:07
 */

#ifndef INPUTHANDLER_H
#define	INPUTHANDLER_H

class EventHandler;

class InputHandler {
public:
    InputHandler();
    InputHandler(EventHandler* eventHandler);
    virtual bool* getInput() = 0;
    virtual ~InputHandler();
protected:
    EventHandler* eventHandler;
    bool* keys;
private:
    InputHandler(const InputHandler&);
    const InputHandler& operator=(const InputHandler&);
};

#endif	/* INPUTHANDLER_H */

