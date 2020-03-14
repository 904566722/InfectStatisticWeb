<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2020/3/11
  Time: 22:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    Object totalData = request.getAttribute("totalData");
    Object dailyData = request.getAttribute("dailyData");
    //与昨日比较的数据
    Object compareData = request.getAttribute("compareData");
    JSONArray compareJson = (JSONArray)compareData;
    JSONObject compare = (JSONObject) compareJson.get(0);

    //获得省份名称
    String provinceName = (String)request.getAttribute("province");
    JSONArray toatlDataJson = (JSONArray)totalData;
    JSONObject province = (JSONObject) toatlDataJson.get(0);

    int eip = province.getInt("eip");
    int esp = province.getInt("esp");
    int cure = province.getInt("cure");
    int dead = province.getInt("dead");

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
    JSONArray cureRateArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        cureRateArray.add(jsonObject.get("cureRate"));
    }

    JSONArray deadRateArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        deadRateArray.add(jsonObject.get("deadRate"));
    }

    //获得日期
    String endDate = (String)request.getAttribute("endDate");
%>
<html>
<head>
    <title>省份详细数据</title>
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/province.css">
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/dateSelect.css">
    <script type="text/javascript" src="<%=path%>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=path%>/js/test.js"></script>
    <script type="text/javascript" src="<%=path%>/js/province.js"></script>
    <script type="text/javascript" src="<%=path%>/js/dateSelect.js"></script>
    <script type="text/javascript" src="<%=path%>/js/iscrollDate.js"></script>

    <script type="text/javascript">
        $(document).ready(function(){
            drawChart1(<%=dateArray%>, <%=ipArray%>, <%=spArray%>);
            drawChart2(<%=dateArray%>, <%=cureRateArray%>, <%=deadRateArray%>);
            $(function(){
                //初始化日期插件
                $('#dateinput').date();
            });
            $("#paraAction").hide();
        });

    </script>
</head>
<body>
    <div id="main">
        <div id="mid">
            <div id="provinceNameAndReturn">
                <div id="provinceName">
                    <span style="color: white;font-weight:bold"><%=provinceName%></span>
                </div>
                <div id="returnButton">
                    <a id="back" href=<%=path%> >首页</a>
                </div>
            </div>

            <div id="ps1">
                <span>更新至</span>
            </div>

            <%-- 日期选择--%>
            <div id="dateSelect" style="position: absolute;left: 56px;top: 126px;">
                <form action="DataServlet?action=getProvinceData" id="formDateSelect">
                    <input id="paraAction" type="text" name="action" value="getProvinceData">
                    <input name="endDate" type="text" id="dateinput" value=<%=endDate%>>
                    <input type="submit" id="btnSelect" value="当天">
                </form>
                <div id="datePlugin"></div>

            </div>

            <div id="fourData">
                <div class="ip">
                    <span>感染患者</span><br>
                    <strong style="color: #F74C31;font-size: 26px;"><%=eip%></strong><br>
                    <div class="compareToday">
                        <span style="font-size: 8px">较昨日：</span>
                        <span style="font-size: 8px;color: #F74C31"><%=compare.getInt("eip")%></span>
                    </div>
                </div>
                <div class="sp">
                    <span>现存疑似</span><br>
                    <strong style="color: #F78207;font-size: 26px;"><%=esp%></strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #F78207"><%=compare.getInt("esp")%></span>
                    </div>
                </div>
                <div class="cure">
                    <span>累计治愈</span><br>
                    <strong style="color: #28B7A3;font-size: 26px;"><%=cure%></strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #28B7A3"><%=compare.getInt("cure")%></span>
                    </div>
                </div>
                <div class="dead">
                    <span>累计死亡</span><br>
                    <strong style="color: #5D7092;font-size: 26px;"><%=dead%></strong><br>
                    <div class="compareToday">
                        <span style="font-size: 6px">较昨日：</span>
                        <span style="font-size: 6px;color: #5D7092"><%=compare.getInt("dead")%></span>
                    </div>
                </div>
            </div>
            <div id="chart1"></div>
            <div id="chart2"></div>

        </div>
    </div>

</body>
</html>
