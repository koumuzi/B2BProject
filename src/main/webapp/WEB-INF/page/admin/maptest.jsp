<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
</style>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=4pfUa6c0Fpum3lwQYvaXSNakvbawYRgq&callback=init"></script>
</head>
<body>
<div id="allmap" style="width: 100%;height: 900px"></div>
</body>

<script type="text/javascript">

// 百度地图API功能


window.init = function(){  
	$("#div_home_title").children("span").text("产品物流");
	document.title = "Tmall管理后台 - 产品物流";
	var lngAndLat = JSON.parse('${requestScope.lngAndLat}')
	var map = new BMap.Map("allmap");
	map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);
	map.enableScrollWheelZoom(true);
	
	var p1 = new BMap.Point(lngAndLat.product_lngAndLat[0],lngAndLat.product_lngAndLat[1]);
	var p2 = new BMap.Point(lngAndLat.user_lngAndLat[0],lngAndLat.user_lngAndLat[1]);
	
	var path = []
	path.push(new BMap.Point(lngAndLat.product_lngAndLat[0],lngAndLat.product_lngAndLat[1]))
	path.push(new BMap.Point(lngAndLat.user_lngAndLat[0],lngAndLat.user_lngAndLat[1]))
	
	
	var driving = new BMap.DrivingRoute(map, {renderOptions:{map: map, autoViewport: true}});
	driving.search(p1, p2,{waypoints:path});//waypoints表示途经点

}

</script>
</body>
</html>
