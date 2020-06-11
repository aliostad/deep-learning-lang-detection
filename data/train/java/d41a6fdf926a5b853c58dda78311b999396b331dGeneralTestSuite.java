package com.orangecandle.server;


import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import com.orangecandle.server.controller.LinkControllerTest;
import com.orangecandle.server.controller.UserControllerTest;
import com.orangecandle.server.repository.BuildingRepositoryTest;
import com.orangecandle.server.repository.DepartmentRepositoryTest;
import com.orangecandle.server.repository.FacultyRepositoryTest;
import com.orangecandle.server.repository.GroupRepositoryTest;
import com.orangecandle.server.repository.LectureRepositoryTest;
import com.orangecandle.server.repository.RoomRepositoryTest;
import com.orangecandle.server.repository.SchoolRepositoryTest;
import com.orangecandle.server.repository.UserRepositoryTest;

// specify a runner class: Suite.class
@RunWith(Suite.class)
// specify an array of test classes
@Suite.SuiteClasses({
	LinkControllerTest.class,
	UserControllerTest.class,
	BuildingRepositoryTest.class,
	DepartmentRepositoryTest.class,
	FacultyRepositoryTest.class,
	GroupRepositoryTest.class,
	LectureRepositoryTest.class,
	RoomRepositoryTest.class,
	SchoolRepositoryTest.class,
	UserRepositoryTest.class

})
public class GeneralTestSuite {

}
