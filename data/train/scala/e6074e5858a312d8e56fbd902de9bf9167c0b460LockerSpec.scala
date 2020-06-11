package com.tw.oocamp

import org.scalatest.FunSuite

class LockerSuite extends FunSuite {

  test("given locker when locker store a bag after should can't store same bag again") {
    val locker = new Locker()
    val bag = new Bag()
    assert(None != locker.store(bag))
    assert(None == locker.store(bag))
  }

  test("given locker should can store a fixed number of bags") {
    val locker = new Locker(2);
    assert(None != locker.store(new Bag))
    assert(None != locker.store(new Bag))
    assert(None == locker.store(new Bag))
  }

  test("given locker when locker store bag then return is not None") {
    val bag = new Bag()
    assert(new Locker().store(bag)!=None)
  }

  test("given locker when pick a bag with ticket then return original bag") {
    val bag = new Bag()
    val locker = new Locker()
    assert(bag == locker.pick(locker.store(bag)))
  }

  test("given locker when pick a bag with null ticket then return null") {
    val locker = new Locker()
    assert(locker.pick(None)==null)
  }

  test("given locker when pick a bag with ticket then can't use this ticket again") {
    val locker = new Locker()
    val ticket = locker.store(new Bag())
    assert(null!=locker.pick(ticket))
    assert(null==locker.pick(ticket))
  }

  test("given robot should take a ticket to robot that has not manage a locker yet then can't return bag") {
    val robot = new SimpleRobot()
    val ticket = (new Locker).store(new Bag)
    assert(null==robot.pick(ticket))
  }

  test("given a ticket when take ticket to robot then robot should pick original bag") {
    val bag = new Bag()
    val locker = new Locker();
    val ticket = locker.store(bag)
    val robot = new SimpleRobot()
    robot.manage(locker)
    assert(robot.pick(ticket) == bag)
  }

  test("given robot when robot manage some lockers then robot should store bag with seq") {
    val bag = new Bag()
    val robot = new SimpleRobot(3)
    val locker1st=new Locker()
    val locker2nd = new Locker()
    val locker3rd= new Locker()


    robot.manage(locker1st)
    robot.manage(locker3rd)
    robot.manage(locker2nd)


    robot.store(new Bag())
    robot.store(new Bag())
    val ticket = robot.store(bag)

    assert(bag==locker2nd.pick(ticket))
  }

  test("given smart robot should manage a fixed number of lockers"){
    val smartRobot = new SmartRobot(2)
    smartRobot.manage(new Locker())
    smartRobot.manage(new Locker())
    intercept[Exception]{
      smartRobot.manage(new Locker())
    }
  }

  test("given smart robot when all of lockers has full then should can't get ticket"){
    val smartRobot = new SmartRobot(1)
    val locker = new Locker()
    smartRobot.manage(locker)
    smartRobot.store(new Bag())
    assert(None==smartRobot.store(new Bag()))

  }

  test("given smart robot when store a bag then bag should stored in locker has max remaining number "){
    val smartRobot = new SmartRobot(3)
    val locker1 = new Locker(1)
    val locker2 = new Locker(2)
    val locker4 = new Locker(4)
    smartRobot.manage(locker1)
    smartRobot.manage(locker2)
    smartRobot.manage(locker4)

    val bag = new Bag()
    val ticket = smartRobot.store(bag)
    assert(bag==locker4.pick(ticket))

  }

  test("given super robot when store a bag then bag should shtored in locker has max vacancy rate") {
    var superRobot = new SuperRobot(2)
    val locker2 = new Locker(2)
    val locker6 = new Locker(6)

    locker2.store(new Bag())
    locker6.store(new Bag())
    locker6.store(new Bag())
    locker6.store(new Bag())
    locker6.store(new Bag())

    val bag = new Bag()
    superRobot.manage(locker2)
    superRobot.manage(locker6)

    val ticket = superRobot.store(bag)

    assert(bag == locker2.pick(ticket))
  }
}