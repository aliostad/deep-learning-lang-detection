import requests
import json
from students import Students
from courses import Courses


def main():
    request = requests.get("https://hackbulgaria.com/api/students/")
    api_data = json.loads(request.text)

    students = Students()
    courses = Courses()

    for api_student in api_data:
        student_id = students.insert(api_student["name"], api_student["github"], api_student["available"])
        for api_course in api_student["courses"]:
            course_id = courses.insert(api_course["name"])
            students.assign_to_course(student_id, course_id, api_course["group"])

if __name__ == '__main__':
    main()
