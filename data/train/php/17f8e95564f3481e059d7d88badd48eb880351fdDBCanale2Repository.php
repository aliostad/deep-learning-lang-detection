<?php

namespace Universibo\Bundle\LegacyBundle\Entity;

use Doctrine\DBAL\DBALException;
use Universibo\Bundle\LegacyBundle\PearDB\ConnectionWrapper;

/**
 * Canale repository
 *
 * @author Davide Bellettini <davide.bellettini@gmail.com>
 * @license GPL v2 or later
 */
class DBCanale2Repository extends DBRepository
{

    /**
     * @var DBCanaleRepository
     */
    private $channelRepository;

    /**
     * @var DBCdlRepository
     */
    private $cdlRepository;

    /**
     * @var DBFacoltaRepository
     */
    private $facultyRepository;

    /**
     * @var DBInsegnamentoRepository
     */
    private $subjectRepository;

    /**
     * Class constructor
     *
     * @param ConnectionWrapper        $db
     * @param DBCanaleRepository       $channelRepository
     * @param DBCdlRepository          $cdlRepository
     * @param DBFacoltaRepository      $facultyRepository
     * @param DBInsegnamentoRepository $subjectRepository
     * @param boolean                  $convert
     */
    public function __construct(ConnectionWrapper $db,
            DBCanaleRepository $channelRepository,
            DBCdlRepository $cdlRepository,
            DBFacoltaRepository $facultyRepository,
            DBInsegnamentoRepository $subjectRepository, $convert = false)
    {
        parent::__construct($db, $convert);

        $this->channelRepository = $channelRepository;
        $this->cdlRepository = $cdlRepository;
        $this->facultyRepository = $facultyRepository;
        $this->subjectRepository = $subjectRepository;
    }

    public function findManyByType($type)
    {
        switch ($type) {
            case Canale::FACOLTA:
                return $this->facultyRepository->findAll();
            case Canale::CDL:
                return $this->cdlRepository->findAll();
            case Canale::INSEGNAMENTO:
                return $this->subjectRepository->findAll();
            default:
                $ids = $this->channelRepository->findManyByType($type);

                return $this->channelRepository->findManyById($ids);
        }
    }

    /**
     * @param  int           $id
     * @throws DBALException
     * @return Canale
     */
    public function find($id)
    {
        $db = $this->getConnection();

        $sql = 'SELECT tipo_canale FROM canale WHERE id_canale = ?';
        $type = $db->fetchColumn($sql, [$id]);

        if (false === $type) {
            return null;
        }

        switch ($type) {
            case Canale::FACOLTA:
                return $this->facultyRepository->find($id);
            case Canale::CDL:
                return $this->cdlRepository->findByIdCanale($id);
            case Canale::INSEGNAMENTO:
                return $this->subjectRepository->findByChannelId($id);
            default:
                return $this->channelRepository->find($id);
        }
    }

    /**
     * DBCanaleRepository fallback
     *
     * @param  string $name
     * @param  array  $arguments
     * @return mixed
     */
    public function __call($name, $arguments)
    {
        return call_user_func_array([$this->channelRepository, $name], $arguments);
    }
}
