<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2020/3/11
  Time: 10:03
To change this template use File | Settings | File Templates.
--%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSON" %>
<%@ page import="java.util.Comparator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String path=request.getContextPath();
    Object totalData = request.getAttribute("totalData");
    Object compareData = request.getAttribute("compareData");
    JSONArray compareJson = (JSONArray)compareData;
    JSONObject compare = (JSONObject) compareJson.get(0);
    JSONArray toatlDataJson = (JSONArray)totalData;
    JSONObject wholeNationData = null;
    for (Object object:toatlDataJson){
        JSONObject jsonObject = (JSONObject) object;
        if (jsonObject.get("name") == "全国"){
            wholeNationData = jsonObject;
        }
    }

    //折线图绘制需要用到的数据
    JSONArray lineChartData = (JSONArray) request.getAttribute("dailyData");
    JSONArray dateArray = new JSONArray();
    for (Object object : lineChartData){
        JSONObject jsonObject = (JSONObject) object;
        dateArray.add(jsonObject.get("date"));
    }

    //折线图1用：ip 新增感染， sp 新增疑似
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

    //折线图2用：cure 累计治愈 dead 累计死亡
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

    //折线图3用：cureRate 治愈率 deadRate死亡率
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
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/index.css">
    <link rel="stylesheet" type="text/css" href="<%=path%>/css/dateSelect.css">
    <script type="text/javascript" src="<%=path%>/js/raphael.js"></script>
    <script type="text/javascript" src="<%=path%>/js/chinamapPath.js"></script>
    <script type="text/javascript" src="<%=path%>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=path%>/js/test.js"></script>
    <script type="text/javascript" src="<%=path%>/js/dateSelect.js"></script>
    <script type="text/javascript" src="<%=path%>/js/iscrollDate.js"></script>

    <title>index</title>

    <script type="text/javascript">
        console.log(<%=totalData%>);

        console.log(<%=lineChartData%>);
        $(document).ready(function(){
            var mapType = "tip";    //绘制地图类型：1.现存确诊eip 2.累计确诊tip
            //展示地图 | 1.绘制两个地图 2.隐藏地图2（为点击事件准备）
            distinguishColorEip(<%=totalData%>, "<%=path%>");
            distinguishColorTip(<%=totalData%>, "<%=path%>");
            $("#map2").hide();

            //点击切换地图
            $("#drawMap1").click(function () {
                $("#map2").hide();
                $("#map1").show();
                $("#drawMap1").css("background","#288ADE");
                $("#drawMap2").css("background","#0EA6D8");
            });

            //绘制地图--累计确诊
            $("#drawMap2").click(function () {
                $("#map1").hide();
                $("#map2").show();
                $("#drawMap1").css("background","#0EA6D8");
                $("#drawMap2").css("background","#288ADE");
            });

            $("#drawMap1").css("background","#288ADE");

            //展示趋势图1
            drawLineChart1(<%=dateArray%>, <%=ipArray%>, <%=spArray%>);
            //隐藏趋势图2和趋势图3
            $("#lineChart3").hide();
            $("#lineChart2").hide();
            //点击切换图表
            $("#showLineChart1").click(function(){
                drawLineChart1(<%=dateArray%>, <%=ipArray%>, <%=spArray%>);
            });

            $("#showLineChart2").click(function(){
                drawLineChart2(<%=dateArray%>, <%=cureArray%>, <%=deadArray%>);
            });

            $("#showLineChart3").click(function(){
                drawLineChart3(<%=dateArray%>, <%=cureRateArray%>, <%=deadRateArray%>);
            });

            $("#provinceInfo").hide();

            $(function(){
                //初始化日期插件
                $('#dateinput').date();
            });

            $("#dataPs").hide();

            $("#dataSource").mouseover(function () {
                $("#dataPs").fadeIn("slow");
            });

            $("#dataSource").mouseout(function () {
                $("#dataPs").fadeOut(5000);
            });

        });
    </script>
