import 'package:test/test.dart';

import '../lib/service/lms_system.dart';

void main() {

  test('creates a student', () {
    final lms = LmsSystem();

    // Create a student
    lms.addStudent(studentId: 'S1', studentName: "ronan");

    expect(lms.students.first.name, 'ronan');

    // Remove the student
    lms.removeStudent(studentId: 'S1');
    expect(lms.students.length, 0);
  });

  test('rejects a duplicate student', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(() => lms.addStudent(studentId: 'S1', studentName: 'other'),
        throwsException);
    expect(lms.students.length, 1);
  });

  test('rejects removing a student that does not exist', () {
    final lms = LmsSystem();

    expect(() => lms.removeStudent(studentId: 'S99'), throwsException);
  }); 


  test('adds a course', () {
    final lms = LmsSystem();

    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(lms.courses.length, 1);
    expect(lms.courses.first.name, 'Mobile Development');
  });

  test('removes a course', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.removeCourse(courseId: 'C1');

    expect(lms.courses.length, 0);
  });

  test('rejects a duplicate course id', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(() => lms.addCourse(courseId: 'C1', courseName: 'Other'),
        throwsException);
    expect(lms.courses.length, 1);
  });

  test('rejects removing a course that does not exist', () {
    final lms = LmsSystem();

    expect(() => lms.removeCourse(courseId: 'C99'), throwsException);
  });

  test('removing a course deletes its results but keeps the student', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 80);

    lms.removeCourse(courseId: 'C1');

    expect(lms.courses.length, 0);
    expect(lms.results.length, 0);
    expect(lms.students.length, 1); // student still exists
  });

 
  test('enrolls a student in a course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(lms.courses.first.studentIds.length, 1);
    expect(lms.courses.first.studentIds.first, 'S1');
  });

  test('rejects enrollment if the student does not exist', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(() => lms.enrollStudent(studentId: 'S99', courseId: 'C1'),
        throwsException);
  });

  test('rejects enrollment if the course does not exist', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C99'),
        throwsException);
  });

  test('rejects duplicate enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(() => lms.enrollStudent(studentId: 'S1', courseId: 'C1'),
        throwsException);
    expect(lms.courses.first.studentIds.length, 1);
  });

  test('removes an existing enrollment', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.courses.first.studentIds.length, 0);
  });

  test('student and course still exist after the enrollment is removed', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.students.length, 1);
    expect(lms.courses.length, 1);
  });

  test('rejects removing an enrollment that does not exist', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    // S1 is NOT enrolled in C1
    expect(
        () => lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1'),
        throwsException);
  });

  test('removing an enrollment deletes the results of that course only', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.addCourse(courseId: 'C2', courseName: 'Databases');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 70);
    lms.addResult(studentId: 'S1', courseId: 'C2', score: 90);

    lms.discardStudentFromCourse(studentId: 'S1', courseId: 'C1');

    expect(lms.results.length, 1);
    expect(lms.results.first.courseId, 'C2');
  });

  test('removes a student who is enrolled in several courses', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addStudent(studentId: 'S2', studentName: 'sokha');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.addCourse(courseId: 'C2', courseName: 'Databases');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S1', courseId: 'C2');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 70);
    lms.addResult(studentId: 'S1', courseId: 'C2', score: 75);
    lms.addResult(studentId: 'S2', courseId: 'C1', score: 60);

    lms.removeStudent(studentId: 'S1');

    expect(lms.students.length, 1);
    expect(lms.students.first.id, 'S2');
    expect(lms.courses[0].studentIds, ['S2']); // C1
    expect(lms.courses[1].studentIds.length, 0); // C2
    // only S2's result is left
    expect(lms.results.length, 1);
    expect(lms.results.first.studentId, 'S2');
  });

 
  test('adds a valid result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);

    expect(lms.results.length, 1);
    expect(lms.results.first.score, 85);
  });

  test('rejects a result for a student that does not exist', () {
    final lms = LmsSystem();
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    expect(() => lms.addResult(studentId: 'S99', courseId: 'C1', score: 50),
        throwsException);
  });

  test('rejects a result for a course that does not exist', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');

    expect(() => lms.addResult(studentId: 'S1', courseId: 'C99', score: 50),
        throwsException);
  });

  test('rejects a result for a student who is not enrolled', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');

    // S1 exists and C1 exists, but S1 is not enrolled
    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 50),
        throwsException);
  });

  test('rejects a score below 0', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: -1),
        throwsException);
  });

  test('rejects a score above 100', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');

    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 101),
        throwsException);
  });

  test('rejects a second result for the same student and course', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);

    expect(() => lms.addResult(studentId: 'S1', courseId: 'C1', score: 90),
        throwsException);
    expect(lms.results.length, 1);
  });

  test('removes an existing result', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    int resultId = lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);

    lms.removeResult(resultId: resultId);

    expect(lms.results.length, 0);
  });

  test('rejects removing a result that does not exist', () {
    final lms = LmsSystem();

    expect(() => lms.removeResult(resultId: 999), throwsException);
  });

  test('removing a result keeps the student, course and other results', () {
    final lms = LmsSystem();
    lms.addStudent(studentId: 'S1', studentName: 'ronan');
    lms.addStudent(studentId: 'S2', studentName: 'sokha');
    lms.addCourse(courseId: 'C1', courseName: 'Mobile Development');
    lms.enrollStudent(studentId: 'S1', courseId: 'C1');
    lms.enrollStudent(studentId: 'S2', courseId: 'C1');
    int resultId1 = lms.addResult(studentId: 'S1', courseId: 'C1', score: 85);
    lms.addResult(studentId: 'S2', courseId: 'C1', score: 60);

    lms.removeResult(resultId: resultId1);

    expect(lms.results.length, 1); // S2's result is still there
    expect(lms.results.first.studentId, 'S2');
    expect(lms.students.length, 2);
    expect(lms.courses.length, 1);
    expect(lms.courses.first.studentIds.length, 2); // still enrolled
  });
}