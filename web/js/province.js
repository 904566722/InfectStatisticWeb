//绘制趋势图1
function drawChart1(date, ip, sp){
    // step2. 基于准备好的dom，初始化echarts实例
    var chart1 = echarts.init(document.getElementById('chart1'));

    // step3. 指定图表的配置项和数据
    var option = {
        title: {
            text: '新增确诊/新增疑似'
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
            data: date,

        },
        yAxis: {
            type: 'value'
        },
        series: [
            {
                name: '新增确诊',
                type: 'line',
                stack: '总量',
                data: ip,
            },
            {
                name: '新增疑似',
                type: 'line',
                stack: '总量',
                data: sp,
            },
        ]
    };

    // step4. 使用刚指定的配置项和数据显示图表。
    chart1.setOption(option);
}

//绘制趋势图3
function drawChart2(date, cure, dead){
    // step2. 基于准备好的dom，初始化echarts实例
    var chart2 = echarts.init(document.getElementById('chart2'));

    // step3. 指定图表的配置项和数据
    var option = {
        title: {
            text: '新增确诊/新增疑似'
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
            data: date,

        },
        yAxis: {
            type: 'value'
        },
        series: [
            {
                name: '新增确诊',
                type: 'line',
                stack: '总量',
                data: cure,
            },
            {
                name: '新增疑似',
                type: 'line',
                stack: '总量',
                data: dead,
            },
        ]
    };

    // step4. 使用刚指定的配置项和数据显示图表。
    chart2.setOption(option);
}
