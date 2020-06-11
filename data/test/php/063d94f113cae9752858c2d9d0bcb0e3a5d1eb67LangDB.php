<?php

require_once __DIR__ . '/LangBase.php';
require_once __DIR__ . '/DBBase.php';

class LangDB extends LangBase {

    static public function COPY($copy_name, $default_value = '') {
        $instance = new LangDB();
        return $instance->getCOPY($copy_name, $default_value);
    }

    protected function getCopyValue($copy_name) {
        $copy_value = null;

        if (USE_DATABASE) {

            $copyInfo = DB::getLangCopy(self::$_lang, $copy_name);
            if (is_array($copyInfo) && isset($copyInfo['copy'])) {
                $copy_value = $copyInfo['copy'];
            } else {
                Log::newEntry("WARNING: LangDB::getCopyValue() could not found a match to copy '$copy_name' in lang '" . self::$_lang . "'", $copyInfo);
            }
        }

        return $copy_value;
    }

}

?>