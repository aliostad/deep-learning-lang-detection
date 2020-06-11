<?php
/**
 * @author Stanislav Vetlovskiy
 * @date   11.08.14
 */

namespace Erliz\RucaptchaClient\Entity;


class SettingsEntity
{
    const API_DOMAIN           = 'http://rucaptcha.com/';
    const API_UPLOAD_ACTION    = 'in.php';
    const API_CHECK_ACTION     = 'res.php';
    const API_BASE64_METHOD    = 'base64';
    const API_FILE_METHOD      = 'post';
    const API_ANSWER_NOT_READY = 'CAPCHA_NOT_READY';

    const API_SUCCESS_CODE       = 'OK';
    const API_RESPONSE_DELIMITER = '|';

    const API_ANSWER_TRY_COUNT   = 12;
    const API_ANSWER_TIMEOUT     = 5;

    /** @var string */
    public $apiKey;

    /**
     * @return string
     */
    public function getApiKey()
    {
        return $this->apiKey;
    }

    /**
     * @param string $apiKey
     */
    public function setApiKey($apiKey)
    {
        $this->apiKey = $apiKey;
    }
} 