</head>
<body>
    <!-- <div id="map"></div> -->
    <div id="main">
        <div id="leftPart">
            <!-- 导航栏 -->
            <div id="nav">
                <ul class="nav">
                    <li><a id="#scrollToMap" href="javascript:scrollToMap()">疫情地图</a></li>
                    <li><a id="#scrollToTendency" href="javascript:scrollToTendency()">趋势图</a></li>
                    <li><a id="#scrollToTable" href="javascript:scrollToTable()">表格数据</a></li>
                </ul>
            </div>

        </div>
        <div id="midPart">

            <div class="title">
                <span>疫情数据统计</span>
            </div>


            <div id="wholeData">
                <div id ="wdPs">
                    <p class="ps1">
                        <span style="color: #7F7F7F">截至<%=endDate%>全国数据统计</span>
                    </p>
                    <p class="ps2">
                        <span id="dataSource" style="color: #AAAAAA">数据说明</span>
                    </p>
                </div>
                <div id="wdData">
                    <div class="ip">
                        <strong><%=wholeNationData.getInt("eip")%></strong><br>
                        <span>现存确诊</span>
                        <div class="compareToday">
                            <span style="font-size: 8px">较昨日：</span>
                            <span style="font-size: 8px;color: #F74C31"><%=compare.getInt("eip")%></span>
                        </div>
                    </div>
                    <div class="sp">
                        <strong><%=wholeNationData.getInt("esp")%></strong><br>
                        <span>现存疑似</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #F78207"><%=compare.getInt("esp")%></span>
                        </div>
                    </div>
                    <div class="cure">
                        <strong><%=wholeNationData.getInt("cure")%></strong><br>
                        <span>累计治愈</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #28B7A3"><%=compare.getInt("cure")%></span>
                        </div>
                    </div>
                    <div class="dead">
                        <strong><%=wholeNationData.getInt("dead")%></strong><br>
                        <span>累计死亡</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #5D7092"><%=compare.getInt("dead")%></span>
                        </div>
                    </div>
                </div>

            </div>


            <div id="chinaMap">

                <!-- 疫情地图标题 -->
                <div class="midPartTitle">
                    <div class="titleIcon"></div>
                    <strong>疫情地图</strong>
                </div>

                <%-- 日期选择--%>
                <div id="dateSelect">
                    <form action="DataServlet" id="formDateSelect">
                        <input name="endDate" type="text" id="dateinput" value=<%=endDate%>>
                        <input type="submit" id="btnSelect" value="查看">
                    </form>
                    <div id="datePlugin"></div>

                </div>

                <!-- 地图渲染 -->
                <div id="map1"></div>
                <div id="map2"></div>

                <!-- 切换地图按钮 -->
                <ul class="changeMap">
                    <li><a id="drawMap1" href="javascript:void(0)">现存确诊</a></li>
                    <li><a id="drawMap2" href="javascript:void(0)">累计确诊</a></li>
                </ul>

                <div id="levelInfo">
                    <div class="levelColor">
                        <div id="levelColor1"></div>
                        <div id="levelColor2"></div>
                        <div id="levelColor3"></div>
                        <div id="levelColor4"></div>
                        <div id="levelColor5"></div>
                        <div id="levelColor6"></div>
                        <div id="levelColor7"></div>
                    </div>
                    <div class="rightNum" style="text-align: left;position: relative;left: 17px;top: -123px;">
                        <strong class="num">≥10000</strong><br>
                        <strong class="num">1000-9999</strong><br>
                        <strong class="num">500-999</strong><br>
                        <strong class="num">100-499</strong><br>
                        <strong class="num">10-99</strong><br>
                        <strong class="num">1-9</strong><br>
                        <strong class="num">0</strong>
                    </div>
                </div>

            </div>


            <div id="tendencyChart">
                <!-- 趋势标题 -->
                <div class="midPartTitle">
                    <div class="titleIcon"></div>
                    <strong>趋势图</strong>
                </div>

                <!-- 切换趋势图按钮 -->
                <ul class="changeTendency">
                    <li><a id="showLineChart1" href="javascript:void(0)">新增确诊/疑似</a></li>
                    <li><a id="showLineChart2" href="javascript:void(0)">累计治愈/死亡</a></li>
                    <li><a id="showLineChart3" href="javascript:void(0)">治愈率/死亡率</a></li>
                </ul>

                <!-- 趋势图图表 -->
                <div id="lineChart1"></div>
                <div id="lineChart2"></div>
                <div id="lineChart3"></div>

            </div>


            <div id="tableData">
                <!-- 表格数据标题 -->
                <div class="midPartTitle">
                    <div class="titleIcon"></div>
                    <strong>表格数据</strong>
                </div>

                <!-- 表格数据 -->
                <div id="tableChart">
                    <!-- 1.遍历数据
                        2.标题顺序：地区 name 现存确诊eip 累计确诊tip 累计死亡dead 累计治愈cure
                     -->

                    <table id="table">
                        <tr>
                            <th>地区</th>
                            <th style="background-color: #F74C31">现存确诊</th>
                            <th style="background-color: #F78207">累计确诊</th>
                            <th style="background-color: #7F7F7F">累计死亡</th>
                            <th style="background-color: #00BFBF">累计治愈</th>
                        </tr>
                        <%
                            JSONArray jsonData = (JSONArray)totalData;
                            for(int i=0; i< jsonData.size(); i++){
                                JSONObject objData = jsonData.getJSONObject(i);%>
                              <tr><td><%=objData.getString("name")%></td>
                                    <td><%=objData.getInt("eip") %></td>
                                  <td><%=objData.getInt("tip") %></td>
                                  <td><%=objData.getInt("dead") %></td>
                                  <td><%=objData.getInt("cure") %></td>
                              </tr>
                            <%}
                          %>
                    </table>
                </div>

            </div>

            <div></div>
        </div>


        <div id="rightPart">

            <div id="provinceInfo">
                <div id="infoProvinceName">
                    <p style="font-weight: bold; margin-top:3px"></p>
                </div>
                <div id="infoProvinceIp">
                    <div class="infoLeft">
                        <strong>现存确诊</strong>
                    </div>
                    <div id="infoIp">
                        <p></p>
                    </div>
                </div>
                <div id="infoProvinceSp">
                    <div class="infoLeft">
                        <strong>现存疑似</strong>
                    </div>
                    <div id="infoSp">
                        <p></p>
                    </div>
                </div>
                <div id="infoProvinceCure">
                    <div class="infoLeft">
                        <strong>累计治愈</strong>
                    </div>
                    <div id="infoCure">
                        <p></p>
                    </div>
                </div>
                <div id="infoProvinceDead">
                    <div class="infoLeft">
                        <strong>累计死亡</strong>
                    </div>
                    <div id="infoDead">
                        <p></p>
                    </div>
                </div>
            </div>

            <div id="dataPs">
                <p>2020-01-14~2020-03-13的数据来源:</p><a target="_blank" href="https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv">https://github.com/BlankerL/DXY-COVID-19-Data/blob/master/csv/DXYArea.csv</a>
                <p>2020-03-3之后的数据来源:</p><a target="_blank" href="https://news.qq.com/zt2020/page/feiyan.htm#/">https://news.qq.com/zt2020/page/feiyan.htm#/</a>
            </div>
        </div>

    </div>
</body>
</html>
