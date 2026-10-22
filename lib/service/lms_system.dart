import 'dart:ffi';

import 'package:lms_layered_architecture_example/model/course.dart';
import 'package:lms_layered_architecture_example/model/courseResult.dart';

import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
  final List <CourseResult> results = [];
 
  void addStudent({required String studentId, required String studentName}) {
    // ! Student shall not exist already
    Student? student = _findStudentOrNull(studentId);
    if (student != null) {
      throw Exception('Student $student already exists');
    }

    students.add(Student(id: studentId, name: studentName));
  }
 
 
  void removeStudent({required String studentId}) {
    Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }

  for (Course course in courses) {
    course.studentIds.remove(studentId);
  }

   results.removeWhere((result) => result.studentId == studentId);

    // 1- Remove student from the students list
    students.removeWhere((student) => student.id == studentId);
 
  }

  Student? _findStudentOrNull(String studentId) {
    for (Student s in students) {
      if (s.id == studentId) {
        return s;
      }
    }
    return null; // not found
  } 

  final List <Course> courses=[];

 void addCourse({required String courseId, required String courseName}) {
  Course? course = _findCourseOrNull(courseId);

    if (course !=null) {
      throw Exception("The course id $courseId is already exist");
    }
    courses.add(Course(id: courseId, name: courseName));
 }

  Course? _findCourseOrNull (String courseId) {
    for (Course c in courses) {
      if (c.id==courseId) {
        return c;
      }
    }
    return null;
  }

 void removeCourse({required courseId}) {
  Course? course =_findCourseOrNull(courseId);

  if (course==null) {
    throw Exception("The course with id $courseId doesn't exist");
  }
  courses.removeWhere((course)=> course.id==courseId);
 }

 void enrollStudent({required String studentId, required String courseId}) {
  Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
   Course? course =_findCourseOrNull(courseId);
  if (course==null) {
    throw Exception("The course with id $courseId not found");
  }

  if (course.studentIds.contains(studentId)) {
    throw Exception("Student $studentId already enroll in coourse $courseId");
  }
  course.studentIds.add(studentId);
 }

 void discardStudentFromCourse ({required String studentId,required String courseId}) {
  Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
  Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    course.studentIds.remove(studentId);
    
  }

  int _nextResultId = 1;

 int addResult ({required String studentId,required String courseId,required int score}) {
  Student? student = _findStudentOrNull(studentId);
    if (student == null) {
      throw Exception('Student $studentId not found');
    }
  Course? course = _findCourseOrNull(courseId);
    if (course == null) {
      throw Exception('Course $courseId not found');
    }
    if (!course.studentIds.contains(studentId)) {
      throw Exception('Student $studentId is not enrolled in $courseId');
    }
    if (score < 0 || score > 100) {
      throw Exception('Score $score is invalid (must be 0-100)');
    }
  
    for (CourseResult r in results) {
      if (r.studentId == studentId && r.courseId == courseId) {
        throw Exception('Result already exists for $studentId in $courseId');
      }
    }
    int id = _nextResultId++;
    results.add(CourseResult(id: id, studentId: studentId, courseId: courseId, score: score));
    return id;
  }
   void removeResult({required int resultId}) {
    
    CourseResult? result = _findResultOrNull(resultId);
    if (result == null) {
      throw Exception('Result $resultId not found');
    }

    results.remove(result);
  }

  CourseResult? _findResultOrNull(int resultId) {
    for (CourseResult r in results) {
      if (r.id == resultId) {
        return r;
      }
    }
    return null; // not found
  }
}

