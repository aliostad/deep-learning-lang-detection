#pragma once
#include <Engine.h>

namespace FM3D {

	template<class E>
	class EventHandlerBase {
	public:
		virtual void FireEvent(E* e) = 0;
	};

	template<class H, class E>
	class MethodEventHandler : EventHandlerBase<E> {
	protected:
		H* m_handler;
		void (H::*m_target)(E*);
	public:
		void FireEvent(E* e) override {
			((*m_handler).*m_target)(e);
		}

		MethodEventHandler(H* handler, void (H::*target)(E*)) : m_handler(handler), m_target(target) {

		}
	};

	template<class E>
	class FuncEventHandler : EventHandlerBase<E> {
	protected:
		void (*m_target)(E*);
	public:
		void FireEvent(E* e) override {
			m_target(e);
		}

		FuncEventHandler(void (*target)(E*)) : m_target(target) {

		}
	};

	template<class E>
	class EventSource {
		std::vector<EventHandlerBase<E>*> m_handler;

	public:
		~EventSource() {
			for (EventHandlerBase<E>*& e : m_handler) {
				delete e;
			}
		}

		void FireEvent(E* e) {
			for (EventHandlerBase<E>*& h : m_handler) {
				h->FireEvent(e);
			}
		}

		template<class H>
		void AddHandler(H* handler, void (H::*target)(E*)) {
			m_handler.push_back((EventHandlerBase<E>*) new MethodEventHandler<H, E>(handler, target));
		}

		void AddHandler(void (*target)(E*)) {
			m_handler.push_back((EventHandlerBase<E>*) new FuncEventHandler<E>(target));
		}
	};
}