using UnityEngine;
using System.Collections;
using System.Runtime.Serialization.Formatters.Binary; 
using System.IO;

public static class WorldSerializer {
	public static string defaultPath = Application.persistentDataPath + "/";
	public static string extension = ".chunk";

	public static void SerializeChunk(Chunk chunk, string worldName) {
		
		SerializedChunk serializedChunk = new SerializedChunk (chunk);
		WriteSerializedChunk(serializedChunk, worldName);
	} 

	public static void WriteSerializedChunk(SerializedChunk serializedChunk, string worldName) {
		System.IO.Directory.CreateDirectory (defaultPath + worldName);
		 
		BinaryFormatter binaryFormatter = new BinaryFormatter();
		 using (FileStream file = File.Create (defaultPath + worldName + "/chunk" + serializedChunk.chunkPositionX + "-" + serializedChunk.chunkPositionY + extension)) {
			//		Debug.Log ("Chunk saved at " + Application.persistentDataPath);
			binaryFormatter.Serialize (file, serializedChunk);
			file.Close (); 
		}
	}
	
	public static Chunk DeserializeChunk(Vector2 chunkPosition, string worldName) {
  
		GameObject chunkGameObject = (GameObject) GameObject.Instantiate (Resources.Load ("Prefabs/Chunk"), chunkPosition * PlayerPrefs.GetInt ("chunk_size"), Quaternion.identity);
		Chunk chunk = chunkGameObject.GetComponent<Chunk>();

		string path = defaultPath + worldName + "/chunk" + chunkPosition.x + "-" + chunkPosition.y + extension;
		if (File.Exists (path)) {
			BinaryFormatter binaryFormatter = new BinaryFormatter();
			using (FileStream file = File.Open(path, FileMode.Open)) {
				SerializedChunk serializedChunk  = (SerializedChunk) binaryFormatter.Deserialize(file);
				file.Close(); 
				serializedChunk.WriteToChunk(chunk);
			}
		}  
		return chunk;
	}
	

}
