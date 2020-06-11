<?php

namespace Modera\FileUploaderBundle\Uploading;

use Modera\FileRepositoryBundle\Repository\FileRepository;
use Symfony\Component\HttpFoundation\Request;

/**
 * @author    Sergei Lissovski <sergei.lissovski@modera.org>
 * @copyright 2014 Modera Foundation
 */
class AllExposedRepositoriesGateway implements UploadGatewayInterface
{
    private $fileRepository;

    /**
     * @param FileRepository $fileRepository
     */
    public function __construct(FileRepository $fileRepository)
    {
        $this->fileRepository = $fileRepository;
    }

    /**
     * @param Request $request
     *
     * @return string
     */
    protected function getRepositoryName(Request $request)
    {
        return $request->request->get('_repository');
    }

    /**
     * {@inheritdoc}
     */
    public function isResponsible(Request $request)
    {
        $repositoryName = $request->request->get('_repository');
        if ($repositoryName) {
            return $this->fileRepository->repositoryExists($repositoryName);
        }

        return false;
    }

    /**
     * {@inheritdoc}
     */
    public function upload(Request $request)
    {
        $repositoryName = $this->getRepositoryName($request);

        $ids = array();
        foreach ($request->files as $file) {
            if ($file) {
                $storedFile = $this->fileRepository->put($repositoryName, $file);
                $ids[] = $storedFile->getId();
            }
        }

        return array(
            'success' => true,
            'ids' => $ids,
        );
    }

    public static function clazz()
    {
        return get_called_class();
    }
}
