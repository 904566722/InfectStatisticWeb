package InfectStatistic.dao;

import InfectStatistic.util.DBConnect;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DataDAO {

    public JSONArray getTotalData(String endDate, String province) {
        String[] provinceString = {"澳门", "香港", "台湾", "广东", "广西", "海南", "云南", "福建", "江西", "湖南", "贵州",
                "浙江", "安徽", "上海", "江苏", "湖北", "西藏", "青海", "甘肃", "新疆", "陕西", "河南", "山西", "山东",
                "河北", "天津", "北京", "宁夏", "内蒙古", "辽宁", "吉林", "黑龙江", "重庆", "四川", "全国"};
        String[] patientType = {"现存确诊", "现存疑似", "累计确诊", "累计疑似", "累计治愈", "累计死亡"};
        int[][] patient;
        patient = new int[provinceString.length][patientType.length];
        for (int i = 0; i < provinceString.length; i++) {
            for (int j = 0; j < patientType.length; j++) {
                patient[i][j] = 0;
            }
        }
        JSONArray jsonArray = new JSONArray();

        if (province.equals("全国")) {
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
        } else {
            try (Connection connection = DBConnect.getConnection()) {
                Statement statement = connection.createStatement();
                String sql = "SELECT * FROM DATA WHERE date <= '" + endDate + "' AND province = '" + province + "'";
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
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
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
            }
        }
        return jsonArray;
    }

    public JSONArray getDailyData(String endDate, String province) {
        double ip = 0;
        double cure = 0;
        double dead = 0;
        JSONArray jsonArray = new JSONArray();
        try (Connection connection = DBConnect.getConnection()) {
            Statement statement = connection.createStatement();
            String sql = "SELECT * FROM DATA WHERE date <= '" + endDate + "' AND province = '" + province + "'";
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                ip += resultSet.getInt("tip");
                cure += resultSet.getInt("cure");
                dead += resultSet.getInt("dead");
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("date", resultSet.getString("date"));
                jsonObject.put("ip", resultSet.getInt("tip"));
                jsonObject.put("sp", resultSet.getInt("tsp"));
                jsonObject.put("cure", cure);
                jsonObject.put("dead", dead);
                if (ip != 0 && cure != 0) {
                    jsonObject.put("cureRate", String.format("%.3f", cure / ip));
                } else {
                    jsonObject.put("cureRate", 0);
                }
                if (ip != 0 && dead != 0) {
                    jsonObject.put("deadRate", String.format("%.3f", dead / ip));
                } else {
                    jsonObject.put("deadRate", 0);
                }
                jsonArray.add(jsonObject);
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return jsonArray;
    }

    /*public static void main(String[] args) {
        DataDAO dataDAO = new DataDAO();
        System.out.println(dataDAO.getTotalData("2020-02-01", "全国"));
        System.out.println(dataDAO.getDailyData("2020-02-01", "全国"));
        JSONArray jsonArray = dataDAO.getDailyData("2020-02-01", "福建");
        JSONArray dateArray = new JSONArray();
        for (Object object: jsonArray) {
            JSONObject jsonObject = (JSONObject) object;
            dateArray.add(jsonObject.get("date"));
        }
        System.out.println(dateArray);
    }*/
}
