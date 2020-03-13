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
%>

<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="css/index.css">
    <script type="text/javascript" src="./js/raphael.js"></script>
    <script type="text/javascript" src="./js/chinamapPath.js"></script>
    <script type="text/javascript" src="./js/jquery.js"></script>
    <script type="text/javascript" src="./js/test.js"></script>

    <title>index</title>

    <script type="text/javascript">
        <%--console.log(<%=path%>);--%>
        $(document).ready(function(){
            var mapType = "tip";    //绘制地图类型：1.现存确诊eip 2.累计确诊tip
            //展示地图 | 1.绘制两个地图 2.隐藏地图2（为点击事件准备）
            distinguishColorEip(<%=totalData%>, "<%=path%>");
            distinguishColorTip(<%=totalData%>);
            $("#map2").hide();

            //点击切换地图
            $("#drawMap1").click(function () {
                $("#map2").hide();
                $("#map1").show();
            });

            //绘制地图--累计确诊
            $("#drawMap2").click(function () {
                $("#map1").hide();
                $("#map2").show();
            });

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
                        <span style="color: #7F7F7F">截至2020-02-04 23:00全国数据统计</span>
                    </p>
                    <p class="ps2">
                        <span style="color: #AAAAAA">数据说明</span>
                    </p>
                </div>
                <div id="wdData">
                    <div class="ip">
                        <strong><%=wholeNationData.getInt("eip")%></strong><br>
                        <span>现存确诊</span>
                        <div class="compareToday">
                            <span style="font-size: 8px">较昨日：</span>
                            <span style="font-size: 8px;color: #F74C31">-1335</span>
                        </div>
                    </div>
                    <div class="sp">
                        <strong><%=wholeNationData.getInt("esp")%></strong><br>
                        <span>现存疑似</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #F78207">-1335</span>
                        </div>
                    </div>
                    <div class="cure">
                        <strong><%=wholeNationData.getInt("cure")%></strong><br>
                        <span>累计治愈</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #28B7A3">-1335</span>
                        </div>
                    </div>
                    <div class="dead">
                        <strong><%=wholeNationData.getInt("dead")%></strong><br>
                        <span>累计死亡</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #5D7092">-1335</span>
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

                <!-- 地图渲染 -->
                <div id="map1"></div>
                <div id="map2"></div>

                <!-- 切换地图按钮 -->
                <ul class="changeMap">
                    <li><a id="drawMap1" href="javascript:void(0)">现存确诊</a></li>
                    <li><a id="drawMap2" href="javascript:void(0)">累计确诊</a></li>
                </ul>

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
                    <p></p>
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
        </div>

    </div>
</body>
</html>
