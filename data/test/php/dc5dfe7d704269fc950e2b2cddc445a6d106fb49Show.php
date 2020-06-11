<?php
/**
 *	Show model
 */
class Show extends ActiveRecord\Model {
	/**
	 * Find all shows and make it into a SimpleXML Object
	 *
	 * @method all_xml
	 * @return Object SimpleXML instance
	 */	
	public static function all_xml() {
		$shows = Show::find('all');		
		$xml = new SimpleXMLElement('<programs/>');	
		foreach ($shows as &$show) {
			$show = $show->to_array();			
			$showXML = $xml->addChild('program');
			$showXML->addChild('date', $show['date']);
			$showXML->addChild('start_time', $show['start_time']);			
			$showXML->addChild('leadtext', $show['leadtext']);
			$showXML->addChild('name', $show['name']);
			$showXML->addChild('b-line', $show['bline']);
			$showXML->addChild('synopsis', $show['synopsis']);
			$showXML->addChild('url', $show['url']);
		}

		return $xml;		
	}	
}