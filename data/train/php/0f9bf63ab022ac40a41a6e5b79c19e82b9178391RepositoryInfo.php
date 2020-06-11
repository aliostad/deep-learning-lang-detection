<?php

namespace FP\Larmo\Agents\WebHookAgent\Services;

trait RepositoryInfo
{
    private $repositoryInfo;

    private function setRepositoryInfo($data)
    {
        if (!isset($data->repository)) {
            return null;
        } else {
            $repository = $data->repository;
        }

        $repositoryData = $this->prepareRepositoryData($repository);

        return $repositoryData;
    }

    public function getRepositoryInfo()
    {
        return $this->repositoryInfo;
    }

    abstract protected function prepareRepositoryData($repository);
}
