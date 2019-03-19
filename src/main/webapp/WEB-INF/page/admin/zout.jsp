<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	function show()
	{
	var time=new Date();
	var year=time.getYear();
	var month=time.getMonth()+1;
	var day=time.getDate();
	var hours=time.getHours();
	var minute=time.getMinutes();
	var sconds=time.getSeconds(); var ss="";
	var mi=null; var sc=null;
	if(hours>=0&&hours<12) { ss="上午好！"; }
	else if(hours>=12&&hours<24) { ss="下午好!"; }
	if(minute<10){ mi="0"+minute; }
	else{ mi=minute; }
	if(sconds<10){ sc="0"+sconds; }
	else{ sc=sconds; }
	var st="今天日期:<font size='2' style='color:red;'>"
	+year+"年"+month+"月"+day+"日</font>"+ " "+
	"现在时间:<font size='2' style='color:red;'>"+ 
	hours+":"+mi+":"+sc+"</font>"; 
	document.getElementById("aaa").innerHTML=ss; 
	document.getElementById("mydate").innerHTML=st; window.setTimeout("show()",1000); }
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