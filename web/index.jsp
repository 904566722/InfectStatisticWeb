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
    Object data = request.getAttribute("totalData");

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
        console.log(<%=data%>);
        $(document).ready(function(){
            //绘制地图
            //  drawMap();
            distinguishColor(<%=data%>);
             //绘制趋势图1
            drawLineChart1();
            //隐藏图2和图3
            $("#lineChart3").hide();
            $("#lineChart2").hide();
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
                        <strong>49666</strong><br>
                        <span>现存确诊</span>
                        <div class="compareToday">
                            <span style="font-size: 8px">较昨日：</span>
                            <span style="font-size: 8px;color: #F74C31">-1335</span>
                        </div>
                    </div>
                    <div class="sp">
                        <strong>3434</strong><br>
                        <span>现存疑似</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #F78207">-1335</span>
                        </div>
                    </div>
                    <div class="cure">
                        <strong>25007</strong><br>
                        <span>累计治愈</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #28B7A3">-1335</span>
                        </div>
                    </div>
                    <div class="dead">
                        <strong>2596</strong><br>
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
                <div id="map"></div>

                <!-- 切换地图按钮 -->
                <ul class="changeMap">
                    <li><a id="drawMap1" href="javascript:drawMap1()">现存确诊</a></li>
                    <li><a id="drawMap2" href="javascript:drawMap2()">累计确诊</a></li>
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
                    <li><a id="showLineChart1" href="javascript:drawLineChart1()">新增确诊/疑似</a></li>
                    <li><a id="showLineChart2" href="javascript:drawLineChart2()">累计治愈/死亡</a></li>
                    <li><a id="showLineChart3" href="javascript:drawLineChart3()">治愈率/死亡率</a></li>
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
                            JSONArray jsonData = (JSONArray)data;
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

        </div>

    </div>
</body>
</html>
