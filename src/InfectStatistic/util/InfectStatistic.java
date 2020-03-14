package InfectStatistic.util;

import java.io.*;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class InfectStatistic {
    private String[] provinceString = {"澳门", "香港", "台湾", "广东省", "广西壮族自治区", "海南省", "云南省", "福建省", "江西省", "湖南省",
            "贵州省", "浙江省", "安徽省", "上海市", "江苏省", "湖北省", "西藏省", "青海省", "甘肃省", "新疆省", "陕西省", "河南省", "山西省",
            "山东省", "河北省", "天津市", "北京市", "宁夏回族自治区", "内蒙古自治区", "辽宁省", "吉林省", "黑龙江省", "重庆市", "四川省"};

    public static void main(String[] args) {
        InfectStatistic infectStatistic = new InfectStatistic();
        //logDataString为{“前一天”，“导入的当天”}格式，例如要导入3月15日的数据，应当写成如下形式：
        String[] logDateString = {"2020-03-14", "2020-03-15"};
        for (int i = 1; i < logDateString.length; i++) {
            InfectStatistic.DataHandle dataHandle = infectStatistic.new DataHandle();
            dataHandle.dataProcess(infectStatistic.readLog(logDateString[i], "D:\\all_data\\"), logDateString[i]);
            dataHandle.addOtherData(logDateString[i], logDateString[i-1]);
        }
    }

    public ArrayList readLog(String logDate, String logPath) {
        ArrayList<String> stringList = new ArrayList<>();
        try {
            File file = new File(logPath);
            File[] fileList = file.listFiles();
            assert fileList != null;
            String fileName;
            String fileNameWithout;
            for (File value : fileList) {
                fileName = value.getName();
                fileNameWithout = fileName.substring(0, 10);
                if (logDate.equals(fileNameWithout)) {
                    BufferedReader bf = new BufferedReader(new InputStreamReader(new FileInputStream(
                            new File(logPath + fileName)), "GBK"));
                    String str;
                    while ((str = bf.readLine()) != null) {
                        if (!str.startsWith("//")) {
                            stringList.add(str);
                        }
                    }
                    bf.close();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return stringList;
    }

    class DataHandle {
        private int[] influencedProvince;

        public DataHandle() {
            influencedProvince = new int[provinceString.length];
            for (int k = 0; k < influencedProvince.length; k++) {
                influencedProvince[k] = 0;
            }
        }

        public void dataProcess(ArrayList<String> stringList, String logDate) {
            String pattern = "\\W+ \\W+ \\d+ \\d+ \\d+ \\d+ \\d+ \\d+ \\d+ \\d+";
            for (String str : stringList) {
                if (Pattern.matches(pattern, str)) {
                    addToDatabase(str, logDate);
                }
            }
        }

        public void addToDatabase(String str, String logDate) {
            String pattern = "(\\W+) (\\W+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+) (\\d+)";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int eip, esp, tip, tsp, cure, dead;
            eip = esp = tip = tsp = cure = dead = 0;
            if (m.find()) {
                province = m.group(1);
                tip = Integer.parseInt(m.group(3));
                tsp = Integer.parseInt(m.group(4));
                cure = Integer.parseInt(m.group(5));
                dead = Integer.parseInt(m.group(6));
                eip = tip - cure - dead;
                esp = tsp;
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    if (influencedProvince[i] == 0) {
                        influencedProvince[i] = 1;
                        String abbr = abbreviateProvince(province);
                        try (Connection connection = DBConnect.getConnection()) {
                            connection.setAutoCommit(false);
                            Statement statement = connection.createStatement();
                            statement.executeUpdate("INSERT INTO data VALUES(null, '" + logDate + "', '" + abbr
                                + "', " + eip + ", " + esp + ", " + tip + ", " + tsp + ", " + cure + ", " + dead + ")");
                            connection.commit();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }

        public void addOtherData(String logDate, String oldDate) {
            for (int i = 0; i < influencedProvince.length; i++) {
                if (influencedProvince[i] == 0) {
                    String abbr = abbreviateProvince(provinceString[i]);
                    int eip, esp, tip, tsp, cure, dead;
                    eip = esp = tip = tsp = cure = dead = 0;
                    try (Connection connection = DBConnect.getConnection()) {
                        connection.setAutoCommit(false);
                        if (oldDate.equals("")) {
                        } else {
                            Statement queryStatement = connection.createStatement();
                            ResultSet resultSet = queryStatement.executeQuery("SELECT * FROM DATA WHERE date = '" + oldDate +
                                    "' AND province = '" + abbr + "'");
                            while (resultSet.next()) {
                                eip = resultSet.getInt("eip");
                                esp = resultSet.getInt("esp");
                                tip = resultSet.getInt("tip");
                                tsp = resultSet.getInt("tsp");
                                cure = resultSet.getInt("cure");
                                dead = resultSet.getInt("dead");
                            }
                        }
                        Statement statement = connection.createStatement();
                        statement.executeUpdate("INSERT INTO data VALUES(null, '" + logDate + "', '" + abbr
                                + "', " + eip + ", " + esp + ", " + tip + ", " + tsp + ", " + cure + ", " + dead + ")");
                        connection.commit();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        public String abbreviateProvince(String province) {
            String abbreviation = "";
            String length1 = "澳门";
            String length2 = "湖北省";
            String length3 = "广西壮族自治区";
            if (province.length() == length1.length()) {
                abbreviation = province;
            } else if (province.length() == length2.length()) {
                abbreviation = province.substring(0, length1.length());
            } else if (province.equals("黑龙江省")) {
                abbreviation = "黑龙江";
            } else if (province.equals("内蒙古自治区")) {
                abbreviation = "内蒙古";
            } else if (province.length() == length3.length()) {
                abbreviation = province.substring(0, length1.length());
            }
            return abbreviation;
        }

    }

}
