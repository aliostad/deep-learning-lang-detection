<?php
/**
 * This file is part of tomkyle/yaphr.
 */
namespace tomkyle\yaphr\FileSystem;


class SaveJpeg extends SaveImageAbstract implements SaveImageInterface
{

    /**
     * @uses SaveImageAbstract::makeSureIsResource()
     * @uses SaveImageAbstract::makeSureIsString()
     */
    public function __construct( $image, $save_path, $quality = 100 )
    {
        $image     = $this->makeSureIsResource( $image );
        $save_path = $this->makeSureIsString( $save_path );

        imagejpeg( $image, $save_path, $quality);

    }
}
