using System;
using System.Collections.Generic;
using UnityEngine;

public class DelayInvoker
{
	private bool enabled = true;

	private List<InvokeData> invokeList = new List<InvokeData>();

	public void Update(float elapse)
	{
		if (!this.enabled || this.invokeList.Count == 0)
		{
			return;
		}
		for (int i = 0; i < this.invokeList.Count; i++)
		{
			if (this.invokeList[i].delay < 0f)
			{
				this.invokeList[i].Invoke();
			}
			this.invokeList[i].delay -= elapse;
		}
		this.invokeList.RemoveAll(new Predicate<InvokeData>(DelayInvoker.IsDeleted));
	}

	private static bool IsDeleted(InvokeData data)
	{
		return data.cmp == null;
	}

	public void DoInvoke(Component cmp, string funcName, float delay)
	{
		InvokeData item = new InvokeData(cmp, funcName, delay);
		this.invokeList.Add(item);
	}

	public void SetEnable(bool value)
	{
		this.enabled = value;
	}

	public void Clear()
	{
		this.invokeList.Clear();
	}
}
