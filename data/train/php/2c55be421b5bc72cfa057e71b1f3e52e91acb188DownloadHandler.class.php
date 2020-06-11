<?php
/**
 * Helper class for all download handler
 */
final class DownloadHandler {
	/**
	 * Holds all registered handler
	 * @static
	 * @var object[]
	 */
	private static $handler = array();
	
	/**
	 * Registers a handler
	 * @static
	 * @param object Handler
	 */
	public static function registerHandler($handler) {
		if(!in_array($handler, DownloadHandler::$handler)) {
			DownloadHandler::$handler[] = $handler;
		}
	}
	
	/**
	 * Determines a handler for given file extension or MIME type
	 * @param string Extension
	 * @param string MIME type
	 * @return object Handler
	 */
	public static function getHandler($extension, $mime) {		
		foreach(DownloadHandler::$handler as $handler) {
            if($handler->isRegisteredMIME($mime)) {
                return $handler;
            }
        }
        
        foreach(DownloadHandler::$handler as $handler) {
            if($handler->isRegisteredExtension($extension)) {
                return $handler;
            }
        }
		
		return new DefaultHandler;
	}
}
?>