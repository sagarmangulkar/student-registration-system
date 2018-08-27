import java.sql.*;
import java.util.*;

import oracle.jdbc.*;

public class MainClass {
		String b_num = null;
		String dept_code = null;
		int course_num = 0;
		String classid = null;
		DBConnection db = new DBConnection();
		Connection conn = db.getConnection();
		CallableStatement stmt = null;
		Scanner sc = new Scanner(System.in);
		private void mainMenu() throws SQLException{
			int n = 0;
			System.out.println("\n\nSTUDENT REGISTRATION SYSTEM");
			System.out.println(" 1. Display data of a table. \n 2. Display classes taken by a student. \n 3. Find courses that need a given course as prerequisite. \n 4. Display information for a particular class(classid, course title and students). \n 5. Enroll a student into a class. \n 6. Drop a student from a class. \n 7. Delete a student from database. \n 8. Exit.");
			System.out.println("Please select an option from the above : ");
			
			n = sc.nextInt();
			
			switch(n){
			case 1:
				subMenu();
				break;
			case 2:
				display_classes();
				break;
			case 3:
				find_prereq_courses();
				break;
			case 4:
				get_class_info();
				break;
			case 5:
				enroll_student();
				break;
			case 6:
				drop_student();
				break;
			case 7:
				delete_student();
				break;
			case 8:
				System.out.println("Thank you for using STUDENT REGISTRATION SYSTEM.");
				if(conn != null)
			    conn.close();
				System.exit(0);
				break;
			default:
				System.out.println("Please enter a valid option.");
				mainMenu();
				break;
			}
		
		}
		
		private void delete_student() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter the B# of the student :");
			b_num = sc.next();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_delete_student(?, ?); END;");
			stmt.setString(1, b_num);
			stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
		    stmt.execute();
		    
