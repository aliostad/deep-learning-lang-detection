<?php

//credits to http://www.axelbrz.com.ar/?mod=iphone-png-images-normalizer

function getNormalizedPNG($oldPNG) {
        $pngheader = "\x89PNG\r\n\x1a\n";

        if (substr($oldPNG, 0, 8) != $pngheader)
            return;

        $newPNG = substr($oldPNG, 0, 8);

        $chunkPos = 8;

        while ($chunkPos < strlen($oldPNG)) {
            // Reading chunk
            $chunkLength = unpack("N", substr($oldPNG, $chunkPos, $chunkPos + 4));
            $chunkLength = array_shift($chunkLength);
            $chunkType = substr($oldPNG, $chunkPos + 4, 4);
            $chunkData = substr($oldPNG, $chunkPos + 8, $chunkLength);
            $chunkCRC = unpack("N", substr($oldPNG, $chunkPos + $chunkLength + 8, 4));

            $chunkCRC = array_shift($chunkCRC);
            $chunkPos += $chunkLength + 12;

            // Reading header chunk
            if ($chunkType == 'IHDR') {
                $width = unpack("N", substr($chunkData, 0, 4));
                $width = array_shift($width);
                $height = unpack("N", substr($chunkData, 4, 8));
                $height = array_shift($height);
            }

            // Reading image chunk
            if ($chunkType == 'IDAT') {
                try {
                    // Uncompressing the image chunk
                    $bufSize = $width * $height * 4 + $height;
                    $chunkData = zlib_decode($chunkData, $bufSize);
                } catch (Exception $exc) {
                    return $oldPNG; // already optimized
                }

                // Swapping red & blue bytes for each pixel
                $newdata = "";
                for ($y = 0; $y < $height; $y++) {
                    $i = strlen($newdata);
                    $newdata .= $chunkData[$i];
                    for ($x = 0; $x < $width; $x++) {
                        $i = strlen($newdata);
                        $newdata .= $chunkData[$i + 2];
                        $newdata .= $chunkData[$i + 1];
                        $newdata .= $chunkData[$i + 0];
                        $newdata .= $chunkData[$i + 3];
                    }
                }

                // Compressing the image chunk
                $chunkData = $newdata;
                $chunkData = zlib_encode($chunkData, ZLIB_ENCODING_DEFLATE);


                $chunkLength = strlen($chunkData);
                $chunkCRC = crc32($chunkType . $chunkData);
            }

            if ($chunkType != 'CgBI') {
                $newPNG .= pack("N", $chunkLength);
                $newPNG .= $chunkType;
                if ($chunkLength > 0)
                    $newPNG .= $chunkData;
                $newPNG .= pack("N", $chunkCRC);
            }

            // Reading header chunk
            if ($chunkType == 'IEND') {
                break;
            }
        }

        return $newPNG;

}
