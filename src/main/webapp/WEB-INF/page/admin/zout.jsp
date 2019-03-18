<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
<title>统计</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
</head>
<body>
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
	<div id="main" style="width: 80%; height: 500px"></div>
	<script type="text/javascript">
	var myChart
	var dom = document.getElementById("main");
	myChart = echarts.init(dom);
	option = {
		    tooltip : {
		        trigger: 'axis'
		    },
		    toolbox: {
		        show : true,
		        y: 'bottom',
		        itemSize: 18,
		        right: 1,
                top: 1,
		        feature : {
		            mark : {show: true},
		            dataView : {show: true, readOnly: false},
		            magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
		            restore : {show: true},
		            saveAsImage : {show: true}   
		        }
		    },
		    calculable : true,
		    legend: {
		        data:['新鲜水果', '猪牛羊肉', '家禽蛋品', '新鲜蔬菜', '速冻食品']
		    },
		    xAxis : [
		        {
		            type : 'category',
		            splitLine : {show : false},
		            data : ['周一','周二','周三','周四','周五','周六','周日']
		        }
		    ],
		    yAxis : [
		        {
		            type : 'value',
		            position: 'right'
		        }
		    ],
		    series : [
		        {
		            name:'新鲜水果',
		            type:'bar',
		            data:[320, 332, 301, 334, 390, 330, 320]
		        },
		        {
		            name: '猪牛羊肉',
		            type:'bar',
		            tooltip : {trigger: 'item'},
		            stack: '广告',
		            data:[120, 132, 101, 134, 90, 230, 210]
		        },
		        {
		            name: '家禽蛋品',
		            type:'bar',
		            tooltip : {trigger: 'item'},
		            stack: '广告',
		            data:[220, 182, 191, 234, 290, 330, 310]
		        },
		        {
		            name: '新鲜蔬菜',
		            type:'bar',
		            tooltip : {trigger: 'item'},
		            stack: '广告',
		            data:[150, 232, 201, 154, 190, 330, 410]
		        },
		        {
		            name: '速冻食品',
		            type:'line',
		            data:[862, 1018, 964, 1026, 1679, 1600, 1570]
		        }
		    ]
		};
	myChart.setOption(option);
			
	</script>
</body>
</html>