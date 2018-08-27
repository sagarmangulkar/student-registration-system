set serveroutput on;
set pagesize 190;
set linesize 190;

DROP TRIGGER trigger_enroll;
DROP TRIGGER trigger_students;

--Sequence
--Sequence name: logid_seq
--Details: generates auto increamenting logid in logs table.

DROP SEQUENCE logid_seq;
CREATE SEQUENCE logid_seq START WITH 1000 INCREMENT BY 1;

--Package Started

CREATE OR REPLACE package student_registration_system AS
 type ref_cursor is ref cursor;

--SP2
procedure sp_show_students (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_courses (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_course_credit (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_classes (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_enrollments (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_grades (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_prerequisites (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
procedure sp_show_logs (m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);
--End of SP2

--SP3
procedure sp_classes_taken_by_student (v_in_b_number IN students.B#%type, m_var_cursor IN OUT ref_cursor, v_out_error_message OUT VARCHAR2);

--SP4
procedure sp_find_prerequisites (v_in_dept_code IN courses.dept_code%type ,v_in_course# IN courses.course#%type, m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2);

--SP5
procedure sp_get_class_students (v_in_class_id IN classes.classid%type, m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2);

--SP6
PROCEDURE sp_enroll
(v_in_b_number IN STUDENTS.B#%TYPE,
v_in_class_id IN CLASSES.CLASSID%TYPE,
v_out_error_message OUT VARCHAR2);

--SP7
PROCEDURE sp_drop_enrollment
(v_in_b_number IN STUDENTS.B#%TYPE,
v_in_class_id IN CLASSES.CLASSID%TYPE,
v_out_error_message OUT VARCHAR2);

--SP8
PROCEDURE sp_delete_student
(v_in_b_number IN STUDENTS.B#%TYPE,
v_out_error_message OUT VARCHAR2);

END;
/

CREATE OR REPLACE package BODY student_registration_system AS


--Stored Procedure name: sp_show_students
--Details: Fetches all the tuples of the table STUDENTS
procedure sp_show_students (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT B#, firstname, lastname, status, gpa, email, bdate, deptname
		FROM students;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_courses
--Details: Fetches all the tuples of the table COURSES
procedure sp_show_courses (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT dept_code, course#, title
		FROM courses;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_course_credit
--Details: Fetches all the tuples of the table COURSE_CREDIT
procedure sp_show_course_credit (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT course#, credits
		FROM course_credit;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_classes
--Details: Fetches all the tuples of the table CLASSES
procedure sp_show_classes (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT classid, dept_code, course#, sect#, year, semester, limit, class_size
		FROM classes;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_enrollments
--Details: Fetches all the tuples of the table ENROLLMENTS
procedure sp_show_enrollments (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT B#, classid, lgrade
		FROM enrollments;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_grades
--Details: Fetches all the tuples of the table GRADES
procedure sp_show_grades (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT lgrade, ngrade
		FROM grades;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_prerequisites
--Details: Fetches all the tuples of the table PREREQUISITES
procedure sp_show_prerequisites (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT dept_code, course#, pre_dept_code, pre_course#
		FROM prerequisites;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--Stored Procedure name: sp_show_logs
--Details: Fetches all the tuples of the table LOGS
procedure sp_show_logs (m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
BEGIN
	open m_var_cursor for
		SELECT logid, who, time, table_name, operation, key_value
		FROM logs;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
				v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;
--End of SP2

--SP3
--Stored Procedure name: sp_classes_taken_by_student
--Details: For a given student B#, it fetches all the classes taken by the student uptill now.
procedure sp_classes_taken_by_student (v_in_b_number IN students.B#%type, m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
v_data_found_student NUMBER;
v_data_found_courses_taken NUMBER;

BEGIN
SELECT COUNT(*) INTO v_data_found_student FROM students WHERE B# = v_in_b_number; --check if the given B# exists in the Students table.
SELECT COUNT(*) INTO v_data_found_courses_taken FROM ENROLLMENTS
		WHERE B# = v_in_b_number; -- checks whether a student has taken any courses.

IF (v_data_found_student = 0) THEN
		v_out_error_message := 'The Student B#: ' || v_in_b_number || ' is invalid.';
ELSIF (v_data_found_courses_taken = 0) THEN
		v_out_error_message := 'The student has not taken any course.';
ELSE
	open m_var_cursor for
		SELECT cl.classid, cl.dept_code, cl.course#, cl.sect#, cl.year, cl.semester, e.lgrade, g.ngrade
		FROM classes cl, enrollments e, grades g
		WHERE e.B# = v_in_b_number AND e.classid = cl.classid AND e.lgrade = g.lgrade;
END IF;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;

--SP4
--Stored Procedure name: sp_find_prerequisites
--Details: For a given course, it fetches all the courses which need the input course as prerequisite diretly or indirectly.
procedure sp_find_prerequisites (v_in_dept_code IN courses.dept_code%type ,v_in_course# IN courses.course#%type, m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
v_data_found_dept_code_course# NUMBER;

BEGIN
SELECT COUNT(*) INTO v_data_found_dept_code_course# FROM courses WHERE dept_code = v_in_dept_code AND course# = v_in_course#;

IF (v_data_found_dept_code_course# = 0)THEN
	v_out_error_message:= 'The Dept. code: ' || v_in_dept_code || ' or the course#: ' || v_in_course# || ' is invalid.';
ELSE
	open m_var_cursor for
		WITH prereq_table(dept_code, course#, pre_dept_code, pre_course#) AS (
			--The query below gets all the courses which need the input course as a prerequisite(direct).
			SELECT p.dept_code, p.course#, p.pre_dept_code, p.pre_course#
			FROM prerequisites p
			WHERE p.pre_dept_code = v_in_dept_code AND p.pre_course# = v_in_course#

			UNION ALL

			/*The query below takes the courses form the above query and a join is performed with
			prerequistes table to get the courses which need the direct courses as prerequisites
			(ie. the ones which need the input course as indirect prerequisite)*/
			SELECT p.dept_code, p.course#, p.pre_dept_code, p.pre_course#
			FROM prerequisites p, prereq_table pt
			WHERE pt.dept_code = p.pre_dept_code AND pt.course# = p.pre_course#)
		SELECT CONCAT(dept_code,course#) AS courses_p
		FROM prereq_table;
END IF;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--SP5
--Stored Procedure name: sp_get_class_students
--Details: For a given class, it fetches classid, course tile and the B# and firstname of students who took the class.
procedure sp_get_class_students (v_in_class_id IN classes.classid%type, m_var_cursor IN out ref_cursor, v_out_error_message OUT VARCHAR2) AS
v_data_found_class_id NUMBER;
v_data_found_student_in_class NUMBER;

BEGIN
SELECT COUNT(*) INTO v_data_found_class_id FROM CLASSES WHERE CLASSID = v_in_class_id;
SELECT COUNT(*) INTO v_data_found_student_in_class FROM ENROLLMENTS
		WHERE CLASSID = v_in_class_id;

IF (v_data_found_class_id = 0) THEN
		v_out_error_message := 'The Classid: ' || v_in_class_id || ' is invalid.';
ELSIF (v_data_found_student_in_class = 0) THEN
		v_out_error_message := 'No student has enrolled in the class.';
ELSE
	open m_var_cursor for
		SELECT cl.classid, co.title, s.B#, s.firstname
		FROM classes cl, enrollments e, courses co, students s
		WHERE cl.classid = v_in_class_id AND cl.dept_code = co.dept_code AND cl.course# = co.course# AND cl.classid = e.classid AND e.B#=s.B#;
END IF;
EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;

END;


--SP6
--Store Procedure name: sp_enroll
--Details: enrolls a student into a class.
PROCEDURE sp_enroll
(v_in_b_number IN STUDENTS.B#%TYPE,
v_in_class_id IN CLASSES.CLASSID%TYPE,
v_out_error_message OUT VARCHAR2)
IS
	v_b_number STUDENTS.B#%TYPE;
	v_class_id CLASSES.CLASSID%TYPE;
	v_data_found_students NUMBER;
	v_data_found_class_id NUMBER;
	v_vacancy NUMBER;
	v_data_found_student_in_class NUMBER;
	v_year CLASSES.YEAR%TYPE;
	v_semester CLASSES.SEMESTER%TYPE;
	v_data_found_overloaded NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_data_found_students FROM STUDENTS WHERE B# = v_in_b_number;
	SELECT COUNT(*) INTO v_data_found_class_id FROM CLASSES WHERE CLASSID = v_in_class_id;
	SELECT COUNT(*) INTO v_data_found_student_in_class FROM ENROLLMENTS
		WHERE B# = v_in_b_number AND CLASSID = v_in_class_id;
	IF (v_data_found_class_id > 0)
	THEN
		SELECT LIMIT - CLASS_SIZE INTO v_vacancy FROM CLASSES WHERE CLASSID = v_in_class_id;
		SELECT YEAR INTO v_year FROM CLASSES WHERE CLASSID = v_in_class_id;
		SELECT SEMESTER INTO v_semester FROM CLASSES WHERE CLASSID = v_in_class_id;
	END IF;

	SELECT COUNT(*) INTO v_data_found_overloaded FROM ENROLLMENTS ENR, CLASSES CLS
		WHERE ENR.CLASSID = CLS.CLASSID AND ENR.B# = v_in_b_number AND CLS.YEAR = v_year AND CLS.SEMESTER = v_semester;


	IF (v_data_found_students = 0) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number || ') is invalid.';

	ELSIF (v_data_found_class_id = 0) THEN
		v_out_error_message := 'The Classid: ' || v_in_class_id || ' is invalid.';

	ELSIF (v_vacancy = 0) THEN
		v_out_error_message := 'The Class: ' || v_in_class_id || ' is full.';

	ELSIF (v_data_found_student_in_class > 0) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number ||') is already in the Class: ' || v_in_class_id || '.';

	ELSIF (v_data_found_overloaded > 3) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number ||') cannot be enrolled in more than four classes in the same semester.';

	ELSIF (v_data_found_overloaded = 3) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number ||') is Overloaded.';
		INSERT INTO ENROLLMENTS (B#, CLASSID)
		VALUES (v_in_b_number, v_in_class_id);

	ELSE
		INSERT INTO ENROLLMENTS (B#, CLASSID)
		VALUES (v_in_b_number, v_in_class_id);

	END IF;

	EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;
END;


--SP7
--Store Procedure name: sp_drop_enrollment
--Details: drop enrollment from enrollments table.
PROCEDURE sp_drop_enrollment
(v_in_b_number IN STUDENTS.B#%TYPE,
v_in_class_id IN CLASSES.CLASSID%TYPE,
v_out_error_message OUT VARCHAR2)
IS
	v_b_number STUDENTS.B#%TYPE;
	v_class_id CLASSES.CLASSID%TYPE;
	v_data_found_students NUMBER;
	v_data_found_class_id NUMBER;
	v_class_size CLASSES.CLASS_SIZE%TYPE;
	v_data_found_student_in_class NUMBER;
	v_data_found_student_enroll NUMBER;
	v_year CLASSES.YEAR%TYPE;
	v_semester CLASSES.SEMESTER%TYPE;
	v_data_found_overloaded NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_data_found_students FROM STUDENTS WHERE B# = v_in_b_number;
	SELECT COUNT(*) INTO v_data_found_class_id FROM CLASSES WHERE CLASSID = v_in_class_id;
	SELECT COUNT(*) INTO v_data_found_student_in_class FROM ENROLLMENTS
		WHERE B# = v_in_b_number AND CLASSID = v_in_class_id;
	SELECT COUNT(*) INTO v_data_found_student_enroll FROM ENROLLMENTS
		WHERE B# = v_in_b_number;
	IF (v_data_found_class_id > 0)
	THEN
		SELECT CLASS_SIZE INTO v_class_size FROM CLASSES WHERE CLASSID = v_in_class_id;
		SELECT YEAR INTO v_year FROM CLASSES WHERE CLASSID = v_in_class_id;
		SELECT SEMESTER INTO v_semester FROM CLASSES WHERE CLASSID = v_in_class_id;
	END IF;

	SELECT COUNT(*) INTO v_data_found_overloaded FROM ENROLLMENTS ENR, CLASSES CLS
		WHERE ENR.CLASSID = CLS.CLASSID AND ENR.B# = v_in_b_number AND CLS.YEAR = v_year AND CLS.SEMESTER = v_semester;


	IF (v_data_found_students = 0) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number || ') is invalid.';

	ELSIF (v_data_found_class_id = 0) THEN
		v_out_error_message := 'The Classid: ' || v_in_class_id || ' is invalid.';

	ELSIF (v_data_found_student_in_class = 0) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number ||') is not enrolled in the Class: ' || v_in_class_id || '.';

	ELSIF (v_data_found_student_enroll = 1) THEN
		DELETE FROM ENROLLMENTS WHERE B# = v_in_b_number AND CLASSID = v_in_class_id;
		v_out_error_message := 'The Student (B#: ' || v_in_b_number ||') now is not enrolled in any Classes.';

	ELSIF (v_class_size = 1) THEN
		DELETE FROM ENROLLMENTS WHERE B# = v_in_b_number AND CLASSID = v_in_class_id;
		v_out_error_message := 'The Class: ' || v_in_class_id || ' now has no Students.';

	ELSE
		DELETE FROM ENROLLMENTS WHERE B# = v_in_b_number AND CLASSID = v_in_class_id;

	END IF;

	EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;
END;


--SP8
--Store Procedure name: sp_delete_student
--Details: delete student from students table.
PROCEDURE sp_delete_student
(v_in_b_number IN STUDENTS.B#%TYPE,
v_out_error_message OUT VARCHAR2)
IS
	v_b_number STUDENTS.B#%TYPE;
	v_data_found_students NUMBER;
BEGIN
	SELECT COUNT(*) INTO v_data_found_students FROM STUDENTS WHERE B# = v_in_b_number;

	IF (v_data_found_students = 0) THEN
		v_out_error_message := 'The Student (B#: ' || v_in_b_number || ') is invalid.';
	ELSE
		DELETE STUDENTS WHERE B# = v_in_b_number;
	END IF;

	EXCEPTION
	  	WHEN NO_DATA_FOUND THEN
    			v_out_error_message := 'No data found in table.';
  		WHEN OTHERS THEN
    			v_out_error_message := 'Unexpected error';
    		RAISE;
END;



END;
/
show errors;


--Trigger
--Trigger name: trigger_enroll
--Details: updates data on successful Insert or Delete on Enrollments table.
CREATE OR REPLACE TRIGGER trigger_enroll
AFTER INSERT OR DELETE ON ENROLLMENTS
FOR EACH ROW
DECLARE
	v_class_size CLASSES.CLASS_SIZE%TYPE;
	v_key_value VARCHAR2(256);
BEGIN
	CASE
    		WHEN INSERTING THEN
			v_key_value := :NEW.B# || ',' || :NEW.CLASSID;
			SELECT CLASS_SIZE INTO v_class_size FROM CLASSES WHERE CLASSID = :NEW.CLASSID;
			UPDATE CLASSES SET CLASS_SIZE = v_class_size + 1 WHERE CLASSID = :NEW.CLASSID;
			INSERT INTO LOGS (LOGID, WHO, TIME, TABLE_NAME, OPERATION, KEY_VALUE)
			VALUES (logid_seq.nextval, USER, SYSDATE, 'Enrollments', 'Insert', v_key_value);

    		WHEN DELETING THEN
			v_key_value := :OLD.B# || ',' || :OLD.CLASSID;
			SELECT CLASS_SIZE INTO v_class_size FROM CLASSES WHERE CLASSID = :OLD.CLASSID;
			UPDATE CLASSES SET CLASS_SIZE = v_class_size - 1 WHERE CLASSID = :OLD.CLASSID;
			INSERT INTO LOGS (LOGID, WHO, TIME, TABLE_NAME, OPERATION, KEY_VALUE)
			VALUES (logid_seq.nextval, USER, SYSDATE, 'Enrollments', 'Delete', v_key_value);
  	END CASE;
END;
/
SHOW ERRORS;



--Trigger
--Trigger name: trigger_students
--Details: updates data on successful Insert or Delete on Students table.
CREATE OR REPLACE TRIGGER trigger_students
BEFORE DELETE OR INSERT ON STUDENTS
FOR EACH ROW
BEGIN
	CASE
		WHEN DELETING THEN
		DELETE ENROLLMENTS WHERE B# = :OLD.B#;
		INSERT INTO LOGS (LOGID, WHO, TIME, TABLE_NAME, OPERATION, KEY_VALUE)
		VALUES (logid_seq.nextval, USER, SYSDATE, 'Students', 'Delete', :OLD.B#);

		WHEN INSERTING THEN
		INSERT INTO LOGS (LOGID, WHO, TIME, TABLE_NAME, OPERATION, KEY_VALUE)
		VALUES (logid_seq.nextval, USER, SYSDATE, 'Students', 'Insert', :NEW.B#);
	END CASE;
END;
/
SHOW ERRORS;
