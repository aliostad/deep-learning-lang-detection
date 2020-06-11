<?php
/**
 * This file is part of tomkyle/yaphr.
 */
namespace tomkyle\yaphr\FileSystem;

class SaveGif extends SaveImageAbstract implements SaveImageInterface
{

    /**
     * @uses SaveImageAbstract::makeSureIsResource()
     * @uses SaveImageAbstract::makeSureIsString()
     */
    public function __construct( $image, $save_path, $quality = 100 )
    {
        $image     = $this->makeSureIsResource( $image );
        $save_path = $this->makeSureIsString( $save_path );

        imagegif($image, $save_path);
    }

}
