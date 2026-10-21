import 'dart:ffi';

import 'package:lms_layered_architecture_example/model/course.dart';

import '../model/student.dart';

class LmsSystem {
  final List<Student> students = [];
 
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

 void addCourse

  Course? findCourseOrNull (String courseId) {
    for (Course c in courses) {
      if (c.id==courseId) {
        return c;
      }
    }
    return null;
  }

  void removeCorse(String courseId) {
    for(Course course in courses) {
      if (course.id==null) {
        throw Exception("the course id doesn't exist");
      }
      if (course.id== courseId) {
        courses.remove(courseId);
      }
    }
  }
}
