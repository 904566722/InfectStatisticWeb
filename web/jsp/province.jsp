<%--
  Created by IntelliJ IDEA.
  User: DELL
  Date: 2020/3/11
  Time: 22:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>省份详细数据</title>
    <link rel="stylesheet" type="text/css" href="../css/province.css">
    <script type="text/javascript" src="../js/jquery.js"></script>
    <script type="text/javascript" src="../js/test.js"></script>

    <script type="text/javascript">
        $(document).ready(function(){
            // step2. 基于准备好的dom，初始化echarts实例
            var chart1 = echarts.init(document.getElementById('chart1'));

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
            chart1.setOption(option);

            var chart2 = echarts.init(document.getElementById('chart2'));

            // step3. 指定图表的配置项和数据
            var option = {
                title: {
                    text: '人数'
                },
                tooltip: {
                    trigger: 'axis'
                },
                legend: {
                    data: ['累计治愈', '累计死亡']
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
                        name: '累计治愈',
                        type: 'line',
                        stack: '总量',
                        data: [120, 132, 101, 134, 90, 230, 210]
                    },
                    {
                        name: '累计死亡',
                        type: 'line',
                        stack: '总量',
                        data: [220, 182, 191, 234, 290, 330, 310]
                    },
                ]
            };

            // step4. 使用刚指定的配置项和数据显示图表。
            chart2.setOption(option);
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
                    <a href="../index.jsp">首页</a>
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