		      String err_msg = ((OracleCallableStatement)stmt).getString(2);
		      if(err_msg == null){
		    	  System.out.println("\nStudent deleted successfully.");
		      }
		      else{
		    	  System.out.println(err_msg);  
		      }
		      stmt.close();
		      nextOption();
		}

		private void drop_student() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter the B# of the student :");
			b_num = sc.next();
			System.out.println("Enter the classid :");
			classid = sc.next();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_drop_enrollment(?, ?, ?); END;");
			stmt.setString(1, b_num);
			stmt.setString(2, classid);
			stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
		    stmt.execute();
		      
		      String err_msg = ((OracleCallableStatement)stmt).getString(3);
		      if(err_msg == null){
		    	  System.out.println("\nStudent dropped from the course successfully.");
		      }
		      else{
		    	  System.out.println(err_msg);  
		      }
		      
		      stmt.close();
		      nextOption();
		}

		private void enroll_student() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter the B# of the student :");
			b_num = sc.next();
			System.out.println("Enter the classid :");
			classid = sc.next();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_enroll(?, ?, ?); END;");
			stmt.setString(1, b_num);
			stmt.setString(2, classid);
			stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
		    stmt.execute();
		    
		      String err_msg = ((OracleCallableStatement)stmt).getString(3);
		      if(err_msg == null){
		    	  System.out.println("\nStudent enrolled into course successfully.");
		      }
		      else{
		    	  System.out.println(err_msg);  
		      }
		      
		      stmt.close();
		      nextOption();
		}

		private void get_class_info() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter a class id :");
			classid = sc.next();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_get_class_students(?, ?, ?); END;");
		      stmt.setString(1, classid); // classid
		      stmt.registerOutParameter(2, OracleTypes.CURSOR); //REF CURSOR
		      stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
		      stmt.execute();
		      ResultSet rs = null;
		      try{
		        rs = ((OracleCallableStatement)stmt).getCursor(2);
		      }
		      catch(Exception ex){
		        String err_msg = ((OracleCallableStatement)stmt).getString(3);
		        System.out.println(err_msg);
		      }
		      
		      if(rs != null){
		    	  System.out.println("\n\nCLASSID"+ "\t\t" + "TITLE" + "\t\t\t" +"B#" + "\t\t" +"FIRSTNAME");
		    	  System.out.println("---------------------------------------------------------------------------------");
		        while (rs.next()) {
		          System.out.println(rs.getString("classid") + "\t\t" + rs.getString("title") + "\t\t" + rs.getString("B#") + "\t\t" + rs.getString("firstname")); 
		        }  
		      }
		      else
		      {
		        System.out.println("No rows returned.");
		      }
		      
		      if(rs != null)
		      rs.close();
		      stmt.close();
		      nextOption();
		}

		private void find_prereq_courses() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter a Department Code (Example - CS): ");
			dept_code = sc.next();
			System.out.println("Enter a Course Number (Example - 232): ");
			course_num = sc.nextInt();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_find_prerequisites(?, ?, ?, ?); END;");
			stmt.setString(1, dept_code); // dept_code
		      stmt.setInt(2, course_num); //course#
		      stmt.registerOutParameter(3, OracleTypes.CURSOR); //REF CURSOR
		      stmt.registerOutParameter(4, java.sql.Types.VARCHAR);
		      stmt.execute();
		      ResultSet rs = null;
		      try{
		        rs = ((OracleCallableStatement)stmt).getCursor(3);
		      }
		      catch(Exception ex){
		        String err_msg = ((OracleCallableStatement)stmt).getString(4);
		        System.out.println(err_msg);
		      }
		      
		      if(rs != null){
		    	  System.out.println("\n\nCOURSE");
		        while (rs.next()) {
		          System.out.println(rs.getString("courses_p"));        }  
		      }
		      else
		      {
		        System.out.println("No rows returned.");
		      }
		      
		      if(rs != null)
		      rs.close();
		      
		      stmt.close();
		      nextOption();
		}
		private void display_classes() throws SQLException {
			// TODO Auto-generated method stub
			System.out.println("Enter a B#:");
			b_num = sc.next();
			
			stmt = conn.prepareCall("BEGIN student_registration_system.sp_classes_taken_by_student(?, ?, ?); END;");
		      stmt.setString(1, b_num); // B#
		      stmt.registerOutParameter(2, OracleTypes.CURSOR); //REF CURSOR
		      stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
		      stmt.execute();
		      ResultSet rs = null;
		      try{
		        rs = ((OracleCallableStatement)stmt).getCursor(2);
		      }
		      catch(Exception ex){
		        String err_msg = ((OracleCallableStatement)stmt).getString(3);
		        System.out.println(err_msg);
		      }
		      
		      if(rs != null){
		    	  System.out.println("\n\nCLASSID" + "\t\t" + "DEPT_CODE" + "\t" + "COURSE#" + "\t\t" + "SECT#" + "\t\t" + "YEAR" + "\t\t" + "SEMESTER" + "\t" + "LGRADE" + "\t\t" + "NGRADE");
		    	  System.out.println("-----------------------------------------------------------------");
		        while (rs.next()) {
		          System.out.println(rs.getString("classid") + "\t\t" + rs.getString("dept_code") + "\t\t" + rs.getString("course#") + "\t\t" + rs.getString("sect#") + "\t\t" + rs.getString("year") + "\t\t" + rs.getString("semester") + "\t\t" + rs.getString("lgrade") + "\t\t" + rs.getString("ngrade")); 
		        }  
		      }
		      else
		      {
		        System.out.println("No rows returned.");
		      }
		      
		      if(rs != null)
		      rs.close();
		      stmt.close();
		      nextOption();
		}
		
		private void subMenu() throws SQLException {
			// TODO Auto-generated method stub
			int n = 0;
			Scanner sc = new Scanner(System.in);
			System.out.println(" \n 1. Students. \n 2. Courses. \n 3. Course_credit. \n 4. Classes. \n 5. Enrollments. \n 6. Grades \n 7. Prerequisites \n 8. Logs.\n 9. Go to main menu.\n 10. Exit.");
			System.out.println("Please select a table from the above : ");
			
			n = sc.nextInt();
			if(n >=1 && n<=8){
				display_data(n);
			}else if(n == 9){
				mainMenu();
			}
			else if(n == 10){
				System.out.println("Thank you for using STUDENT REGISTRATION SYSTEM.");
				if(conn != null)
			    conn.close();
				System.exit(0);
			}
			else{
				System.out.println("Please enter a valid choice.");
				subMenu();
			}
			
		}
		
		private void nextOption() throws SQLException{
			System.out.println("\n\n1. Go to the main menu.\n2. Exit.\n\n Please select an option from above:");
			int x = sc.nextInt();
			switch(x){
				case 1:
					mainMenu();
					break;
				case 2:
					System.out.println("Thank you for using STUDENT REGISTRATION SYSTEM.");
					if(conn != null)
				    conn.close();
					System.exit(0);
					break;
				default:
					System.out.println("Please enter a valid choice.");
					nextOption();
					break;
			}
		}
		
		private void nextOptionsubMenu() throws SQLException{
			System.out.println("\n\n1. Go to previous menu.\n2. Go to main menu press. \n3. Exit. \n\n Please select an option from above:");
			int x = sc.nextInt();
			switch(x){
				case 1:
					subMenu();
					break;
				case 2:
					mainMenu();
					break;
				case 3:
					System.out.println("Thank you for using STUDENT REGISTRATION SYSTEM.");
					if(conn != null)
				    conn.close();
					System.exit(0);
					break;
				default:
					System.out.println("Please enter a valid choice.");
					nextOption();
					break;
			}
		}
		private void display_data(int i) throws SQLException {
			
			if(i == 1){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_students(?, ?); END;");
			}
			if(i == 2){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_courses(?, ?); END;");
			}
			if(i == 3){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_course_credit(?, ?); END;");
			}
			if(i == 4){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_classes(?, ?); END;");
			}
			if(i == 5){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_enrollments(?, ?); END;");
			}
			if(i == 6){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_grades(?, ?); END;");
			}
			if(i == 7){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_prerequisites(?, ?); END;");
			}
			if(i == 8){
				stmt = conn.prepareCall("BEGIN student_registration_system.sp_show_logs(?, ?); END;");
			}
			
			stmt.registerOutParameter(1, OracleTypes.CURSOR); //REF CURSOR
		    stmt.registerOutParameter(2, java.sql.Types.VARCHAR);
		    stmt.execute();
		    ResultSet rs = null;
		    try{
		      rs = ((OracleCallableStatement)stmt).getCursor(1);
		    }
		    catch(Exception ex){
		      String err_msg = ((OracleCallableStatement)stmt).getString(2);
		      System.out.println(err_msg);
		    }
		      
		    if(rs != null){
		    	if(i == 1){
	    		  	System.out.println("\n\nB#" + "\t\t" + "FIRSTNAME" + "\t" + "LASTNAME" + "\t" + "STATUS" + "\t\t" + "GPA" + "\t\t" + "EMAIL" + "\t\t\t" + "BDATE" + "\t\t\t" + "DEPTNAME");
	    		  	System.out.println("-----------------------------------------------------------------------------------------------------------------------------------------");
				}
				if(i == 2){
					System.out.println("\n\nDEPT_CODE" + "\t" + "COURSE#" + "\t\t" + "TITLE");
					System.out.println("-----------------------------------------------------");
				}
				if(i == 3){
					System.out.println("\n\nCOURSE#" + "\t\t" + "CREDITS");
					System.out.println("-----------------------------");
				}
				if(i == 4){
			          System.out.println("\n\nCLASSID" + "\t\t" + "DEPT_CODE" + "\t" + "COURSE#" + "\t\t" + "SECT#" + "\t\t" + "YEAR" + "\t\t" + "SEMESTER" + "\t" + "LIMIT" + "\t\t" + "CLASS_SIZE");
			          System.out.println("----------------------------------------------------------------------------------------------------------------------------");
				}
				if(i == 5){
			          System.out.println("\n\nB#" + "\t\t" + "CLASSID" + "\t\t" + "LGRADE");
			          System.out.println("------------------------------------------");
				}
				if(i == 6){
			          System.out.println("\n\nLGRADE" + "\t\t" + "NGRADE"); 
			          System.out.println("---------------------------");
				}
				if(i == 7){
			          System.out.println("\n\nDEPT_CODE" + "\t" + "COURSE#" + "\t\t" + "PRE_DEPT_CODE" + "\t" + "PRE_COURSE#");
			          System.out.println("------------------------------------------------------------");
				}
				if(i == 8){
			          System.out.println("\n\nLOGID" + "\t\t" + "WHO" + "\t\t\t" + "TIME" + "\t\t\t\t" + "TABLE_NAME" + "\t\t" + "OPERATION" + "\t" + "KEY_VALUE");
			          System.out.println("------------------------------------------------------------------------------------------------------------------------------");
				}
		      while (rs.next()) {
		    	  if(i == 1){
		    		  	System.out.println(rs.getString("B#") + "\t\t" + rs.getString("firstname") + "\t\t" + rs.getString("lastname") + "\t\t" + rs.getString("status") + "\t\t" + (rs.getString("gpa")==null ? "": rs.getString("gpa")) + "\t\t" + rs.getString("email") + "\t\t" + rs.getString("bdate").substring(0, 11) + "\t\t" + rs.getString("deptname"));
					}
					if(i == 2){
						System.out.println(rs.getString("dept_code") + "\t\t" + rs.getString("course#") + "\t\t" + rs.getString("title"));
					}
					if(i == 3){
						System.out.println(rs.getString("course#") + "\t\t" + rs.getString("credits"));
					}
					if(i == 4){
				          System.out.println(rs.getString("classid") + "\t\t" + rs.getString("dept_code") + "\t\t" + rs.getString("course#") + "\t\t" + rs.getString("sect#") + "\t\t" + rs.getString("year") + "\t\t" + rs.getString("semester") + "\t\t" + rs.getString("limit") + "\t\t" + rs.getString("class_size"));
					}
					if(i == 5){
				          System.out.println(rs.getString("B#") + "\t\t" + rs.getString("classid") + "\t\t" + rs.getString("lgrade"));
					}
					if(i == 6){
				          System.out.println(rs.getString("lgrade") + "\t\t" + rs.getString("ngrade")); 
					}
					if(i == 7){
				          System.out.println(rs.getString("dept_code") + "\t\t" + rs.getString("course#") + "\t\t" + rs.getString("pre_dept_code") + "\t\t" + rs.getString("pre_course#"));
					}
					if(i == 8){
				          System.out.println(rs.getString("logid") + "\t\t" + rs.getString("who") + "\t\t" + rs.getString("time") + "\t\t" + rs.getString("table_name") + "\t\t" + rs.getString("operation") + "\t\t" + rs.getString("key_value"));
					}  
		         
		      }  
		    }
		    else
		    {
		      System.out.println("No rows returned.");
		    }
		      
		    if(rs != null)
		    	rs.close();
		    else{
		    	System.out.println("No tuples in the table");
		    }
		    stmt.close();
		    nextOptionsubMenu();
	}
						
		
	public static void main(String args[]) throws SQLException{
		MainClass mc = new MainClass();
		mc.mainMenu();
		
		
	}
}
