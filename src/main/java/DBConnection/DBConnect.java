package DBConnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/kmeans";
			String user = "root";
			String password = "";
			conn = DriverManager.getConnection(url, user, password);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
	}

	public static void main(String[] args) {
		System.out.println(getConnection());
	}
}