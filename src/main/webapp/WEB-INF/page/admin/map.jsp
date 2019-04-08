<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no, width=device-width">
    <title>货车路线规划－使用经纬度</title>
    <script type="text/javascript" src='https://webapi.amap.com/maps?v=1.4.14&key=9b75fad1e1af55bdd45c3ae69baca36c&plugin=AMap.TruckDriving&callback=init'></script> 
    <style>
    html,
    body,
    #container {
        width: 100%;
        height: 100%;
    }
    #panel {
        position: fixed;
        background-color: white;
        max-height: 90%;
        overflow-y: auto;
        top: 10px;
        right: 10px;
        width: 280px;
    }
    #panel .amap-lib-driving {
   	    border-radius: 4px;
        overflow: hidden;
    }
    </style>
    <link rel="stylesheet" href="https://a.amap.com/jsapi_demos/static/demo-center/css/demo-center.css" />
    <script src="https://a.amap.com/jsapi_demos/static/demo-center/js/demoutils.js"></script>
</head>
<body>
<div id="container" style="width: 100%;height: 900px"></div>
<div id="panel" ></div>


<script type="text/javascript">
$("#div_home_title").children("span").text("产品物流");
document.title = "Tmall管理后台 - 产品物流";
	var lngAndLat = JSON.parse('${requestScope.lngAndLat}')
window.init = function(){  
    var map = new AMap.Map('container', {  
    	 resizeEnable: true,
	     zoom:11,
	     center: [116.397428, 39.90923]
    });  
    
    AMap.service('AMap.TruckDriving',function(){//回调函数
		 var truckOptions = {
		        	map: map,
		            policy:0,
		            size:1,
		            city:'beijing',
		            panel:'panel'
		    };
		 var driving = new AMap.TruckDriving(truckOptions);
		 var path = [];
		    path.push({lnglat:lngAndLat.product_lngAndLat});//起点
		    path.push({lnglat:lngAndLat.user_lngAndLat});//终点
		   
		    driving.search(path, function(status, result) {
		        // result即是对应的货车导航信息，相关数据结构文档请参考 https://lbs.amap.com/api/javascript-api/reference/route-search#m_DrivingResult
		        if (status === 'complete') {
		            log.success('绘制货车路线完成')
		        } else {
		            log.error('获取货车规划数据失败：' + result)
		        }
		    });
           
	 
	 });
}  		
</script>
</body>
</html>
