<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2020/3/11
  Time: 10:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        $(document).ready(function(){
            // step2. 基于准备好的dom，初始化echarts实例
            var lineChart = echarts.init(document.getElementById('lineChart'));

            // step3. 指定图表的配置项和数据
            var option = {
                title: {
                    text: '人数'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['新增确诊', '新增疑似']
                },
                grid: {
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    containLabel: true
                },
                toolbox: {
                    feature: {
                        saveAsImage: {}
                    }
                },
                xAxis: {
                    type: 'category',
                    boundaryGap: false,
                    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
                },
                yAxis: {
                    type: 'value'
                },
                series: [
                    {
                        name: '新增确诊',
                        type: 'line',
                        stack: '总量',
                        data: [120, 132, 101, 134, 90, 230, 210]
                    },
                    {
                        name: '新增疑似',
                        type: 'line',
                        stack: '总量',
                        data: [220, 182, 191, 234, 290, 330, 310]
                    },
                ]
            };

            // step4. 使用刚指定的配置项和数据显示图表。
            lineChart.setOption(option);
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
                    <li><a href="#chinaMap">疫情地图</a></li>
                    <li><a href="#tendencyChart">趋势图</a></li>
                    <li><a href="#tableData">表格数据</a></li>
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
                        <strong style="color: #F74C31">49666</strong><br>
                        <span style="font-size: 12px;font-weight: bold;">现存确诊</span>
                        <div class="compareToday">
                            <span style="font-size: 8px">较昨日：</span>
                            <span style="font-size: 8px;color: #F74C31">-1335</span>
                        </div>
                    </div>
                    <div class="sp">
                        <strong style="color: #F78207">3434</strong><br>
                        <span style="font-size: 12px;font-weight: bold;">现存疑似</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #F78207">-1335</span>
                        </div>
                    </div>
                    <div class="cure">
                        <strong style="color: #28B7A3">49666</strong><br>
                        <span style="font-size: 12px;font-weight: bold;">累计治愈</span>
                        <div class="compareToday">
                            <span style="font-size: 6px">较昨日：</span>
                            <span style="font-size: 6px;color: #28B7A3">-1335</span>
                        </div>
                    </div>
                    <div class="dead">
                        <strong style="color: #5D7092">49666</strong><br>
                        <span style="font-size: 12px;font-weight: bold;">累计死亡</span>
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
                    <li><a href="#">现存确诊</a></li>
                    <li><a href="#">累计确诊</a></li>
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
                    <li><a href="#">新增确诊/疑似</a></li>
                    <li><a href="#">累计治愈/死亡</a></li>
                    <li><a href="#">治愈率/死亡率</a></li>
                </ul>

                <!-- 趋势图图表 -->
                <div id="lineChart"></div>
                <script type="text/javascript">



                </script>

            </div>


            <div id="tableData">
                <!-- 表格数据标题 -->
                <div class="midPartTitle">
                    <div class="titleIcon"></div>
                    <strong>表格数据</strong>
                </div>

                <!-- 表格数据 -->
                <div id="tableChart">

                </div>

            </div>

            <div></div>
        </div>


        <div id="rightPart">


        </div>
    </div>
</body>
</html>
