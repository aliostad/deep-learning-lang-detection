<?php
/**
 * Created by Cao Jiayuan.
 * Date: 17-5-31
 * Time: 下午2:18
 */

namespace App\Http\Controllers;


use App\Entity\Meta;
use App\Entity\Room;
use App\Repository\AdRepository;
use App\Repository\RoomRepository;
use App\User;

class RoomController extends Controller
{
  public function users(RoomRepository $repository, $roomId)
  {
    return $repository->users($roomId);
  }

  public function children(RoomRepository $repository, $roomId)
  {
    return $repository->children($roomId);
  }

  public function notice(RoomRepository $repository, $roomId)
  {
    return $repository->notice($roomId);
  }

  public function backgrounds(RoomRepository $repository, $roomId)
  {
    return $repository->backgrounds($roomId);
  }

  public function getServices(RoomRepository $repository, $roomId)
  {
    return $repository->services($roomId);
  }

  public function getInfo($roomId)
  {
    $room = Room::find($roomId);
    if (!$room->permission && !$room->main) {
      $roomId = $room->main_id;
    }
    $mainId = $roomId;
    if (!$room->main) {
      $mainId = $room->main_id;
    }
    Meta::$roomId = $roomId;
    $r = Meta::getItem([
      'disclaimer',
      'copyright',
      'interactive',
      'calendar',
    ]);
    Meta::$roomId = $mainId;
    $m = Meta::getItem(['gold_lecturer','gold_lecturer_name']);
    return array_merge($r, $m);
  }

  public function getBanners(AdRepository $repository, $roomId)
  {
    return $repository->banners($roomId);
  }

  public function getMaskings(RoomRepository $repository, $roomId)
  {
    return $repository->maskings($roomId);
  }

  public function join(RoomRepository $repository)
  {
    $data = $this->getValidatedData([
      'roomId' => 'required',
      'id'     => 'required',
    ]);
    $repository->join($data['roomId'], User::find($data['id']));
    return $this->respondSuccess('Join success');
  }

  public function leave(RoomRepository $repository)
  {
    $data = $this->getValidatedData([
      'roomId' => 'required',
      'id'     => 'required',
      'loginId'
    ]);
    $repository->leave($data['roomId'], $data['id'], $data['loginId']);
    return $this->respondSuccess('Leave success');
  }

  public function popup(RoomRepository $repository, $roomId)
  {
    return $repository->popup($roomId);
  }

  public function schedules(RoomRepository $repository, $roomId)
  {
    return $repository->schedules($roomId);
  }

  public function creditRules(RoomRepository $repository, $roomId)
  {

    return $repository->creditRules($roomId);
  }

  public function goods(RoomRepository $repository, $roomId)
  {
    return $repository->goods($roomId);
  }


  public function gifts(RoomRepository $repository, $roomId)
  {
    return $repository->gifts($roomId);
  }
}