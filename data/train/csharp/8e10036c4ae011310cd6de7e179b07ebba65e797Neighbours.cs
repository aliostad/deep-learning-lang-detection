using UnityEngine;
using System.Collections;


public class Neighbours {
	public VoxelShell xpos;
	public VoxelShell xneg;
	public VoxelShell ypos;
	public VoxelShell yneg;
	public VoxelShell zpos;
	public VoxelShell zneg;
	//These flag a direction's quad being generated to allow skipping during loops; 
	public bool xposQuad;
	public bool xnegQuad;
	public bool yposQuad;
	public bool ynegQuad;
	public bool zposQuad;
	public bool znegQuad;
	public Neighbours(ref VoxelShell _xpos, ref VoxelShell _xneg, ref VoxelShell _ypos, ref VoxelShell _yneg, ref VoxelShell _zpos, ref VoxelShell _zneg)
	{
		xpos = _xpos;
		xneg = _xneg; 
		ypos = _ypos; 
		yneg = _yneg;
		zpos = _zpos;
		zneg = _zneg;
		ResetFlags();
	}
	public Neighbours()
	{
	}
	public void ResetFlags()
	{
		xposQuad = false;
		xnegQuad = false;
		yposQuad = false;
		ynegQuad = false;
		zposQuad = false;
		znegQuad = false;
	}
	public void UpdateNeighbours()
	{	
		if(xpos.filled )//Is it filled?
		if(xpos.parentChunk != xpos.neighbours.xneg.parentChunk )//Is it the same chunk?
		if(xpos.parentChunk != null)//Is it the emptyChunk? The only chunk with a null parent
		if(!xpos.parentChunk.queuedForUpdate)//Only queue chunks that arnt already queued
		xpos.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref xpos.parentChunk);


