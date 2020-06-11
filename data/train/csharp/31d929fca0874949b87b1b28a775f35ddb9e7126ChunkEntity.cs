using UnityEngine;

public class ChunkEntity : MonoBehaviour {
	public Chunk chunk { get; private set; }
	bool initialized = false;

	void Start () {
		chunk.reloadEntity ();
	}

	void Update () {
		
	}

	public void init (Chunk chunk) {
		//if (initialized)
		//	return;
		this.chunk = chunk;

		initialized = true;
	}

	public void Destroy () {
		chunk.entity = null;

		foreach (MapObject a in chunk.objs) {
			//TODO 何故かnull Checkが必要
			if (a.entity != null) {
				a.entity.Destroy ();
			}
		}
		
		Destroy (gameObject);
	}
}
