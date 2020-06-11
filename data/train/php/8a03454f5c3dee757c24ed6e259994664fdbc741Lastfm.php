<?php
/**
 * @author  Eugene Serkin <jserkin@gmail.com>
 * @version $Id$
 */
namespace Api\Music;

class Lastfm
{
	const
		VERSION = '2.0',
		URL     = 'http://ws.audioscrobbler.com/';

	/**
	 * @var string
	 */
	private $apiUrl;

	/**
	 * @var string
	 */
	private $apiKey;

	/**
	 * @var array
	 */
	private $apiResources = array();

	/**
	 * @param string $apiKey
	 */
	public function __construct( $apiKey )
	{
		$this->apiUrl = self::URL . self::VERSION;
		$this->apiKey = $apiKey;
	}

	/**
	 * @return string
	 */
	public function getApiUrl()
	{
		return $this->apiUrl;
	}

	/**
	 * @return string
	 */
	public function getApiKey()
	{
		return $this->apiKey;
	}

	/**
	 * @return \Api\Music\Lastfm\Album\Resource
	 */
	public function getAlbum()
	{
		if ( ! isset( $this->apiResources['album'] ) )
		{
			$this->apiResources['album'] = new \Api\Music\Lastfm\Album\Resource( $this );
		}

		return $this->apiResources['album'];
	}
}
