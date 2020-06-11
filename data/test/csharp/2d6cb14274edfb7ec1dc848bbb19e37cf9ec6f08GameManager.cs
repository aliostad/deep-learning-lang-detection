using BattleSystem;
using System;
using UnityEngine;
using System.Collections;

public class GameManager : MonoBehaviour
{

    // Use this for initialization
    void Start()
    {
//        int invokeId = BattleSystem.Invoke.Instance.InvokeRepeating(() => {
//            Debug.Log("Hello: " + DateTime.Now.ToString("h:mm:ss.fff"));}, 10, 1f, 1f);
//
////        for (int i = 0; i < 1000; i++)
////            BattleSystem.Invoke.Instance.InvokeRepeating(() => {
////                Debug.Log("Hello: " + DateTime.Now);}, 10, 1000, 1000);
//
//        BattleSystem.Invoke.Instance.InvokeOnce(() => {
//            BattleSystem.Invoke.Instance.ChangePeriod(invokeId, 5f); }, 2f);
//
//        BattleSystem.Invoke.Instance.InvokeOnce(() => {
//            BattleSystem.Invoke.Instance.StopInvoke(invokeId); }, 5f);
//
//        BattleSystem.Invoke.Instance.InvokeRepeating(() => {
//            Debug.LogError("Log: " + DateTime.Now.ToString("h:mm:ss.fff"));}, -1, 2f);
    }
	
    public static void log<T>(T Sender,object msg)
    {
        Debug.Log("["+Sender.ToString()+"] "+msg.ToString());
    }

    void OnDestroy()
    {
        Debug.LogError("Destroying All.");
        BattleSystem.Invoke.Instance.RemoveAllInvokes();
    }

}
