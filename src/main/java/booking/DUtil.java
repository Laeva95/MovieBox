package booking;

import java.sql.Connection;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class DUtil {

    public static Connection getConnection() {

        Connection conn = null;

        try {

            Context initContext = new InitialContext();

            DataSource dataSource =
                    (DataSource) initContext.lookup(
                            "java:comp/env/jdbc/moviebox"
                    );

            conn = dataSource.getConnection();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return conn;
    }
}

