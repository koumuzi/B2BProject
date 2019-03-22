<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height: 100%">
   <head>
       <meta charset="utf-8">
   </head>
   <body style="height: 100%">
       <div id="container" style="height: 900px"></div>
       <script type="text/javascript">
       var geoCoordMap =null;
       var myChart = null;
       var data = null;
       $(document).ready(function(){
			var dom = document.getElementById("container");
			myChart = echarts.init(dom);
			var app = {};
			option = null;
			option = {
	   
				};
			
			if (option && typeof option === "object") {
 			   myChart.setOption(option, true);
			}
			getUserDistributionData('${requestScope.Distribution}')
		});
       
       var convertData = function (data) {
    	    var res = [];
    	    for (var i = 0; i < data.length; i++) {
    	        var geoCoord = geoCoordMap[data[i].name];
    	        if (geoCoord) {
    	            res.push({
    	                name: data[i].name,
    	                value: geoCoord.concat(data[i].value)
    	            });
    	        }
    	    }
    	    return res;
    	};
       
       function getUserDistributionData(Distribution) {
    	   
    	  console.log(Distribution.get("geoCoordMap"))
    	  

           if (Distribution == null) {
               $.ajax({
                   url: "/tmall/admin/home/consumer",
                   type: "get",
                   dataType: "json",
                   success: function (data) {
                	   geoCoordMap : data.geoCoordMap;
                	   
                	 
                  
                       //异步加载数据
                       myChart.setOption({
                    	   backgroundColor: '#1E90FF',
                   	    title: {
                   	        text: '用户分布图',
                   	        left: 'center',
                   	        textStyle: {
                   	            color: '#fff'
                   	        }
                   	    },
                   	    tooltip : {
                   	        trigger: 'item'
                   	    },
                   	    legend: {
                   	        orient: 'vertical',
                   	        y: 'bottom',
                   	        x:'right',
                   	        data:['用户数量'],
                   	        textStyle: {
                   	            color: '#fff'
                   	        }
                   	    },
                   	    geo: {
                   	        map: 'china',
                   	        label: {
                   	            emphasis: {
                   	                show: false
                   	            }
                   	        },
                   	        roam: true,
                   	        itemStyle: {
                   	            normal: {
                   	                areaColor: '#4169E1',
                   	                borderColor: '#111'
                   	            },
                   	            emphasis: {
                   	                areaColor: '#2a333d'
                   	            }
                   	        }
                   	    },
                   	    series : [
                   	        {
                   	            name: '用户数量',
                   	            type: 'user_count',
                   	            coordinateSystem: 'geo',
                   	            data: convertData(data.data),
                   	            symbolSize: function (val) {
                   	                return val[2] / 10;
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
                   	                    color: '#ddb926'
                   	                }
                   	            }
                   	        }
                   	    ]
                       });
                   }
               })} else {
        	   geoCoordMap : Distribution.geoCoordMap
        	  
               //异步加载数据
        	   myChart.setOption({
            	   backgroundColor: '#1E90FF',
           	    title: {
           	        text: '用户分布图',
           	        left: 'center',
           	        textStyle: {
           	            color: '#fff'
           	        }
           	    },
           	    tooltip : {
           	        trigger: 'item'
           	    },
           	    legend: {
           	        orient: 'vertical',
           	        y: 'bottom',
           	        x:'right',
           	        data:['pm2.5'],
           	        textStyle: {
           	            color: '#fff'
           	        }
           	    },
           	    geo: {
           	        map: 'china',
           	        label: {
           	            emphasis: {
           	                show: false
           	            }
           	        },
           	        roam: true,
           	        itemStyle: {
           	            normal: {
           	                areaColor: '#4169E1',
           	                borderColor: '#111'
           	            },
           	            emphasis: {
           	                areaColor: '#2a333d'
           	            }
           	        }
           	    },
           	    series : [
           	        {
           	            name: '用户数量',
           	            type: 'user_count',
           	            coordinateSystem: 'geo',
           	            data: convertData(data),
           	            symbolSize: function (val) {
           	                return val[2] / 10;
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
           	                    color: '#ddb926'
           	                }
           	            }
           	        }
           	    ]
               });
           }
       }
       
       </script>
   </body>
</html>