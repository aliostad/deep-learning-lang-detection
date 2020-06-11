
template<class Handler>
Event<Handler>::Event(const string& name) : mEventName(name)
{
	// 留空
}

template<class Handler>
Event<Handler>::~Event()
{
	list<Handler*>::iterator ite = mHandlerList.begin();

	for(; ite != mHandlerList.end(); ++ ite)
	{
		delete *ite;
	}
}

template<class Handler>
void Event<Handler>::Insert (Handler* handler)
{
#		if defined(DEBUG) || defined(_DEBUG)
			bool check = true;
			HandlerIte ite = mHandlerList.begin();
			for(; ite != mHandlerList.end(); ++ ite)
			{
				if((*ite)->target_type() == handler->target_type())
					check = false;
			}
			DreAssert(check, "重复添加相同的处理器");
#		endif	// end
		
		mHandlerList.push_back(handler);

}

template<class Handler>
void Event<Handler>::Remove (Handler* handler)
{
	HandlerIte ite = mHandlerList.begin();
	for(; ite != mHandlerList.end(); ++ ite)
	{
		if((*ite)->target_type() == handler->target_type())
		{
			mHandlerList.erase(ite);
			break;
		}
	}
}

template<class Handler>
void Event<Handler>::Clear()
{
	mHandlerList.Clear();
}

template<class Handler>
string Event<Handler>::GetEventName() { return mEventName; }