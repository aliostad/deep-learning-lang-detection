<?php
namespace Cianflone\Again\Repositories\Eloquent;

use Carbon\Carbon;
use Cianflone\Again\Entities\Show;
use Cianflone\Again\Exceptions\ShowDoesNotExistException;
use Cianflone\Again\Exceptions\UnableToDeleteShowException;
use Cianflone\Again\Repositories\ShowRepository;

class EloquentShowRepository implements ShowRepository
{
    protected $show;

    public function __construct(Show $show)
    {
        $this->show = $show;
    }

    public function findAllShows()
    {
        $shows = $this->show->all()->toArray();
        for ($i=0; $i < count($shows); $i++) {
            $shows[$i]['is_over'] = $this->isShowOver($shows[$i]);
        }

        return $shows;
    }

    public function save(array $show)
    {

    }

    public function update($showId, array $show)
    {
        $currentShow = $this->show->find($showId);
        foreach ($show as $key => $value) {
            $currentShow->{$key} = $value;
        }

        $currentShow->save();

    }

    public function delete($showId)
    {
        try {
            return $this->show->destroy($showId);
        } catch (ShowDoesNotExistException $e) {
            throw new UnableToDeleteShowException('Show ID does not exist');
        }
    }

    public function get($showId)
    {
        $show = $this->show->find($showId);

        if (is_null($show)) {
            throw new ShowDoesNotExistException('Show ID does not exist');
        }

        return $show->toArray();
    }

    public function createNewShow(array $show)
    {
        return $this->show->create($show);
    }

    public function isShowOver($show)
    {
        if ($show['show_date'] !== '') {
            $date = explode('.', $show['show_date']);

            if (count($date) > 1) {
                $dx = array_map(function ($d) {
                    return (int) $d;
                }, $date);

                $showDate = Carbon::createFromDate($dx[2], $dx[0], $dx[1]);
                $today = Carbon::now();

                return $today->diffInDays($showDate, false) < 0 ? true : false;
            }
        }

        return false;
    }
}
