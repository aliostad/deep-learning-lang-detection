namespace SDK.Lib
{
    /**
     * @brief 非引用计数资源加载结果通知
     */
    public class ResLoadResultNotify
    {
        protected ResLoadState mResLoadState;          // 资源加载状态
        protected ResEventDispatch mLoadResEventDispatch;      // 事件分发器

        public ResLoadResultNotify()
        {
            this.mResLoadState = new ResLoadState();
            this.mLoadResEventDispatch = new ResEventDispatch();
        }

        public ResLoadState resLoadState
        {
            get
            {
                return this.mResLoadState;
            }
            set
            {
                this.mResLoadState = value;
            }
        }

        public ResEventDispatch loadResEventDispatch
        {
            get
            {
                return this.mLoadResEventDispatch;
            }
            set
            {
                this.mLoadResEventDispatch = value;
            }
        }

        public void onLoadEventHandle(IDispatchObject dispObj)
        {
            this.mLoadResEventDispatch.dispatchEvent(dispObj);
            this.mLoadResEventDispatch.clearEventHandle();
        }

        virtual public void copyFrom(ResLoadResultNotify rhv)
        {
            this.mResLoadState.copyFrom(rhv.resLoadState);
            this.mLoadResEventDispatch = rhv.loadResEventDispatch;
        }
    }
}