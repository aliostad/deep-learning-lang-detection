<?php
namespace Zf2FileUploader\Resource\Handler\Persister;

use Zf2FileUploader\Resource\Handler\Persister\PersisterInterface;

abstract class AbstractFilesystemPersister implements PersisterInterface
{
    /**
     * @var \Closure
     */
    protected $saveClb = null;

    /**
     * @var \Closure
     */
    protected $cleanClb = null;

    /**
     * @param callable $save
     * @param callable $clean
     */
    protected function setCallbacks(\Closure $save = null, \Closure $clean = null)
    {
        $this->saveClb = $save;
        $this->cleanClb = $clean;
    }

    /**
     * @return boolean
     */
    public function commit()
    {
        if (!is_null($this->saveClb)) {
            $saveClb = $this->saveClb;
            $this->saveClb = null;
            return $saveClb();
        }

        return true;
    }

    public function rollback()
    {
        if (!is_null($this->cleanClb)) {
            $revertClb = $this->cleanClb;
            $this->cleanClb = null;
            $revertClb();
        }
    }
}