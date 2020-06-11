#include <cassert>
#include "locator.hxx"

Debug &Locator::get_debug() {
    assert(debug != nullptr);
    return *debug;
}
void Locator::provide_debug(unique_ptr<Debug> d) {
    debug.swap(d);
}

bool Locator::has_window() {
    return window != nullptr;
}
sf::RenderWindow &Locator::get_window() {
    assert(window != nullptr);
    return *window;
}
void Locator::provide_window(sf::RenderWindow *w) {
    window = w;
}

StateStack &Locator::get_statestack() {
    assert(statestack != nullptr);
    return *statestack;
}
void Locator::provide_statestack(unique_ptr<StateStack> s) {
    statestack.swap(s);
}

Logger &Locator::get_logger() {
    assert(logger != nullptr);
    return *logger;
}
void Locator::provide_logger(unique_ptr<Logger> next) {
    logger.swap(next);
}

ShapeDebug &Locator::get_shapedebug() {
    assert(shapedebug != nullptr);
    return *shapedebug;
}
void Locator::provide_shapedebug(unique_ptr<ShapeDebug> x) {
    shapedebug.swap(x);
}

unique_ptr<Debug> Locator::debug{ nullptr };
sf::RenderWindow *Locator::window{ nullptr };
unique_ptr<StateStack> Locator::statestack{ nullptr };
unique_ptr<Logger> Locator::logger{ nullptr };
unique_ptr<ShapeDebug> Locator::shapedebug{ nullptr };

