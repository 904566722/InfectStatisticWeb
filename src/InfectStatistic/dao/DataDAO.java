package InfectStatistic.dao;

import InfectStatistic.util.DBConnect;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DataDAO {
    public String[] provinceString = {"澳门", "香港", "台湾", "广东", "广西", "海南", "云南", "福建", "江西", "湖南", "贵州",
            "浙江", "安徽", "上海", "江苏", "湖北", "西藏", "青海", "甘肃", "新疆", "陕西", "河南", "山西", "山东",
            "河北", "天津", "北京", "宁夏", "内蒙古", "辽宁", "吉林", "黑龙江", "重庆", "四川"};

    public JSONArray getTotalData(String endDate, String province) {
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
            int eip, esp, tip, tsp, cure, dead;
            eip = esp = tip = tsp = cure = dead = 0;
            try (Connection connection = DBConnect.getConnection()) {
                Statement statement = connection.createStatement();
                String sql = "SELECT * FROM DATA WHERE date = '" + endDate + "'";
                ResultSet resultSet = statement.executeQuery(sql);
                while (resultSet.next()) {
                    for (int i = 0; i < provinceString.length; i++) {
                        if (provinceString[i].equals(resultSet.getString("province"))){
                            eip += resultSet.getInt("eip");
                            esp += resultSet.getInt("esp");
                            tip += resultSet.getInt("tip");
                            tsp += resultSet.getInt("tsp");
                            cure += resultSet.getInt("cure");
                            dead += resultSet.getInt("dead");
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
                jsonObject.put("esp", 0);
                jsonObject.put("tip", patient[i][2]);
                jsonObject.put("tsp", 0);
                jsonObject.put("cure", patient[i][4]);
                jsonObject.put("dead", patient[i][5]);
                jsonArray.add(jsonObject);
            }
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("name", "全国");
            jsonObject.put("eip", eip);
            jsonObject.put("esp", 0);
            jsonObject.put("tip", tip);
            jsonObject.put("tsp", 0);
            jsonObject.put("cure", cure);
            jsonObject.put("dead", dead);
            jsonArray.add(jsonObject);
        } else {
            try (Connection connection = DBConnect.getConnection()) {
                Statement statement = connection.createStatement();
                String sql = "SELECT * FROM DATA WHERE date = '" + endDate + "' AND province = '" + province + "'";
                ResultSet resultSet = statement.executeQuery(sql);
                while (resultSet.next()) {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("name", resultSet.getString("province"));
                    jsonObject.put("eip", resultSet.getInt("eip"));
                    jsonObject.put("esp", 0);
                    jsonObject.put("tip", resultSet.getInt("tip"));
                    jsonObject.put("tsp", 0);
                    jsonObject.put("cure", resultSet.getInt("cure"));
                    jsonObject.put("dead", resultSet.getInt("dead"));
                    jsonArray.add(jsonObject);
                }
            } catch(SQLException e) {
                e.printStackTrace();
            }
        }
        return jsonArray;
    }

    public String jsonArraySort(JSONArray jsonArr, String sortKey) {
        JSONArray sortedJsonArray = new JSONArray();
        List<JSONObject> jsonValues = new ArrayList<JSONObject>();
        for (int i = 0; i < jsonArr.size(); i++) {
            jsonValues.add(JSONObject.fromObject(jsonArr.getJSONObject(i)));
        }
        Collections.sort(jsonValues, new Comparator<JSONObject>() {
            private  final String KEY_NAME = sortKey;
            @Override
            public int compare(JSONObject a, JSONObject b) {
                int valA = 0;
                int valB = 0;
                try {
                    valA = Integer.parseInt(a.getString(KEY_NAME));
                    valB = Integer.parseInt(b.getString(KEY_NAME));
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                if (valA < valB){
                    return 1;
                } else {
                    return -1;
                }
            }
        });
        for (int i = 0; i < jsonArr.size(); i++) {
            sortedJsonArray.add(jsonValues.get(i));
        }
        return sortedJsonArray.toString();
    }

    public JSONArray getDailyData(String endDate, String province) {
        JSONArray jsonArray = new JSONArray();
        if (province.equals("全国")) {
            JSONArray provinceArray = new JSONArray();
            for (int i = 0; i < provinceString.length; i++) {
                provinceArray.add(getProvinceDailyData(endDate, provinceString[i]));
            }
            Map<String, Integer> ipMap = new LinkedHashMap<>();
            Map<String, Integer> spMap = new LinkedHashMap<>();
            Map<String, Integer> cureMap = new LinkedHashMap<>();
            Map<String, Integer> deadMap = new LinkedHashMap<>();
            for (Object object: provinceArray) {
                JSONArray jsonArray1 = (JSONArray) object;
                for (Object o: jsonArray1) {
                    JSONObject jsonObject = (JSONObject) o;
                    String date = (String)jsonObject.get("date");
                    int ip = (int) jsonObject.get("ip");
                    int sp = (int) jsonObject.get("sp");
                    int cure = (int) jsonObject.get("cure");
                    int dead = (int) jsonObject.get("dead");
                    if (ipMap.containsKey(date)) {
                        int oldIp = ipMap.get(date);
                        ipMap.put(date, oldIp + ip);
                        int oldSp = spMap.get(date);
                        spMap.put(date, oldSp + sp);
                        int oldCure = cureMap.get(date);
                        cureMap.put(date, oldCure + cure);
                        int oldDead = deadMap.get(date);
                        deadMap.put(date, oldDead + dead);
                    } else {
                        ipMap.put(date, ip);
                        spMap.put(date, sp);
                        cureMap.put(date, cure);
                        deadMap.put(date, dead);
                    }
                }
            }
            for (String key : ipMap.keySet()) {
                double ip = ipMap.get(key);
                double sp = spMap.get(key);
                double cure = cureMap.get(key);
                double dead = deadMap.get(key);
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("date", key);
                jsonObject.put("ip", ip);
                jsonObject.put("sp", 0);
                jsonObject.put("cure", cure);
                jsonObject.put("dead", dead);
                double tip, tsp, tcure, tdead;
                tip = tsp = tcure = tdead = 0;
                try (Connection connection = DBConnect.getConnection()) {
                    Statement statement = connection.createStatement();
                    String sql = "SELECT * FROM DATA WHERE date = '" + key + "'";
                    ResultSet resultSet = statement.executeQuery(sql);
                    while (resultSet.next()) {
                        tip += resultSet.getInt("tip");
                        tsp += resultSet.getInt("tsp");
                        tcure += resultSet.getInt("cure");
                        tdead += resultSet.getInt("dead");
                    }
                } catch(SQLException e) {
                    e.printStackTrace();
                }
                if (tip != 0 && cure != 0) {
                    jsonObject.put("cureRate", String.format("%.3f", tcure / tip));
                } else {
                    jsonObject.put("cureRate", "0");
                }
                if (tip != 0 && dead != 0) {
                    jsonObject.put("deadRate", String.format("%.3f", tdead / tip));
                } else {
                    jsonObject.put("deadRate", "0");
                }
                jsonArray.add(jsonObject);
            }
        } else {
            jsonArray = getProvinceDailyData(endDate, province);
        }
        return jsonArray;
    }

    public JSONArray getProvinceDailyData(String endDate, String province) {
        JSONArray jsonArray = new JSONArray();
        int oldTip, oldTsp;
        oldTip = oldTsp = 0;
        try (Connection connection = DBConnect.getConnection()) {
            Statement statement = connection.createStatement();
            String sql = "SELECT * FROM DATA WHERE date <= '" + endDate + "' AND province = '" + province + "'";
            ResultSet resultSet = statement.executeQuery(sql);
            int flag = 0;
            while (resultSet.next()) {
                double tip = resultSet.getInt("tip");
                double tsp = resultSet.getInt("tsp");
                double cure = resultSet.getInt("cure");
                double dead = resultSet.getInt("dead");
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("date", resultSet.getString("date"));
                jsonObject.put("ip", (int)tip - oldTip);
                jsonObject.put("sp", 0);
                jsonObject.put("cure", (int)cure);
                jsonObject.put("dead", (int)dead);
                if (tip != 0 && cure != 0) {
                    jsonObject.put("cureRate", String.format("%.3f", cure / tip));
                } else {
                    jsonObject.put("cureRate", "0");
                }
                if (tip != 0 && dead != 0) {
                    jsonObject.put("deadRate", String.format("%.3f", dead / tip));
                } else {
                    jsonObject.put("deadRate", "0");
                }
                oldTip = (int) tip;
                oldTsp = (int) tsp;
                if (flag != 0) {
                    jsonArray.add(jsonObject);
                } else {
                    flag = 1;
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return jsonArray;
    }

    public String getLatestDate() {
        String latestDate = "2020-01-01";
        try (Connection connection = DBConnect.getConnection()) {
            Statement statement = connection.createStatement();
            String sql = "SELECT * FROM DATA WHERE province = '" + "湖北" + "'";
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                if (latestDate.compareTo(resultSet.getString("date")) < 0) {
                    latestDate = resultSet.getString("date");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return latestDate;
    }

    public String getOldestDate() {
        String oldestDate = "2020-12-31";
        try (Connection connection = DBConnect.getConnection()) {
            Statement statement = connection.createStatement();
            String sql = "SELECT * FROM DATA WHERE province = '" + "湖北" + "'";
            ResultSet resultSet = statement.executeQuery(sql);
            while (resultSet.next()) {
                if (oldestDate.compareTo(resultSet.getString("date")) > 0) {
                    oldestDate = resultSet.getString("date");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date todayDate = sdf.parse(oldestDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(todayDate);
            calendar.add(Calendar.DAY_OF_MONTH, 1);
            Date yesterdayDate = calendar.getTime();
            return sdf.format(yesterdayDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return oldestDate;
    }

    public JSONArray getCompareData(String endDate, String province) {
        int eip, esp, tip, tsp, cure, dead;
        eip = esp = tip = tsp = cure = dead = 0;
        String yesterday = getYesterday(endDate);
        JSONArray jsonArray = new JSONArray();
        if (province.equals("全国")) {
            try (Connection connection = DBConnect.getConnection()) {
                Statement statement = connection.createStatement();
                String sql = "SELECT * FROM DATA WHERE date = '" + endDate + "'";
                ResultSet resultSet = statement.executeQuery(sql);
                while (resultSet.next()) {
                    eip += resultSet.getInt("eip");
                    esp += resultSet.getInt("esp");
                    tip += resultSet.getInt("tip");
                    tsp += resultSet.getInt("tsp");
                    cure += resultSet.getInt("cure");
                    dead += resultSet.getInt("dead");
                }
                String sql2 = "SELECT * FROM DATA WHERE date = '" + yesterday + "'";
                ResultSet resultSet2 = statement.executeQuery(sql2);
                while (resultSet2.next()) {
                    eip -= resultSet2.getInt("eip");
                    esp -= resultSet2.getInt("esp");
                    tip -= resultSet2.getInt("tip");
                    tsp -= resultSet2.getInt("tsp");
                    cure -= resultSet2.getInt("cure");
                    dead -= resultSet2.getInt("dead");
                }
            } catch (SQLException e){
                e.printStackTrace();
            }
        } else {
            try (Connection connection = DBConnect.getConnection()) {
                Statement statement = connection.createStatement();
                String sql = "SELECT * FROM DATA WHERE date = '" + endDate + "' AND province = '" + province + "'";
                ResultSet resultSet = statement.executeQuery(sql);
                while (resultSet.next()) {
                    eip += resultSet.getInt("eip");
                    esp += resultSet.getInt("esp");
                    tip += resultSet.getInt("tip");
                    tsp += resultSet.getInt("tsp");
                    cure += resultSet.getInt("cure");
                    dead += resultSet.getInt("dead");
                }
                String sql2 = "SELECT * FROM DATA WHERE date = '" + yesterday + "' AND province = '" + province + "'";
                ResultSet resultSet2 = statement.executeQuery(sql2);
                while (resultSet2.next()) {
                    eip -= resultSet2.getInt("eip");
                    esp -= resultSet2.getInt("esp");
                    tip -= resultSet2.getInt("tip");
                    tsp -= resultSet2.getInt("tsp");
                    cure -= resultSet2.getInt("cure");
                    dead -= resultSet2.getInt("dead");
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("eip", eip);
        jsonObject.put("esp", 0);
        jsonObject.put("tip", tip);
        jsonObject.put("tsp", 0);
        jsonObject.put("cure", cure);
        jsonObject.put("dead", dead);
        jsonArray.add(jsonObject);
        return jsonArray;
    }

    public String getYesterday(String endDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date todayDate = sdf.parse(endDate);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(todayDate);
            calendar.add(Calendar.DAY_OF_MONTH, -1);
            Date yesterdayDate = calendar.getTime();
            return sdf.format(yesterdayDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String changeDateFormat(String endDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date todayDate = sdf.parse(endDate);
            return sdf.format(todayDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return endDate;
    }

    //测试用主函数
    /*public static void main(String[] args) {
        DataDAO dataDAO = new DataDAO();
        System.out.println(dataDAO.getTotalData("2020-03-12", "全国"));
        System.out.println(dataDAO.getDailyData("2020-03-12", "全国"));
        System.out.println(dataDAO.getTotalData("2020-03-12", "湖北"));
        System.out.println(dataDAO.getDailyData("2020-03-12", "湖北"));
        System.out.println("latestDate:" + dataDAO.getLatestDate());
        System.out.println("oldestDate:" + dataDAO.getOldestDate());
        System.out.println("yesterday:" + dataDAO.getYesterday("2020-03-01"));
        System.out.println(dataDAO.getCompareData("2020-03-01", "全国"));
        System.out.println(dataDAO.getCompareData("2020-03-01", "湖北"));
        System.out.println("changeDateFormat:" + dataDAO.changeDateFormat("2020-3-2"));
        System.out.println(dataDAO.jsonArraySort(dataDAO.getTotalData("2020-03-01", "全国"), "eip"));
    }*/

}
