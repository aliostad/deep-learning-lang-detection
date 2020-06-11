using RGSMS;
using UnityEngine;

public class Teste : MonoBehaviour
{
	private void Start ()
	{
//		this.InvokeRepeating(
//		this.InvokeRepeating(Testando, 1.0f, 0.5f);

//		Ca

		this.Invoke(Testando, 2.0f);

//		Invoke(Testando, 2.0f);
		
//		Invoke("Testando", 2.0f);

//		InvokeManager.Invoke(Testando, 2.5f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);
//		InvokeManager.Instance.Invoke(Testando, 10.0f);

//		InvokeManager.Instance.InvokeRepeatingWithLimit(Testando, 2.0f, 1.0f, 10);
//		InvokeManager.Instance.StopInvoke(Testando);
//		Debug.Log(InvokeManager.Instance.Invoke(this, "TesteAvancado", 2.0f, new object[2] {5.0f, "jesus!"}).method.Name);
//
//		InvokeManager.Instance.InvokeRepeating(this, "TesteAvancado", 0.0f, 1.0f, new object[2] {5.0f, "jesus!"});
	}

	private void Testando ()
	{
		Debug.Log("oi");
	}

	private void TesteAvancado (float f, string s)
	{
		Debug.Log(s + "  " + f);
	}
}
