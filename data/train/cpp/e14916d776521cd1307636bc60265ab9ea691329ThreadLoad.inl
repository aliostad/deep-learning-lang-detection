// ****************************************************************************
// ****************************************************************************
//template <class T>
//bool LoadFileAsync(const std::string &file, T& object, void (T::*callbackFn)(void *), void *data)
//{
//	LoadObject *loadObject = new LoadObject;
//	loadObject->filename = file;
//	loadObject->callback = new Helix::MemberCallback1<T,void *>(object, callbackFn, data);
//	loadObject->next = NULL;
//
//	DWORD result = WaitForSingleObject(m_hLoadList,INFINITE);
//	_ASSERT(result == WAIT_OBJECT_0);
//	LoadObject *scan = m_loadList;
//	while(scan->next != NULL)
//		scan = scan->next;
//	scan->next = loadObject;
//
//	result = ReleaseMutex(m_hLoadList);
//	_ASSERT(result != 0);
//
//	// Signal the thread to start loading
//	SetEvent(m_hStartLoading);
//
//	return true;
//}

// ****************************************************************************
// ****************************************************************************
//template <class T>
//bool LoadLuaFileAsync(const std::string &file, T& object, void (T::*callbackFn)(LuaState *))
//{
//	LoadObject *loadObject = new LoadObject;
//	loadObject->filename = file;
//	
//	LuaState *state = LuaState::Create();
//	loadObject->state = state;
//	loadObject->callback = new Helix::MemberCallback1<T,LuaState *>(object, callbackFn, state);
//	loadObject->next = NULL;
//
//	DWORD result = WaitForSingleObject(m_hLoadList,INFINITE);
//	_ASSERT(result == WAIT_OBJECT_0);
//	LoadObject *scan = m_loadList;
//
//	if(scan == NULL)
//	{
//		m_loadList = loadObject;
//	}
//	else
//	{
//		while(scan->next != NULL)
//			scan = scan->next;
//		scan->next = loadObject;
//	}
//
//	result = ReleaseMutex(m_hLoadList);
//	_ASSERT(result != 0);
//
//	// Signal the thread to start loading
//	SetEvent(m_hStartLoading);
//
//	return true;
//}
