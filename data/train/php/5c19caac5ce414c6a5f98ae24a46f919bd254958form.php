<?

if(!function_exists('SaveTextField'))
{
	function SaveTextField($field) 
	{ 
		return (isset($_POST[$field]))?$_POST[$field]:""; 
	}
}
if(!function_exists('SaveCheckbox'))
{
	function SaveCheckbox($field) 
	{ 
		return (isset($_POST[$field]))?"checked":"unchecked"; 
	}
}
if(!function_exists('SaveRadio'))
{
	function SaveRadio($field, $value) 
	{ 
		return (isset($_POST[$field])&&$_POST[$field]==$value)?"selected":"unselected"; 
	}
}
if(!function_exists('SaveDropdown'))
{
	function SaveDropdown($field, $value) 
	{ 
		return (isset($_POST[$field])&&$_POST[$field]==$value)?"selected":"unselected"; 
	}
}

?>