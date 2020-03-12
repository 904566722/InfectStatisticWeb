package InfectStatistic.dao;

import InfectStatistic.util.DBConnect;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DataDAO {

    public JSONArray getTotalData(String endDate) {
        String[] provinceString = {"安徽", "北京", "重庆", "福建", "甘肃", "广东", "广西", "贵州", "海南",
                "河北", "河南", "黑龙江", "湖北", "湖南", "吉林", "江苏", "江西", "辽宁", "内蒙古", "宁夏", "青海", "山东",
                "山西", "陕西", "上海", "四川", "天津", "西藏", "新疆", "云南", "浙江", "台湾", "香港", "澳门"};
        String[] patientType = {"现存确诊", "现存疑似", "累计确诊", "累计疑似", "累计治愈", "累计死亡"};
        int[][] patient;
        patient = new int[provinceString.length][patientType.length];
        for (int i = 0; i < provinceString.length; i++) {
            for (int j = 0; j < patientType.length; j++) {
                patient[i][j] = 0;
            }
        }

        try (Connection connection = DBConnect.getConnection()) {
            Statement statement = connection.createStatement();
            String sql = "SELECT * FROM DATA WHERE date <= '" + endDate + "'";
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                for (int i = 0; i < provinceString.length; i++) {
                    if (provinceString[i].equals(resultSet.getString("province"))) {
                        patient[i][0] += resultSet.getInt("eip");
                        patient[i][1] += resultSet.getInt("esp");
                        patient[i][2] += resultSet.getInt("tip");
                        patient[i][3] += resultSet.getInt("tsp");
                        patient[i][4] += resultSet.getInt("cure");
                        patient[i][5] += resultSet.getInt("dead");
                    }
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }

        JSONArray jsonArray = new JSONArray();
        for (int i = 0; i < provinceString.length; i++) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name", provinceString[i]);
            jsonObject.put("eip", patient[i][0]);
            jsonObject.put("esp", patient[i][1]);
            jsonObject.put("tip", patient[i][2]);
            jsonObject.put("tsp", patient[i][3]);
            jsonObject.put("cure", patient[i][4]);
            jsonObject.put("dead", patient[i][5]);
            jsonArray.add(jsonObject);
        }
        return jsonArray;
    }

    /*public static void main(String[] args) {
        DataDAO dataDAO = new DataDAO();
        System.out.println(dataDAO.getTotalData("2020-02-01"));
    }*/
}
