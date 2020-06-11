// Copyright 2015 Bill Lin. All rights reserved.

#include "Apex/System/Handlers.hpp"
#include "Apex/System/InputHandler.hpp"
#include "Apex/Window/WindowHandler.hpp"

Handlers::Handlers() {
}

Handlers::~Handlers() {
    delete mInputHandler;
    delete mWindowHandler;
}

InputHandler* const
Handlers::inputHandler() const {
    return mInputHandler;
}

void
Handlers::inputHandler(InputHandler* const handler) {
    mInputHandler = handler;
}

WindowHandler* const
Handlers::windowHandler() const {
    return mWindowHandler;
}

void
Handlers::windowHandler(WindowHandler* const handler) {
    mWindowHandler = handler;
}
