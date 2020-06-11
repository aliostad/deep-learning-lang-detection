<?php

class Core_Mail_Transport_File extends Zend_Mail_Transport_Sendmail
{
    protected $_savePath;

    public function getSavePath()
    {
        return $this->_savePath;
    }

    public function setSavePath($path)
    {
        $this->_savePath = $path;
    }

    public function _sendMail()
    {
        $fileName = time() . '.eml';
        $data = 'Subject: ' . $this->_mail->getSubject() . "\n"
              . 'To: ' . $this->recipients . "\n"
              . $this->header . "\n\n"
              . $this->body;
        file_put_contents($this->getSavePath() . '/' . $fileName, $data);
    }
}