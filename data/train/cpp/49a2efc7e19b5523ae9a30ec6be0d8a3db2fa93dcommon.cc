#include "tiny_ui.h"

namespace tinyui {

void Button::set_handler(ButtonEvents *handler)
{
	m_handler = handler;
}

void ListBox::set_handler(ListBoxEvents *handler)
{
	m_handler = handler;
}

void IoWatch::set_handler(IoWatchEvents *handler)
{
	m_handler = handler;
}

void Timer::set_handler(TimerEvents *handler)
{
	m_handler = handler;
}

void Entry::set_handler(EntryEvents *handler)
{
	m_handler = handler;
}

Application *Application::instance()
{
	return m_instance;
}

Application *Application::m_instance = NULL;

}
