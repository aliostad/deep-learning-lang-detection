<?php
/**
 * function.array_copy.php
 * @author Jim P 
 * @url https://github.com/jimpoulakos/
 * @version 1.0
 */
if(!function_exists('array_copy')){
	/**
	 * array_copy This function does a recursive, deep copy of an array.
	 * @param <mixed[]> $array_to_copy The array to be copied.
	 * @return <mixed[]> Returns a copied array.
	 */
	function array_copy($array_to_copy){
		if(!is_array($array_to_copy)) return is_object($array_to_copy)? clone $array_to_copy: $array_to_copy;

		$clone = array();
		foreach($array_to_copy as $key => $value){
			$clone[$key] = array_copy($value);
		}

		return $clone;
	}
}