		if(xneg.filled )
		if(xneg.parentChunk != xneg.neighbours.xpos.parentChunk )
		if(xneg.parentChunk != null)
		if(!xneg.parentChunk.queuedForUpdate)
		xneg.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref xneg.parentChunk);
	

		if(ypos.filled )
		if(ypos.parentChunk != ypos.neighbours.yneg.parentChunk )
		if(ypos.parentChunk != null)
		if(!ypos.parentChunk.queuedForUpdate)			
		ypos.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref ypos.parentChunk);			


		if(yneg.filled )
		if(yneg.parentChunk != yneg.neighbours.ypos.parentChunk )
		if(yneg.parentChunk != null)		
		if(!yneg.parentChunk.queuedForUpdate)
		yneg.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref yneg.parentChunk);
		

		if(zpos.filled )
		if(zpos.parentChunk != zpos.neighbours.zneg.parentChunk )
		if(zpos.parentChunk != null )
		if(!zpos.parentChunk.queuedForUpdate)
		zpos.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref zpos.parentChunk);
		

		if(zneg.filled )
		if(zneg.parentChunk != zneg.neighbours.zpos.parentChunk )
		if(zneg.parentChunk != null )		
		if(!zneg.parentChunk.queuedForUpdate)
		zneg.parentChunk.systemParent.VSUM.QueueChunkForUpdate(ref zneg.parentChunk);

	}

	public void GetNeighbourDelegate(ref System.Action updateStuff, ref System.Action genMesh)
	{	
		if(xpos.filled )
			if(xpos.parentChunk != xpos.neighbours.xneg.parentChunk )
				if(xpos.parentChunk!= null )
					if(!xpos.parentChunk.queuedForUpdate)
				{
					
					updateStuff += xpos.parentChunk.UpdateMesh;
					genMesh += xpos.parentChunk.GenerateThisMesh;
				}			
		
		if(xneg.filled )
			if(xneg.parentChunk != xneg.neighbours.xpos.parentChunk )
				if(xneg.parentChunk != null)
					if(!xneg.parentChunk.queuedForUpdate)
				{
					
					updateStuff += xneg.parentChunk.UpdateMesh;
					genMesh += xneg.parentChunk.GenerateThisMesh;
				}
		
		if(ypos.filled )
			if(ypos.parentChunk != ypos.neighbours.yneg.parentChunk )
				if(ypos.parentChunk != null)
					if(!ypos.parentChunk.queuedForUpdate)
				{
					
					updateStuff += ypos.parentChunk.UpdateMesh;	
					genMesh += ypos.parentChunk.GenerateThisMesh;
				}			
		
		if(yneg.filled )
			if(yneg.parentChunk != yneg.neighbours.ypos.parentChunk )
				if(yneg.parentChunk != null)
					if(!yneg.parentChunk.queuedForUpdate )
				{
					
					updateStuff += yneg.parentChunk.UpdateMesh;
					genMesh += yneg.parentChunk.GenerateThisMesh;
				}			
		
		if(zpos.filled )
			if(zpos.parentChunk != zpos.neighbours.zneg.parentChunk )
				if(zpos.parentChunk != null )
					if(!zpos.parentChunk.queuedForUpdate )
				{
					
					updateStuff += zpos.parentChunk.UpdateMesh;
					genMesh += zpos.parentChunk.GenerateThisMesh;
				}
		
		if(zneg.filled )
			if(zneg.parentChunk != zneg.neighbours.zpos.parentChunk )
				if(zneg.parentChunk != null )
					if(!zneg.parentChunk.queuedForUpdate)
				{
					
					updateStuff += zneg.parentChunk.UpdateMesh;
					genMesh += zneg.parentChunk.GenerateThisMesh;
				}

//
//		if(xpos.filled )
//			if(xpos.parentChunk != xpos.neighbours.xneg.parentChunk )
//				if(xpos.parentChunk!= null )
//			{
//				//if(!xpos.parentChunk.Generating)// && !xpos.parentChunk.needsUpdating)
//				{
//					//xpos.parentChunk.needsUpdating= true;
//
//					updateStuff += xpos.parentChunk.UpdateMesh;
//					genMesh += xpos.parentChunk.GenerateThisMesh;
//				}
//			}
//		
//		if(xneg.filled )
//			if(xneg.parentChunk != xneg.neighbours.xpos.parentChunk )
//				if(xneg.parentChunk != null)
//			{
//				//if(!xneg.parentChunk.Generating)// && !xneg.parentChunk.needsUpdating)
//				{
//					//xneg.parentChunk.needsUpdating = true;
//					updateStuff += xneg.parentChunk.UpdateMesh;
//					genMesh += xneg.parentChunk.GenerateThisMesh;
//				}
//			}
//		
//		if(ypos.filled )
//			if(ypos.parentChunk != ypos.neighbours.yneg.parentChunk )
//				if(ypos.parentChunk != null)
//			{
//				//if(!ypos.parentChunk.Generating)// && !yneg.parentChunk.needsUpdating)
//				{
//					//ypos.parentChunk.needsUpdating = true;
//					updateStuff += ypos.parentChunk.UpdateMesh;	
//					genMesh += ypos.parentChunk.GenerateThisMesh;
//				}
//			}
//		
//		if(yneg.filled )
//			if(yneg.parentChunk != yneg.neighbours.ypos.parentChunk )
//				if(yneg.parentChunk != null)
//			{
//				//if(!yneg.parentChunk.Generating )//&& !ypos.parentChunk.needsUpdating)
//				{
//					//yneg.parentChunk.needsUpdating = true;
//					updateStuff += yneg.parentChunk.UpdateMesh;
//					genMesh += yneg.parentChunk.GenerateThisMesh;
//				}
//			}
//		
//		if(zpos.filled )
//			if(zpos.parentChunk != zpos.neighbours.zneg.parentChunk )
//				if(zpos.parentChunk != null )
//			{
//				//if(!zpos.parentChunk.Generating )//&& !zneg.parentChunk.needsUpdating)
//				{
//					//zpos.parentChunk.needsUpdating = true;
//					updateStuff += zpos.parentChunk.UpdateMesh;
//					genMesh += zpos.parentChunk.GenerateThisMesh;
//				}
//			}
//		
//		if(zneg.filled )
//			if(zneg.parentChunk != zneg.neighbours.zpos.parentChunk )
//				if(zneg.parentChunk != null )
//			{
//				//if(!zneg.parentChunk.Generating)// && !zpos.parentChunk.needsUpdating)
//				{
//					//zneg.parentChunk.needsUpdating = true;
//					updateStuff += zneg.parentChunk.UpdateMesh;
//					genMesh += zneg.parentChunk.GenerateThisMesh;
//				}
//			}

	}

}
