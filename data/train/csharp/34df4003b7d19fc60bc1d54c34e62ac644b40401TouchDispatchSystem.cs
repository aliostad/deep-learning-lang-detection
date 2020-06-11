namespace SDK.Lib
{
    /**
     * @brief 触碰后事件分发系统
     */
    public class TouchDispatchSystem
    {
        private bool mHasTouch;
        private bool mHasMultiTouch;

        private AddOnceEventDispatch mOnTouchBeganDispatch;         // 触碰开始
        private AddOnceEventDispatch mOnTouchMovedDispatch;         // 触碰状态，但是移动
        private AddOnceEventDispatch mOnTouchStationaryDispatch;    // 触碰状态但是不移动
        private AddOnceEventDispatch mOnTouchEndedDispatch;         // 触碰结束
        private AddOnceEventDispatch mOnTouchCanceledDispatch;      // 触碰取消

        private AddOnceEventDispatch mOnMultiTouchBeganDispatch;         // 触碰开始
        private AddOnceEventDispatch mOnMultiTouchMovedDispatch;         // 触碰状态，但是移动
        private AddOnceEventDispatch mOnMultiTouchStationaryDispatch;    // 触碰状态但是不移动
        private AddOnceEventDispatch mOnMultiTouchEndedDispatch;         // 触碰结束
        private AddOnceEventDispatch mOnMultiTouchCanceledDispatch;      // 触碰取消

        public TouchDispatchSystem()
        {
            this.mOnTouchBeganDispatch = new AddOnceEventDispatch();
            this.mOnTouchMovedDispatch = new AddOnceEventDispatch();
            this.mOnTouchStationaryDispatch = new AddOnceEventDispatch();
            this.mOnTouchEndedDispatch = new AddOnceEventDispatch();
            this.mOnTouchCanceledDispatch = new AddOnceEventDispatch();

            this.mOnMultiTouchBeganDispatch = new AddOnceEventDispatch();
            this.mOnMultiTouchMovedDispatch = new AddOnceEventDispatch();
            this.mOnMultiTouchStationaryDispatch = new AddOnceEventDispatch();
            this.mOnMultiTouchEndedDispatch = new AddOnceEventDispatch();
            this.mOnMultiTouchCanceledDispatch = new AddOnceEventDispatch();
        }

        public void init()
        {

        }

        public void dispose()
        {

        }

        public void addTouchListener(EventId evtID, MAction<IDispatchObject> handle)
        {
            if (EventId.TOUCHBEGIN_EVENT == evtID)
            {
                this.mOnTouchBeganDispatch.addEventHandle(null, handle);
            }
            else if (EventId.TOUCHMOVED_EVENT == evtID)
            {
                this.mOnTouchMovedDispatch.addEventHandle(null, handle);
            }
            else if (EventId.TOUCHSTATIONARY_EVENT == evtID)
            {
                this.mOnTouchStationaryDispatch.addEventHandle(null, handle);
            }
            else if (EventId.TOUCHENDED_EVENT == evtID)
            {
                this.mOnTouchEndedDispatch.addEventHandle(null, handle);
            }
            else if (EventId.TOUCHCANCELED_EVENT == evtID)
            {
                this.mOnTouchCanceledDispatch.addEventHandle(null, handle);
            }

            this.mHasTouch = true;
        }

        public void removeTouchListener(EventId evtID, MAction<IDispatchObject> handle)
        {
            if (EventId.TOUCHBEGIN_EVENT == evtID)
            {
                this.mOnTouchBeganDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.TOUCHMOVED_EVENT == evtID)
            {
                this.mOnTouchMovedDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.TOUCHSTATIONARY_EVENT == evtID)
            {
                this.mOnTouchStationaryDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.TOUCHENDED_EVENT == evtID)
            {
                this.mOnTouchEndedDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.TOUCHCANCELED_EVENT == evtID)
            {
                this.mOnTouchCanceledDispatch.removeEventHandle(null, handle);
            }

            this.mHasTouch = this.hasEventHandle();
        }

        // 是否还有需要处理的事件
        public bool hasEventHandle()
        {
            if (this.mOnTouchBeganDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnTouchMovedDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnTouchStationaryDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnTouchEndedDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnTouchCanceledDispatch.hasEventHandle())
            {
                return true;
            }

            return false;
        }

        public bool hasTouch()
        {
            return this.mHasTouch;
        }

        public void handleTouchBegan(MMouseOrTouch touch)
        {
            if (null != this.mOnTouchBeganDispatch)
            {
                this.mOnTouchBeganDispatch.dispatchEvent(touch);
            }
        }

        public void handleTouchMoved(MMouseOrTouch touch)
        {
            if (null != this.mOnTouchMovedDispatch)
            {
                this.mOnTouchMovedDispatch.dispatchEvent(touch);
            }
        }

        public void handleTouchStationary(MMouseOrTouch touch)
        {
            if (null != this.mOnTouchStationaryDispatch)
            {
                this.mOnTouchStationaryDispatch.dispatchEvent(touch);
            }
        }

        public void handleTouchEnded(MMouseOrTouch touch)
        {
            if (null != this.mOnTouchEndedDispatch)
            {
                this.mOnTouchEndedDispatch.dispatchEvent(touch);
            }
        }

        public void handleTouchCanceled(MMouseOrTouch touch)
        {
            if (null != this.mOnTouchCanceledDispatch)
            {
                this.mOnTouchCanceledDispatch.dispatchEvent(touch);
            }
        }

        /********************************** Multi Touch *********************************/
        public void addMultiTouchListener(EventId evtID, MAction<IDispatchObject> handle)
        {
            if (EventId.MULTI_TOUCHBEGIN_EVENT == evtID)
            {
                this.mOnMultiTouchBeganDispatch.addEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHMOVED_EVENT == evtID)
            {
                this.mOnMultiTouchMovedDispatch.addEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHSTATIONARY_EVENT == evtID)
            {
                this.mOnMultiTouchStationaryDispatch.addEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHENDED_EVENT == evtID)
            {
                this.mOnMultiTouchEndedDispatch.addEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHCANCELED_EVENT == evtID)
            {
                this.mOnMultiTouchCanceledDispatch.addEventHandle(null, handle);
            }

            this.mHasMultiTouch = true;
        }

        public void removeMultiTouchListener(EventId evtID, MAction<IDispatchObject> handle)
        {
            if (EventId.MULTI_TOUCHBEGIN_EVENT == evtID)
            {
                this.mOnMultiTouchBeganDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHMOVED_EVENT == evtID)
            {
                this.mOnMultiTouchMovedDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHSTATIONARY_EVENT == evtID)
            {
                this.mOnMultiTouchStationaryDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHENDED_EVENT == evtID)
            {
                this.mOnMultiTouchEndedDispatch.removeEventHandle(null, handle);
            }
            else if (EventId.MULTI_TOUCHCANCELED_EVENT == evtID)
            {
                this.mOnMultiTouchCanceledDispatch.removeEventHandle(null, handle);
            }

            this.mHasMultiTouch = this.hasMultiEventHandle();
        }

        // 是否还有需要处理的事件
        public bool hasMultiEventHandle()
        {
            if (this.mOnMultiTouchBeganDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnMultiTouchMovedDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnMultiTouchStationaryDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnMultiTouchEndedDispatch.hasEventHandle())
            {
                return true;
            }
            if (this.mOnMultiTouchCanceledDispatch.hasEventHandle())
            {
                return true;
            }

            return false;
        }

        public bool hasMultiTouch()
        {
            return this.mHasMultiTouch;
        }

        public void handleMultiTouchBegan(IDispatchObject touch)
        {
            if (null != this.mOnMultiTouchBeganDispatch)
            {
                this.mOnMultiTouchBeganDispatch.dispatchEvent(touch);
            }
        }

        public void handleMultiTouchMoved(IDispatchObject touch)
        {
            if (null != this.mOnMultiTouchMovedDispatch)
            {
                this.mOnMultiTouchMovedDispatch.dispatchEvent(touch);
            }
        }

        public void handleMultiTouchStationary(IDispatchObject touch)
        {
            if (null != this.mOnMultiTouchStationaryDispatch)
            {
                this.mOnMultiTouchStationaryDispatch.dispatchEvent(touch);
            }
        }

        public void handleMultiTouchEnded(IDispatchObject touch)
        {
            if (null != this.mOnMultiTouchEndedDispatch)
            {
                this.mOnMultiTouchEndedDispatch.dispatchEvent(touch);
            }
        }

        public void handleMultiTouchCanceled(IDispatchObject touch)
        {
            if (null != this.mOnMultiTouchCanceledDispatch)
            {
                this.mOnMultiTouchCanceledDispatch.dispatchEvent(touch);
            }
        }
    }
}