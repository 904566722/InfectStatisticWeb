package InfectStatistic.util;

import java.sql.*;

public class DBConnect {

    static {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = "jdbc:sqlite:test.db";
        return DriverManager.getConnection(url);
    }
}
