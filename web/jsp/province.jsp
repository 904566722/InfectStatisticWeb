<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %><%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2020/3/11
  Time: 22:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    Object totalData = request.getAttribute("totalData");
    Object dailyData = request.getAttribute("dailyData");
    Object province = request.getAttribute("province");

    //折线图绘制需要用到的数据 - x轴(日期)
    JSONArray lineChartData = (JSONArray) request.getAttribute("dailyData");
    JSONArray dateArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        dateArray.add(jsonObject.get("date"));
    }

    //折线图1用：ip 新增确诊  sp 新增疑似
    JSONArray ipArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        ipArray.add(jsonObject.get("ip"));
    }

    JSONArray spArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        spArray.add(jsonObject.get("sp"));
    }

    //折线图2用： cure 累计治愈 dead 累计死者
    JSONArray cureArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        cureArray.add(jsonObject.get("cure"));
    }

    JSONArray deadArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        deadArray.add(jsonObject.get("dead"));
    }

%>
<html>
<head>
    <title>省份详细数据</title>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/province.css">
    <script type="text/javascript" src="<%=path%>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=path%>/js/test.js"></script>
    <script type="text/javascript" src="<%=path%>/js/province.js"></script>

    <script type="text/javascript">
        console.log(<%=totalData%>);
        console.log(<%=dailyData%>);
        <%--console.log(<%=province%>);--%>
        $(document).ready(function(){
            drawChart1(<%=dateArray%>, <%=ipArray%>, <%=spArray%>);
            drawChart2(<%=dateArray%>, <%=cureArray%>, <%=deadArray%>);

        });

    </script>
</head>
<body>
    <div id="main">
        <div id="mid">
            <div id="provinceNameAndReturn">
                <div id="provinceName">
                    <span style="color: white;font-weight:bold">省名</span>
                </div>
                <div id="returnButton">
                    <a href= "../index.jsp">首页</a>
                </div>
            </div>
            <div id="ps1">
                <span>更新至2020.02.24 23：28</span>
            </div>
            <div id="fourData">
                <div class="ip">
                    <span>感染患者</span><br>
                    <strong style="color: #F74C31;font-size: 26px;">53</strong><br>
                    <div class="compareToday">
                        <span style="font-size: 8px">较昨日：</span>
                        <span style="font-size: 8px;color: #F74C31">-2</span>
                    </div>
                </div>
                <div class="sp">
                    <span>现存疑似</span><br>
                    <strong style="color: #F78207;font-size: 26px;">3434</strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #F78207">+0</span>
                    </div>
                </div>
                <div class="cure">
                    <span>累计治愈</span><br>
                    <strong style="color: #28B7A3;font-size: 26px;">49666</strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #28B7A3">+2</span>
                    </div>
                </div>
                <div class="dead">
                    <span>累计死亡</span><br>
                    <strong style="color: #5D7092;font-size: 26px;">49666</strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #5D7092">+0</span>
                    </div>
                </div>
            </div>
            <div id="chart1"></div>
            <div id="chart2"></div>

        </div>
    </div>

</body>
</html>
