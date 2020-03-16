package InfectStatistic.util;

import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CountData {
    private String[] provinceString = {"全国", "安徽", "北京", "重庆", "福建", "甘肃", "广东", "广西", "贵州", "海南",
        "河北", "河南", "黑龙江", "湖北", "湖南", "吉林", "江苏", "江西", "辽宁", "内蒙古", "宁夏", "青海", "山东",
        "山西", "陕西", "上海", "四川", "天津", "西藏", "新疆", "云南", "浙江", "台湾", "香港", "澳门"};
    private String[] patientType = {"现存确诊", "现存疑似", "累计确诊", "累计疑似", "累计治愈", "累计死亡"};

    public static void main(String[] args) {
        CountData countData = new CountData();
        String[] logDateString = {"2020-01-19", "2020-01-20", "2020-01-21", "2020-01-22", "2020-01-23", "2020-01-24",
            "2020-01-25", "2020-01-26", "2020-01-27", "2020-01-28", "2020-01-29", "2020-01-30", "2020-01-31",
            "2020-02-01", "2020-02-02"};
        for (String s : logDateString) {
            DataHandle dataHandle = countData.new DataHandle();
            dataHandle.dataProcess(countData.readLog(s, "D:\\log\\"));
            dataHandle.insertData(s);
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

        private int[][] patient;
        private int[] influencedProvince;

        public DataHandle() {
            patient = new int[provinceString.length][patientType.length];
            for (int i = 0; i < provinceString.length; i++) {
                for (int j = 0; j < patientType.length; j++) {
                    patient[i][j] = 0;
                }
            }
            influencedProvince = new int[provinceString.length];
            for (int k = 0; k <influencedProvince.length; k++) {
                influencedProvince[k] = 0;
            }
        }

        public void dataProcess(ArrayList<String> stringList) {
            String pattern1 = "\\W+ 新增 感染患者 \\d+人";
            String pattern2 = "\\W+ 新增 疑似患者 \\d+人";
            String pattern3 = "\\W+ 感染患者 流入 \\W+ \\d+人";
            String pattern4 = "\\W+ 疑似患者 流入 \\W+ \\d+人";
            String pattern5 = "\\W+ 死亡 \\d+人";
            String pattern6 = "\\W+ 治愈 \\d+人";
            String pattern7 = "\\W+ 疑似患者 确诊感染 \\d+人";
            String pattern8 = "\\W+ 排除 疑似患者 \\d+人";
            for (String str : stringList) {
                if (Pattern.matches(pattern1, str)) {
                    ipAdd(str);
                } else if (Pattern.matches(pattern2, str)) {
                    spAdd(str);
                } else if (Pattern.matches(pattern3, str)) {
                    ipFlow(str);
                } else if (Pattern.matches(pattern4, str)) {
                    spFlow(str);
                } else if (Pattern.matches(pattern5, str)) {
                    deadAdd(str);
                } else if (Pattern.matches(pattern6, str)) {
                    cureAdd(str);
                } else if (Pattern.matches(pattern7, str)) {
                    spToIp(str);
                } else if (Pattern.matches(pattern8, str)) {
                    spSub(str);
                }
            }
        }

        public void ipAdd(String str) {
            String pattern = "(\\W+) 新增 感染患者 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int ip = 0;
            if (m.find( )) {
                province = m.group(1);
                ip = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][0] += ip;
                    patient[i][2] += ip;
                    patient[0][0] += ip;
                    patient[0][2] += ip;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void spAdd(String str) {
            String pattern = "(\\W+) 新增 疑似患者 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int sp = 0;
            if (m.find( )) {
                province = m.group(1);
                sp = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][1] += sp;
                    patient[i][3] += sp;
                    patient[0][1] += sp;
                    patient[0][3] += sp;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void ipFlow(String str) {
            String pattern = "(\\W+) 感染患者 流入 (\\W+) (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province1 = "";
            String province2 = "";
            int ip = 0;
            if (m.find( )) {
                province1 = m.group(1);
                province2 = m.group(2);
                ip = Integer.parseInt(m.group(3));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province1)) {
                    patient[i][0] -= ip;
                    influencedProvince[i] = 1;
                }
                else if (provinceString[i].equals(province2)) {
                    patient[i][0] += ip;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void spFlow(String str) {
            String pattern = "(\\W+) 疑似患者 流入 (\\W+) (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province1 = "";
            String province2 = "";
            int sp = 0;
            if (m.find( )) {
                province1 = m.group(1);
                province2 = m.group(2);
                sp = Integer.parseInt(m.group(3));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province1)) {
                    patient[i][1] -= sp;
                    influencedProvince[i] = 1;
                }
                else if (provinceString[i].equals(province2)) {
                    patient[i][1] += sp;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void deadAdd(String str) {
            String pattern = "(\\W+) 死亡 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int dead = 0;
            if (m.find( )) {
                province = m.group(1);
                dead = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][5] += dead;
                    patient[0][5] += dead;
                    patient[i][0] -= dead;
                    patient[0][0] -= dead;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void cureAdd(String str) {
            String pattern = "(\\W+) 治愈 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int cure = 0;
            if (m.find( )) {
                province = m.group(1);
                cure = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][4] += cure;
                    patient[0][4] += cure;
                    patient[i][0] -= cure;
                    patient[0][0] -= cure;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void spToIp(String str) {
            String pattern = "(\\W+) 疑似患者 确诊感染 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int ip = 0;
            if (m.find( )) {
                province = m.group(1);
                ip = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][0] += ip;
                    patient[0][0] += ip;
                    patient[i][1] -= ip;
                    patient[0][1] -= ip;
                    patient[i][2] += ip;
                    patient[0][2] += ip;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void spSub(String str) {
            String pattern = "(\\W+) 排除 疑似患者 (\\d+)人";
            Pattern r = Pattern.compile(pattern);
            Matcher m = r.matcher(str);
            String province = "";
            int sp = 0;
            if (m.find( )) {
                province = m.group(1);
                sp = Integer.parseInt(m.group(2));
            } else {
                System.out.println("NO MATCH");
            }
            for (int i = 0; i < provinceString.length; i++) {
                if (provinceString[i].equals(province)) {
                    patient[i][1] -= sp;
                    patient[0][1] -= sp;
                    influencedProvince[i] = 1;
                }
            }
        }

        public void insertData(String logDate) {
            try (Connection connection = DBConnect.getConnection()) {
                connection.setAutoCommit(false);
                Statement statement = connection.createStatement();
                for (int i = 0; i < influencedProvince.length; i++) {
                    statement.executeUpdate("INSERT INTO data VALUES(null, '" + logDate + "', '" + provinceString[i]
                        + "', " + patient[i][0] + ", " + patient[i][1] + ", "+ patient[i][2] + ", "+ patient[i][3]
                        + ", "+ patient[i][4] + ", "+ patient[i][5] + ")");
                }
                connection.commit();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
