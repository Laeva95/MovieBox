package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DUtil {

	public static Connection getConnection() {

		Connection conn = null;

		try {

			Class.forName("com.mysql.cj.jdbc.Driver");

			conn = DriverManager.getConnection(
					"jdbc:mysql://localhost:3306/moviebox",
					"root",
					"0000"
			);

		} catch (Exception e) {

			e.printStackTrace();

		}

		return conn;
	}
}