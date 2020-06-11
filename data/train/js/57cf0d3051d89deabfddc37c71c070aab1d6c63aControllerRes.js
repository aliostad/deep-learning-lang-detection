using UnityEngine;

namespace SDK.Lib
{
    public class ControllerRes : InsResBase
    {
        protected SOAnimatorController m_controller;
        protected RuntimeAnimatorController m_insController;

        override protected void initImpl(ResItem res)
        {
            m_controller = res.getObject(res.getPrefabName()) as SOAnimatorController;
            base.initImpl(res);
        }

        public RuntimeAnimatorController InstantiateController()
        {
            m_insController = UtilApi.Instantiate(m_controller.m_animatorController) as RuntimeAnimatorController;
            return m_insController;
        }

        public void DestroyControllerInstance(RuntimeAnimatorController insController_)
        {
            UtilApi.Destroy(insController_);
        }
    }
}