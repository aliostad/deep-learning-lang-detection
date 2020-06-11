<?php namespace QuickConfigure\Dump;

use QuickConfigure\Dump\Contracts\DumperInterface;

class ArrayDumper implements DumperInterface {

    /**
     * Dump config to a PHP array.
     *
     * @see \QuickConfigure\Dump\Contracts\DumperInterface
     * @param stdClass $config
     * @return string
     */
    public function dump($config)
    {
        $dump  = '<?php' . PHP_EOL;

        $dump .= 'return array(';

        foreach ($config as $key => $value) {
            $dump .= "'" . addslashes($key) . "'=>'" . addslashes($value) . "',";
        }

        // Trim final trailing comma
        $dump = substr($dump, 0, strlen($dump) - 1);

        $dump .= ');' . PHP_EOL;

        return $dump;
    }

    /**
     * Get file extension ('php').
     *
     * @return string
     */
    public function getExtension()
    {
        return 'php';
    }
}
