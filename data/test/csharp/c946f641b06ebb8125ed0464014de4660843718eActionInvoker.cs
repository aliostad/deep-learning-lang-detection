using UnityEngine;
using System.Collections;
using UnityEngine.Events;

namespace Game.Package
{
    public class ActionInvoker : MonoBehaviour
    {

        public UnityEvent todo;

        public float invokeDelay = 0;
        public bool invokeOnce = false;
        public bool invokeNOW = false;

        private bool wasDone = false;

        protected virtual void Awake()
        {
            ValidateUtils.Validate(gameObject, todo);
        }

        void Update()
        {
            if (invokeNOW)
            {
                Invoke();
            }
        }

        public void Invoke()
        {
            invokeNOW = false;
            if (invokeOnce && wasDone) return;
            wasDone = true;

            if (invokeDelay > 0) StartCoroutine(EnumeratorAction(invokeDelay));
            else ExecuteAction();
        }

        private IEnumerator EnumeratorAction(float waitTime)
        {
            yield return new WaitForSeconds(waitTime);
            ExecuteAction();
        }

        protected virtual void ExecuteAction()
        {
            if (todo != null) todo.Invoke();
        }
    }
}
