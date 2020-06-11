namespace SDK.Lib
{
    /**
     * @brief Lua 调用 CS 接口
     */
    public class LuaToCS
    {
        protected EventDispatchGroup m_eventDispatchGroup;
        protected AddOnceEventDispatch m_addOnceEventDispatch;

        public LuaToCS()
        {

        }

        public EventDispatchGroup eventDispatchGroup
        {
            get
            {
                return m_eventDispatchGroup;
            }
            set
            {
                m_eventDispatchGroup = value;
            }
        }

        public AddOnceEventDispatch addOnceEventDispatch
        {
            get
            {
                return m_addOnceEventDispatch;
            }
            set
            {
                m_addOnceEventDispatch = value;
            }
        }

        protected void registerGlobalEvent()
        {
            m_eventDispatchGroup = new EventDispatchGroup();                                            // 分发器组
            m_addOnceEventDispatch = new AddOnceEventDispatch((int)eGlobalEventType.eGlobalTest);       // 分发器
            m_addOnceEventDispatch.luaCSBridgeDispatch = new LuaCSBridgeDispatch(LuaCSBridgeDispatch.LUA_DISPATCH_TABLE_NAME);  // Lua 事件分发逻辑
            m_eventDispatchGroup.addEventDispatch((int)eGlobalEventType.eGlobalTest, m_addOnceEventDispatch);   // 添加事件分发器给分发器组
        }
    }
}