<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Unsalable Map Information</title>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 1200px;height:800px;"></div>
<script type="text/javascript">
//引入json地图
    // $.get('json/china.json', function (chinaJson) {
    //     echarts.registerMap('china', chinaJson);
    // });
    // 基于准备好的dom，初始化echarts实例
    
    $(document).ready(function(){
    	var myChart = echarts.init(document.getElementById('main'));
		var app = {};
		option = null;
		option = {
   
			};
		
		if (option && typeof option === "object") {
			   myChart.setOption(option, true);
		}
	
		getUnsalableData()
	});
   
  console.log(123456);
   
   function getUnsalableData() {

		$.ajax({
		    url: "/tmall/admin/home/datamap",
		    type: "get",
		    dataType: "json",
		    error: function(){
		    	alert('smx失败');
		    },
		    success: function (data) {
		    	console.log(data)
		 	   var geoCoordMap = JSON.parse(data.geoCoordMap)
		 	   var countdata = JSON.parse(data.count_data)
		 	   var convertData = function (countdata) {
		 	   	  	  var res = [];
		 	   	  	  
		 	   	    for (var i = 0; i < countdata.length; i++) {
		 	   	        var geoCoord = geoCoordMap[countdata[i].name];
		 	   	        if (geoCoord) {
		 	   	            res.push({
		 	   	                name: countdata[i].name,
		 	   	                value: geoCoord.concat(countdata[i].value)
		 	   	            });
		 	   	        }
		 	   	    }
		 	   	    
		 	   		console.log(res)
		 	   	    return res;
		 	   	};
		 	 //异步加载数据
                myChart.setOption({
                    backgroundColor: '#404a59',
                    animation: true,
                    animationDuration: 1000,
                    animationEasing: 'cubicInOut',
                    animationDurationUpdate: 1000,
                    animationEasingUpdate: 'cubicInOut',
                    title: [{
                        text: '农村地区生滞销鲜农产品分布',
                        link: 'http://www.znw58.com/special/1/5.html',
                        subtext: '滞销数据信息来源',
                        sublink: 'http://www.znw58.com/special/1/5.html',
                        left: 'center',
                        textStyle: {
                            color: '#fff'
                        }
                    }, {
                        id: 'statistic',
                        text: count ? '平均: ' + parseInt((sum / count).toFixed(4)) : '',
                        right: 120,
                        top: 40,
                        width: 100,
                        textStyle: {
                            color: '#fff',
                            fontSize: 16
                        }
                    }],
                    toolbox: {
                        iconStyle: {
                            normal: {
                                borderColor: '#fff'
                            },
                            emphasis: {
                                borderColor: '#b1e4ff'
                            }
                        },
                        feature: {
                            dataZoom: {},
                            brush: {
                                type: ['rect', 'polygon', 'clear']
                            },
                            saveAsImage: {
                                show: true
                            }
                        }
                    },
                    brush: {
                        outOfBrush: {
                            color: '#abc'
                        },
                        brushStyle: {
                            borderWidth: 2,
                            color: 'rgba(0,0,0,0.2)',
                            borderColor: 'rgba(0,0,0,0.5)',
                        },
                        seriesIndex: [0, 1],
                        throttleType: 'debounce',
                        throttleDelay: 300,
                        geoIndex: 0
                    },
                    geo: {
                        map: 'china',
                        left: '10',
                        right: '35%',
                        center: [117.98561551896913, 31.205000490896193],
                        zoom: 1.5,
                        label: {
                            emphasis: {
                                show: false
                            }
                        },
                        roam: true,
                        itemStyle: {
                            normal: {
                                areaColor: '#323c48',
                                borderColor: '#111'
                            },
                            emphasis: {
                                areaColor: '#2a333d'
                            }
                        }
                    },
                    tooltip: { 
                        trigger: 'item'
                    },
                    grid: {
                        right: 40,
                        top: 100,
                        bottom: 40,
                        width: '30%'
                    },
                    xAxis: {
                        type: 'value',
                        scale: true,
                        position: 'top',
                        boundaryGap: false,
                        splitLine: {
                            show: false
                        },
                        axisLine: {
                            show: false
                        },
                        axisTick: {
                            show: false
                        },
                        axisLabel: {
                            margin: 2,
                            textStyle: {
                                color: '#aaa'
                            }
                        },
                    },
                    yAxis: {
                        type: 'category',
                        //  name: 'TOP 20',
                        nameGap: 16,
                        axisLine: {
                            show: true,
                            lineStyle: {
                                color: '#ddd'
                            }
                        },
                        axisTick: {
                            show: false,
                            lineStyle: {
                                color: '#ddd'
                            }
                        },
                        axisLabel: {
                            interval: 0,
                            textStyle: {
                                color: '#ddd'
                            }
                        },
                        data: categoryData
                    },
                    series: [{
                        name: 'pm2.5',
                        type: 'scatter',
                        coordinateSystem: 'geo',
                        data: convertedData[0],
                        symbolSize: function(val) {
                            return Math.max(val[2] / 300, 8);
                        },
                        label: {
                            normal: {
                                formatter: '{b}',
                                position: 'right',
                                show: false
                            },
                            emphasis: {
                                show: true
                            }
                        },
                        itemStyle: {
                            normal: {
                                color: '#FF8C00',
                                position: 'right',
                                show: true
                            }
                        }
                    }, {
                          name: 'Top 5',
                        type: 'effectScatter',
                        coordinateSystem: 'geo',
                        data: convertedData[0],
                        symbolSize: function(val) {
                            return Math.max(val[2] / 500, 8);
                        },
                        showEffectOn: 'render',
                        rippleEffect: {
                            brushType: 'stroke'
                        },
                        hoverAnimation: true,
                        label: {
                            normal: {
                                formatter: '{b}',
                                position: 'right',
                                show: true
                            }
                        },
                        itemStyle: {
                            normal: {
                                color: '#f4e925',
                                shadowBlur: 50,
                                shadowColor: '#EE0000'
                            }
                        },
                        zlevel: 1
                    }, {
                        id: 'bar',
                        zlevel: 2,
                        type: 'bar',
                        symbol: 'none',
                        itemStyle: {
                            normal: {
                                color: '#ddb926'
                            }
                        },

                        data: convertData(countdata)
                    }]
                    
                });
		    }
		})}
  

</script>
</body>
</html>