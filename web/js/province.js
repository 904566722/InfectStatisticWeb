//绘制趋势图1
function drawChart1(date, ip, sp){
    // step2. 基于准备好的dom，初始化echarts实例
    var chart1 = echarts.init(document.getElementById('chart1'));

    // step3. 指定图表的配置项和数据
    var option = {
        title: {
            text: '新增确诊'
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: ['新增确诊']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        toolbox: {
            show: true,
            feature: {
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: date,

        },
        yAxis: {
            type: 'value'
        },
        dataZoom: [
            {
                type: 'inside',
                xAxisIndex: [0],
                start: 1,
                end: 100
            },
        ],
        series: [
            {
                name: '新增确诊',
                type: 'line',
                stack: '总量',
                data: ip,
            },
        ]
    };

    // step4. 使用刚指定的配置项和数据显示图表。
    chart1.setOption(option);
}

//绘制趋势图3
function drawChart2(date, cureRate, deadRate){
    // step2. 基于准备好的dom，初始化echarts实例
    var chart2 = echarts.init(document.getElementById('chart2'));

    // step3. 指定图表的配置项和数据
    var option = {
        title: {
            text: '治愈率/死亡率'
        },
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: ['治愈率', '死亡率']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        toolbox: {
            show: true,
            feature: {
                dataView: {show: true, readOnly: false},
                magicType: {show: true, type: ['line', 'bar']},
                restore: {show: true},
                saveAsImage: {show: true}
            }
        },
        xAxis: {
            type: 'category',
            boundaryGap: false,
            data: date,

        },
        yAxis: {
            type: 'value'
        },
        dataZoom: [
            {
                type: 'inside',
                xAxisIndex: [0],
                start: 1,
                end: 100
            },
        ],
        series: [
            {
                name: '治愈率',
                type: 'line',
                stack: '总量1',
                data: cureRate,
            },
            {
                name: '死亡率',
                type: 'line',
                stack: '总量2',
                data: deadRate,
            },
        ]
    };

    // step4. 使用刚指定的配置项和数据显示图表。
    chart2.setOption(option);
}
