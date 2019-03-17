<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>统计</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
<body>
</head>
<body>
    <!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="width: 100%;height:400px"></div>
    <script type="text/javascript">
 var myChart
    	 $(function() {	
    var dom = document.getElementById("main");
    myChart = echarts.init(dom);
    var app = {};
   option = {
    tooltip : {
        trigger: 'axis',
        showDelay : 0,
        axisPointer:{
            show: true,
            type : 'cross',
            lineStyle: {
                type : 'dashed',
                width : 1
            }
        }
    },
    legend: {
        data:['scatter1','scatter2']
    },
    toolbox: {
        show : true,
        feature : {
            mark : {show: true},
            dataZoom : {show: true},
            dataView : {show: true, readOnly: false},
            restore : {show: true},
            saveAsImage : {show: true}
        }
    },
    xAxis : [
        {
            type : 'value',
            splitNumber: 4,
            scale: true
        }
    ],
    yAxis : [
        {
            type : 'value',
            splitNumber: 4,
            scale: true
        }
    ],
    series : [
        {
            name:'scatter1',
            type:'scatter',
            symbolSize: function (value){
                return Math.round(value[2] / 5);
            },
            data: randomDataArray()
        },
        {
            name:'scatter2',
            type:'scatter',
            symbolSize: function (value){
                return Math.round(value[2] / 5);
            },
            data: randomDataArray()
        }
    ]
}
    
        myChart.setOption(option, true);
   		
    });

function random(){
    var r = Math.round(Math.random() * 100);
    return (r * (r % 2 == 0 ? 1 : -1));
}

function randomDataArray() {
    var d = [];
    var len = 100;
    while (len--) {
        d.push([
            random(),
            random(),
            Math.abs(random()),
        ]);
    }
    return d;
}                 
    </script>
</body>
</html>