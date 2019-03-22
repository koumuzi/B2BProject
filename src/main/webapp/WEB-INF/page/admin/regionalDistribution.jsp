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
		
			getUserDistributionData()
		});
       
      
       
       function getUserDistributionData() {
    	   
               $.ajax({
                   url: "/tmall/admin/home/consumer",
                   type: "get",
                   dataType: "json",
                   success: function (data) {
                
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
                	                    	   backgroundColor: '#1E90FF',
                	                   	    title: {
                	                   	        text: '用户分布图',
                	                   	        left: 'center',
                	                   	        textStyle: {
                	                   	            color: '#fff'
                	                   	        }
                	                   	    },
                	                   	    tooltip : {
                	                   	        trigger: 'item',
                	                   	         formatter: function (params) {
                	                   	            return params.name + ' : ' + params.value[2];
                	                   	        }
                	                   	    },
                	                   	    legend: {
                	                   	        orient: 'vertical',
                	                   	        y: 'top',
                	                   	        x:'left',
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
                	                   	        },
                	                   	     mapStyle: {
                	                             styleJson: [
                	                                     {
                	                                         "featureType": "water",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "color": "#044161"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "land",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "color": "#004981"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "boundary",
                	                                         "elementType": "geometry",
                	                                         "stylers": {
                	                                             "color": "#064f85"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "railway",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "highway",
                	                                         "elementType": "geometry",
                	                                         "stylers": {
                	                                             "color": "#004981"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "highway",
                	                                         "elementType": "geometry.fill",
                	                                         "stylers": {
                	                                             "color": "#005b96",
                	                                             "lightness": 1
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "highway",
                	                                         "elementType": "labels",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "arterial",
                	                                         "elementType": "geometry",
                	                                         "stylers": {
                	                                             "color": "#004981"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "arterial",
                	                                         "elementType": "geometry.fill",
                	                                         "stylers": {
                	                                             "color": "#00508b"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "poi",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "green",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "color": "#056197",
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "subway",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "manmade",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "local",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "arterial",
                	                                         "elementType": "labels",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "boundary",
                	                                         "elementType": "geometry.fill",
                	                                         "stylers": {
                	                                             "color": "#029fd4"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "building",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "color": "#1a5787"
                	                                         }
                	                                     },
                	                                     {
                	                                         "featureType": "label",
                	                                         "elementType": "all",
                	                                         "stylers": {
                	                                             "visibility": "off"
                	                                         }
                	                                     }
                	                             ]
                	                         }
                	                     },
                	                   	    
                	                   	    series : [
                	                   	        {
                	                   	            name: '用户数量',
                	                   	            type: 'effectScatter',
                	                   	            coordinateSystem: 'geo',
                	                   	            data: convertData(countdata),
                	                   	            symbolSize: function (val) {
                	                   	          
                	                   	                return val[2] ;
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
               })} 
       
       
      
       
       </script>
   </body>
</html>