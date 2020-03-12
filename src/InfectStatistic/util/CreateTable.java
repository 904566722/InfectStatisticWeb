package InfectStatistic.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class CreateTable {
    public static void main(String[] args) {
        try (Connection connection = DBConnect.getConnection()) {
            connection.setAutoCommit(false);
            Statement statement = connection.createStatement();
            statement.executeUpdate("create table data(id integer primary key autoincrement, date date, " +
                    "province varchar(20), ip integer, sp integer, cure integer, dead integer);");
            connection.commit();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
