<?php
header('Content-Type: text/html; charset=utf8');
set_time_limit(0);

//ievaddati
$file = fopen("conll/training.conll", "r"); 
$stacks = $buffers = $arcsz = array();

while (!feof($file)) {
	$tempword = fgets($file);
	$tempword = explode("	",$tempword);
	if(count($tempword)>1){//ielasa pa vārdam visu teikumu
		$buffer[] = $tempword[0].".".$tempword[4];
		$correctResult[]=$tempword[6].$tempword[0];
	}else{//kad teikums ielasīts, noparsē teikumu
		$stack = new SplDoublyLinkedList();
		$arcz = $moves = array();
		
		//atrod visus iespējamos rezultātus
		nivre(serialize($stack), $buffer, $arcz, serialize($moves));
		
		//apstrādā pareizo rezultātu
		if(isset($currentMoves)&&is_string($currentMoves)){
			foreach (unserialize($currentMoves) as $correctMove){
				
				//saliek masīvus simbolu virknēs
				$stackString = "";$bufferString = "";$arcsString = "";
				$bufferString = $correctMove[2];
				$stackString = $correctMove[1];
				$stackTopHasArc = $correctMove[3];
				$bufferNextHasArc = $correctMove[4];
				
				$move_instances [] = array("stack" => $stackString, "buffer" => $bufferString,  "stackTopHasArc" => $stackTopHasArc,  "bufferNextHasArc" => $bufferNextHasArc, "category" => $correctMove[0]);
				$stacks[] = $stackString;
				$buffers[] = $bufferString;
				$arcsz[] = $arcsString;
			}
		}
		
		unset($arcz, $stack, $buffer, $moves, $currentMoves, $correctResult);//notīra mainīgos
		$correctResult = $buffer = array();
	}
} 
fclose($file); 

function nivre($stack, $buffer, $arcs, $moves){
	$stackCopy = unserialize($stack);
	if((count($buffer)==0)&&($stackCopy->isEmpty())){
		return;
	}
	if(count($buffer)!=0){ // vai drīkst SHIFT?
	
		$bufferCopy = $buffer;
		$movesCopy = unserialize($moves);
		
		$stackTopHasArc = ($stackCopy->isEmpty() ? false : in_array($stackCopy->top(), $arcs));
		$bufferNextHasArc = (count($buffer)!=0 ? in_array($buffer[0], $arcs) : false);
		
		$movesCopy[] = array("SHIFT", ($stackCopy->isEmpty() ? "" : explode(".",$stackCopy->top())[1]), (count($bufferCopy)!=0 ? explode(".",$bufferCopy[0])[1] : ""), $stackTopHasArc, $bufferNextHasArc);
		$movesCopy = serialize($movesCopy);
		$stackCopy->push(array_shift($bufferCopy));
		if($stackCopy->count()==1&&count($bufferCopy)==0){
			global $currentMoves;
			$currentMoves = $movesCopy;
			return;
		}
		nivre(serialize($stackCopy), $bufferCopy, $arcs, $movesCopy);
	}
	
	$stackCopy = unserialize($stack);
	
	$stackTopHasArc = ($stackCopy->isEmpty() ? false : in_array($stackCopy->top(), $arcs));
	$bufferNextHasArc = (count($buffer)!=0 ? in_array($buffer[0], $arcs) : false);
	
	if((!$stackCopy->isEmpty())&&($stackTopHasArc)){ // vai drīkst REDUCE?
		$movesCopy = unserialize($moves);
		
		$movesCopy[] = array("REDUCE", ($stackCopy->isEmpty() ? "" : explode(".",$stackCopy->top())[1]), (count($buffer)!=0 ? explode(".",$buffer[0])[1] : ""), $stackTopHasArc, $bufferNextHasArc);
		$movesCopy = serialize($movesCopy);
		$stackCopy->pop();
		if($stackCopy->count()==1&&count($buffer)==0){
			global $currentMoves;
			$currentMoves = $movesCopy;
			return;
		}
		nivre(serialize($stackCopy), $buffer, $arcs, $movesCopy);
	}
	
	$stackCopy = unserialize($stack);
	
	$stackTopHasArc = ($stackCopy->isEmpty() ? false : in_array($stackCopy->top(), $arcs));
	$bufferNextHasArc = (count($buffer)!=0 ? in_array($buffer[0], $arcs) : false);
	
	if(count($buffer)!=0&&!$stackCopy->isEmpty()&&!$stackTopHasArc){ // vai drīkst LEFTARC?
		global $correctResult;
		if(in_array(explode(".",$buffer[0])[0].explode(".",$stackCopy->top())[0], $correctResult)) {
			$arcsCopy = $arcs;
			$movesCopy = unserialize($moves);
			
			$movesCopy[] = array("LEFT ARC", ($stackCopy->isEmpty() ? "" : explode(".",$stackCopy->top())[1]), (count($buffer)!=0 ? explode(".",$buffer[0])[1] : ""), $stackTopHasArc, $bufferNextHasArc);
			$movesCopy = serialize($movesCopy);
			$arcsCopy[] = $stackCopy->pop();
			if(count($buffer)==0&&$stackCopy->count()==1) {
				global $currentMoves;
				$currentMoves = $movesCopy;
				return;
			}
			nivre(serialize($stackCopy), $buffer, $arcsCopy, $movesCopy);
		}
	}

	$stackCopy = unserialize($stack);
	
	$stackTopHasArc = ($stackCopy->isEmpty() ? false : in_array($stackCopy->top(), $arcs));
	$bufferNextHasArc = (count($buffer)!=0 ? in_array($buffer[0], $arcs) : false);
	
	if(count($buffer)!=0&&!$stackCopy->isEmpty()&&!$bufferNextHasArc){// vai drīkst RIGHTARC?
		global $correctResult;
		if(in_array(explode(".",$stackCopy->top())[0].explode(".",$buffer[0])[0], $correctResult)) {
			$bufferCopy = $buffer;
			$arcsCopy = $arcs;
			$movesCopy = unserialize($moves);
			
			$movesCopy[] = array("RIGHT ARC", ($stackCopy->isEmpty() ? "" : explode(".",$stackCopy->top())[1]), (count($bufferCopy)!=0 ? explode(".",$bufferCopy[0])[1] : ""), $stackTopHasArc, $bufferNextHasArc);
			$movesCopy = serialize($movesCopy);
			$arcsCopy[] = $bufferCopy[0];
			$stackCopy->push(array_shift($bufferCopy));
			if(count($bufferCopy)==0&&$stackCopy->count()==1) {
				global $currentMoves;
				$currentMoves = $movesCopy;
				return;
			}
			nivre(serialize($stackCopy), $bufferCopy, $arcsCopy, $movesCopy);
		}
	}
}