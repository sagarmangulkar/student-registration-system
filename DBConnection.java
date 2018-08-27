import java.sql.*;

import oracle.jdbc.pool.OracleDataSource;

public class DBConnection {
	public Connection getConnection() {
		try{
		OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
	    ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
	    Connection conn = ds.getConnection("user-name", "Password");
	    return conn;
		}
		catch(Exception ex){
			return null;
		}
	}
	
public static void main(String args[]){
}
}
