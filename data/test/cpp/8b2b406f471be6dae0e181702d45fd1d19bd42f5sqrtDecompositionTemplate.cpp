/*                		
	Name: Square Root Decomposition Template
	Author: Shobhit Saxena
	Date: 06/10/14 10:02
	Description:   		
*/                			
#include<iostream>			
using namespace std;		
                  			
#define chunkSize 300   //define chunk size here
#define getChunkNumber(nodePosition)  (nodePosition/chunkSize+1)
#define getFirstElement(chunkNumber)  ((chunkNumber-1)*chunkSize)
#define getLastElement(chunkNumber)   (chunkNumber*chunkSize-1)
#define isInBoundary(position) 		  ((position%chunkSize)==0)
                 		
//update at position template
void update(int position,...) // pass aditional variables here
{                			
	int targetChunk = getChunkNumber(pos);  // chunk where position is present
	int lastChunk   = getChunkNumber(lastPosition); // lastChunk
	int targetChunkFirstElement = getFirstElement(targetChunk);
	int targetChunkLastElement  = getLastElement(targetChunk);
							
	// update element at position
							
	// update chunk			
	for(int i=targetChunkFirstElement;i<=lastElementPosition&&i<=targetChunkLastElement;i++){ // make sure u update the lastElement position
		chunk[targetChunk]= ; //update chunk code here
	}						
							
	//update all the chunks after the target chunk.	
	for(int i=targetChunk+1;i<=lastChunk;i++)
		chunk[i]=  // update code here	
}							
							
// query 					
RETURN_TYPE query(int position,...){ // pass additional variables
	//Move position to the nearest chunk boundary
	while(position<=lastElementPosition&&!isInBoundary(position)){
		//keep checking for the value of position. If it satisfies the givn condition return the value.	
	}						
							
	//Move forward chunk by chunk first.
	while(position<=lastElementPosition){
		if(satisfy(chunk[getChunkNumber(position)])) // if the chunk satisfy the property break
			break;			
		position+=chunkSize;
	}						
							
	if(position>lastElementPosition) // this is required when the whole array donot satisfy the need
		doSomething here;	
							
	//You are at the very first element of the chunk which is required to process the answer.
	while(1){				
		//check for the conditions here. Update the values here too.
		if(satisfy(position))
			break;				
		position++; // go for the next Position
	}			 			
}							
						shobhitsaxena@live.com	
int main() {

}
