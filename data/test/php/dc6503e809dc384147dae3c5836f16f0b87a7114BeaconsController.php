<?php namespace Sightseeing\Controllers;

use Sightseeing\Repositories\Beacon\BeaconRepository;
use Sightseeing\Repositories\Sight\SightRepository;

class BeaconsController extends BaseController
{

    /**
     * @var BeaconRepository
     */
    private $beaconRepository;

    /**
     * @var SightRepository
     */
    private $sightRepository;

    function __construct(BeaconRepository $beaconRepository, SightRepository $sightRepository)
    {
        $this->beaconRepository = $beaconRepository;
        $this->sightRepository = $sightRepository;
    }

    public function index()
    {
        $beacons = $this->beaconRepository->getAll(['sight']);

        return \View::make('beacons.index')
            ->with('title', 'Manage Beacons')
            ->with('beacons', $beacons);
    }

    public function show($sightId)
    {
        $beacon = $this->beaconRepository->getById($sightId);
        $sights = $this->sightRepository->getAll();

        return \View::make('beacons.show')
            ->with('title', 'Edit Beacon')
            ->with('beacon', $beacon)
            ->with('sights', $sights);
    }

} 