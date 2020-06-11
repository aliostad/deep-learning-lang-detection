using System;
using System.Collections;
using System.Diagnostics;
using UnityEngine;

public class DelayToInvoke : MonoBehaviour
{
	[DebuggerHidden]
	public static IEnumerator DelayToInvokeDo(Action action, float delaySeconds)
	{
		DelayToInvoke.<DelayToInvokeDo>c__Iterator8A <DelayToInvokeDo>c__Iterator8A = new DelayToInvoke.<DelayToInvokeDo>c__Iterator8A();
		<DelayToInvokeDo>c__Iterator8A.delaySeconds = delaySeconds;
		<DelayToInvokeDo>c__Iterator8A.action = action;
		<DelayToInvokeDo>c__Iterator8A.<$>delaySeconds = delaySeconds;
		<DelayToInvokeDo>c__Iterator8A.<$>action = action;
		return <DelayToInvokeDo>c__Iterator8A;
	}
}
