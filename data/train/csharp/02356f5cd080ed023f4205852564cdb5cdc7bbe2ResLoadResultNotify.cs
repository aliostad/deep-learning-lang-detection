namespace SDK.Lib
{
    /**
     * @brief 非引用计数资源加载结果通知
     */
    public class ResLoadResultNotify
    {
        protected ResLoadState m_resLoadState;          // 资源加载状态
        protected ResEventDispatch m_loadResEventDispatch;    // 事件分发器

        public ResLoadResultNotify()
        {
            m_resLoadState = new ResLoadState();
            m_loadResEventDispatch = new ResEventDispatch();
        }

        public ResLoadState resLoadState
        {
            get
            {
                return m_resLoadState;
            }
            set
            {
                m_resLoadState = value;
            }
        }

        public ResEventDispatch loadResEventDispatch
        {
            get
            {
                return m_loadResEventDispatch;
            }
            set
            {
                m_loadResEventDispatch = value;
            }
        }

        public void onLoadEventHandle(IDispatchObject dispObj)
        {
            m_loadResEventDispatch.dispatchEvent(dispObj);
            m_loadResEventDispatch.clearEventHandle();
        }

        virtual public void copyFrom(ResLoadResultNotify rhv)
        {
            m_resLoadState.copyFrom(rhv.resLoadState);
            m_loadResEventDispatch = rhv.loadResEventDispatch;
        }
    }
}