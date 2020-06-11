<?php

class Diff {
	private $chunk = '';
	private $originalChunkNumber;
	private $newChunkNumber;
	
	public function __construct($chunk = '', $originalChunkNumber, $newChunkNumber) {
		$this->chunk = (string) $chunk;
		$this->originalChunkNumber = $originalChunkNumber;
		$this->newChunkNumber = $newChunkNumber;
	}
	
	public function __toString() {
		return '(' . $this->originalChunkNumber . ', ' . $this->newChunkNumber . ') ' . $this->chunk;
	}
	
	public function getOriginalChunkNumber() {
		return $this->originalChunkNumber;
	}
	
	public function getNewChunkNumber() {
		return $this->newChunkNumber;
	}
	
	public function getChunk() {
		return $this->chunk;
	}
}

?>