<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
</style>
</head>
<body>
	<ul id="chartByDate">
		<li><span class="chartDateBtn text_info select">最近一周</span></li>
		<li class="chartDateBtn"><input class="chartDateInput"
			id="input_beginDate" type="date" title="开始日期" /><span class="split">—</span>
			<input class="chartDateInput details_unit" id="input_endDate"
			type="date" title="结束日期" /></li>
		<li><input class="frm_btn" id="btn_chart_search" type="button"
			value="查询" /></li>
	</ul>
	<div id="chartDiv" style="width: 100%; height: 500px"></div>
	<div class="container"></div>
	<script>
		var myChart
		$(function() {
			$(function() {
				var dom = document.getElementById("chartDiv");
				myChart = echarts.init(dom);
				var app = {};
				option = null;
				app.title = '销售情况统计';
				option = {
					title : {
						text : '动态数据',
						subtext : '纯属虚构'
					},
					tooltip : {
						trigger : 'axis',
						axisPointer : {
							type : 'cross',
							label : {
								backgroundColor : '#283b56'
							}
						}
					},
					legend : {
						data : [ '最新成交价', '预购队列' ]
					},
					toolbox : {
						show : true,
						feature : {
							dataView : {
								readOnly : false
							},
							restore : {},
							saveAsImage : {}
						}
					},
					dataZoom : {
						show : false,
						start : 0,
						end : 100
					},
					xAxis : [
							{
								type : 'category',
								boundaryGap : true,
								data : (function() {
									var now = new Date();
									var res = [];
									var len = 10;
									while (len--) {
										res.unshift(now.toLocaleTimeString()
												.replace(/^\D*/, ''));
										now = new Date(now - 2000);
									}
									return res;
								})()
							}, {
								type : 'category',
								boundaryGap : true,
								data : (function() {
									var res = [];
									var len = 10;
									while (len--) {
										res.push(10 - len - 1);
									}
									return res;
								})()
							} ],
					yAxis : [ {
						type : 'value',
						scale : true,
						name : '价格',
						max : 30,
						min : 0,
						boundaryGap : [ 0.2, 0.2 ]
					}, {
						type : 'value',
						scale : true,
						name : '预购量',
						max : 1200,
						min : 0,
						boundaryGap : [ 0.2, 0.2 ]
					} ],
					series : [
							{
								name : '预购队列',
								type : 'bar',
								xAxisIndex : 1,
								yAxisIndex : 1,
								data : (function() {
									var res = [];
									var len = 10;
									while (len--) {
										res.push(Math
												.round(Math.random() * 1000));
									}
									return res;
								})()
							},
							{
								name : '最新成交价',
								type : 'line',
								data : (function() {
									var res = [];
									var len = 0;
									while (len < 10) {
										res.push((Math.random() * 10 + 5)
												.toFixed(1) - 0);
										len++;
									}
									return res;
								})()
							} ]
				};

				app.count = 11;
				setInterval(function() {
					axisData = (new Date()).toLocaleTimeString().replace(
							/^\D*/, '');

					var data0 = option.series[0].data;
					var data1 = option.series[1].data;
					data0.shift();
					data0.push(Math.round(Math.random() * 1000));
					data1.shift();
					data1.push((Math.random() * 10 + 5).toFixed(1) - 0);

					option.xAxis[0].data.shift();
					option.xAxis[0].data.push(axisData);
					option.xAxis[1].data.shift();
					option.xAxis[1].data.push(app.count++);

					myChart.setOption(option);
				}, 2100);
			})
		});
	</script>
</body>
</html>
