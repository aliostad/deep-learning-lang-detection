package com.myone.pomodoro.domain
 
import org.scalatest.FunSuite
import org.scalatest.BeforeAndAfter
import com.myone.pomodoro.domain._
import com.myone.pomodoro.domain.EmBreakPomodoro._
import com.myone.pomodoro.infra._

class TestTimeMgrServiceSuite extends FunSuite with BeforeAndAfter {
  var timeMgr:TimeManageService = _

  before { 
	timeMgr = new TimeManageService
  }
  
  test ("Start pomodoro attribute check") { 
	timeMgr.startPomodoro(taskId=1)
	assert(timeMgr.emTimeMgrKind == idPomodoro)
	assert(timeMgr.currentExecTaskId == 1)
	
  }
}
