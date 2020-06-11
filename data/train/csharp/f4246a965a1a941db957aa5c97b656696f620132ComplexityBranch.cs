using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[System.Serializable]
public class ComplexityBranch{
	public int branchFrom = -1;
	public int id;
	public bool inBranch = false;
	//public List<ComplexityBranch> branches = new List<ComplexityBranch> ();
	public List<ComplexityChunk> complexities = new List<ComplexityChunk>();



	public bool AddBranch(ComplexityBranch branch){
		bool branchAdded = false;
		ComplexityChunk chunk = FindComplexityChunk (branch.branchFrom);
		if (chunk.zoneChunkId != -1) {
			chunk.branches.Add (branch);
			branchAdded = true;
		}
		return branchAdded;
	}

	public ComplexityChunk FindComplexityChunk(int number){
		ComplexityChunk foundChunk = new ComplexityChunk();
		foundChunk.zoneChunkId = -1;
		foreach(ComplexityChunk chunk in complexities){
			if (chunk.zoneChunkId == number) {
				foundChunk = chunk;
				/*if(foundChunk.zoneChunkId != -1){
					break;
				}*/
			} else {
				foreach (ComplexityBranch branch in chunk.branches) {
					foundChunk = branch.FindComplexityChunk (number);
					/*if(foundChunk.zoneChunkId != -1){
						break;
					}*/
				}

			}
		}
		return foundChunk;
	}



	public void SetComplexity(int startComplexity, int complexityRange){
		foreach(ComplexityChunk chunk in complexities){
			//Debug.Log (chunk.zoneChunkId);
			chunk.complexity = startComplexity;
			startComplexity += complexityRange;
			//Debug.Log (startComplexity.ToString());

			foreach (ComplexityBranch branch in chunk.branches) {
				branch.SetComplexity (chunk.complexity + complexityRange, complexityRange);
			}
		}	
	}
}
