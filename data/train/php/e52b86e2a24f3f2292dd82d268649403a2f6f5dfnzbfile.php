<?php defined('SYSPATH') or die('No direct script access.');
class NzbFile {

    public static function saveNzb($url, $saveDir, $saveName = null) {
        $saveName = (is_null($saveName)) ? basename($url) : $saveName;
        $invalidChar = array(
            '/',
            '\\',
            '"',
            '(',
            ')',
            '*',
            '|',
            '?',
            '%',
            '&',
            '#',
            '¤',
            '£',
            '$',
            '@',
            '!',
            '.',
            "'",
            '[',
            ']',
            '{',
            '}',
            '>',
            '<'
            );
        $saveName = str_replace($invalidChar, '', $saveName);
        $savePath = $saveDir . DIRECTORY_SEPARATOR . basename($saveName, '.nzb') . '.nzb';

        self::save($url, $savePath);
    }

    protected static function save($url, $savePath) {
        $ch = curl_init ($url);
        curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_BINARYTRANSFER, 1);
        $rawdata = curl_exec($ch);
        if ($rawdata === false) {
            throw new InvalidArgumentException('Error: No file at: ' . $url . '. Msg: ' . curl_error($ch));
        }
        curl_close ($ch);

        if(file_exists($savePath)) {
            unlink($savePath);
        }

        $fp = fopen($savePath, 'x');
        fwrite($fp, $rawdata);
        fclose($fp);
    }
}

?>
