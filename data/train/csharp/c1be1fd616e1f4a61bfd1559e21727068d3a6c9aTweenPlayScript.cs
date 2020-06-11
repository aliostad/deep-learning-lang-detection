// 程序作者：郭进明 |  技术分析博客 http://www.cnblogs.com/GJM6/

using UnityEngine;
using System.Collections;


namespace GJM
{
    /// <summary>
    ///  
    /// </summary>
    public class TweenPlayScript : MonoBehaviour
    {
        public GameObject target;

        public float time = 0.5f;
        void OnEnable()
        {
            InvokeRepeating("InvokeUpdate", 0, time);
        }


        void OnDisable()
        {
            CancelInvoke("InvokeUpdate");

        }

        void OnDestroy()
        {
            CancelInvoke("InvokeUpdate");

        }

        int number;
        void InvokeUpdate()
        {
            if (target == null) return;
            number += 1;

            if (number % 2 == 0)
            {
                target.gameObject.SetActive(false);
            }
            else
            {
                target.gameObject.SetActive(true);
            }

        }

    }
}
