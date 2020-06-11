#pragma once

#include <map>
#include <vector>

#include "pixelboost/input/inputManager.h"

namespace pb
{
    
    class InputHandler
    {
    public:
        virtual ~InputHandler();
        
        virtual int GetInputHandlerPriority() = 0;
        
    private:
        friend class InputManager;
    };
    
    class InputManager
    {
    public:
        InputManager();
        ~InputManager();
        
        void AddHandler(InputHandler* handler);
        void RemoveHandler(InputHandler* handler);
        
    protected:
        void UpdateHandlers();
        
        typedef std::vector<InputHandler*> HandlerList;
        
        HandlerList _Handlers;
        
    private:
        typedef std::map<InputHandler*, bool> HandlerMap;
        HandlerMap _HandlerMap;
        HandlerMap _HandlersToAdd;
    };
    
}
