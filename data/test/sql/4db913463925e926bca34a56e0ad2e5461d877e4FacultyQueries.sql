--Login (check for password)
SELECT Password 
FROM Faculty
WHERE FacultyNumber=ourFacultyVar;

--See all requested courses by all students
SELECT DISTINCT CoursesNeeded
FROM Students;

--See courses requested by a particular student
SELECT StudentNumber, CoursesNeeded
FROM CourseStudents
WHERE StudentNumber=ourStudentVar;

--See a current course preference form for a particular faculty member
SELECT *
FROM PreferenceForm
WHERE FacultyNumber=ourFacultyVar AND Crnt='Y';

--See past course perference forms for a particular faculty member
SELECT *
FROM PreferenceForm
WHERE FacultyNumber=ourFacultyVar AND Crnt='N';

--Add a new course preference form
INSERT INTO PreferenceForm
VALUES (NewFormNumber, NewFacultyNumber, NewSemester, NewNumberOfCourses, NewCoursePrefImportance, NewDaysImportance, NewTimesImportance,
	NewCoursePref1, NewCoursePref2, NewCoursePref3, NewMorningPref, NewDayPref, NewEveningPref, NewSummerPref, 'Y');

--Update an old course preference form before the new one is created
UPDATE PreferenceForm
SET Crnt='N'
WHERE FacultyNumber=ourFacultyVar;