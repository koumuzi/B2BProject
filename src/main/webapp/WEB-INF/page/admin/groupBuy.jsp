<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
.table_normal_div{
    position: relative;
    min-height: 0px;
}
</style>
<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=4pfUa6c0Fpum3lwQYvaXSNakvbawYRgq&callback=init"></script>
<script>
        //检索数据集
         var dataList = {
            "productOrder_code": null,
            "productOrder_post": null,
            "productOrder_status_array": null,
            "orderBy": null,
            "isDesc": true
        };
        $(function () {
            //刷新下拉框
            $('#select_product_category').selectpicker('refresh');
            /******
             * event
             ******/
            //点击查询按钮时
            $("#btn_product_submit").click(function () {
            	
                var gid = parseInt($("#select_product_category").val());
				x=document.getElementById("span_order_receiver");  // 找到元素
				x.innerHTML=gid;
              
                //产品状态数组
       
                getData($(this), "admin/groupBuy/"+gid);
            });
            //点击刷新按钮时
            $("#btn_product_refresh").click(function () {
                //清除数据
                dataList.product_name = null;
                dataList.category_id = null;
                dataList.product_sale_price = null;
                dataList.product_price = null;
                dataList.product_isEnabled_array = null;
                dataList.orderBy = null;
                dataList.isDesc = true;
                //获取数据
                getData($(this), "admin/groupBuy/"+gid);
                //清除排序样式
                var table = $("#table_product_list");
                table.find("span.orderByDesc,span.orderByAsc").css("opacity","0");
                table.find("th.data_info").attr("data-sort","asc");
            });
            //点击th排序时
            $("th.data_info").click(function () {
                var table = $("#table_product_list");
                if(table.find(">tbody>tr").length <= 1){
                    return;
                }
                //获取排序字段
                dataList.orderBy = $(this).attr("data-name");
                //是否倒序排序
                dataList.isDesc = $(this).attr("data-sort")==="asc";

               
                //设置排序
                table.find("span.orderByDesc,span.orderByAsc").css("opacity","0");
                if(dataList.isDesc){
                    $(this).attr("data-sort","desc").children(".orderByAsc.orderBySelect").removeClass("orderBySelect").css("opacity","1");
                    $(this).children(".orderByDesc").addClass("orderBySelect").css("opacity","1");
                } else {
                    $(this).attr("data-sort","asc").children(".orderByDesc.orderBySelect").removeClass("orderBySelect").css("opacity","1");
                    $(this).children(".orderByAsc").addClass("orderBySelect").css("opacity","1");
                }
            });
            //点击table中的数据时
            $("#table_product_list").find(">tbody>tr").click(function () {
                trDataStyle($(this));
            });
        });
        //获取产品数据
        function getData(object,url) {
        	var table = $("#table_productOrder_list");
            var tbody = table.children("tbody").first();
            var tMap = document.getElementById("allmap")
 
            $.ajax({
                url: url,
                type: "get",
                traditional: true,
                success: function (data) {
                	var info = JSON.parse(data)
    				x=document.getElementById("span_order_address");  // 找到元素
    				x.innerHTML=info.product_info.product_address;
    				   //清空原有数据
                    tbody.empty();
                    tMap.innerHTML = "";
                    
                    //设置样式
                    $(".loader").css("display","none");
                    object.attr("disabled",false);
                    //显示订单统计数据
                    $("#productOrder_count_data").text(data.productOrderCount);
                    if (info.productOrderList.length > 0) {
                        for (var i = 0; i < info.productOrderList.length; i++) {
                            var productOrderStatusClass;
                            var productOrderStatusTitle;
                            var productOrderStatus;
                            switch (info.productOrderList[i].productOrder_status) {
                                case 0:
                                    productOrderStatusClass = "td_await";
                                    productOrderStatusTitle = "等待买家付款";
                                    productOrderStatus = "等待买家付款";
                                    break;
                                case 1:
                                    productOrderStatusClass = "td_warn";
                                    productOrderStatusTitle = "买家已付款，等待卖家发货";
                                    productOrderStatus = "等待卖家发货";
                                    break;
                                case 2:
                                    productOrderStatusClass = "td_wait";
                                    productOrderStatusTitle = "卖家已发货，等待买家确认";
                                    productOrderStatus = "等待买家确认";
                                    break;
                                case 3:
                                    productOrderStatusClass = "td_success";
                                    productOrderStatusTitle = "交易成功";
                                    productOrderStatus = "交易成功";
                                    break;
                                default:
                                    productOrderStatusClass = "td_error";
                                    productOrderStatusTitle = "交易关闭";
                                    productOrderStatus = "交易关闭";
                                    break;
                            }
                            var productOrder_id = info.productOrderList[i].productOrder_id;
                            var productOrder_code = info.productOrderList[i].productOrder_code;
                            var productOrder_post = info.productOrderList[i].productOrder_post;
                            var productOrder_receiver = info.productOrderList[i].productOrder_receiver;
                            var productOrder_mobile = info.productOrderList[i].productOrder_mobile;
                            var productOrder_userMessage = info.productOrderList[i].productOrder_userMessage;
                            //显示用户数据
                            tbody.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_productOrder_select_" + productOrder_id + "'><label for='cbx_productOrder_select_" + productOrder_id + "'></label></td><td title='" + productOrder_code + "'>" + productOrder_code + "</td><td title='" + productOrder_post + "'>" + productOrder_post + "</td><td title='" + productOrder_receiver + "'>" + productOrder_receiver + "</td><td title='" + productOrder_mobile + "'>" + productOrder_mobile + "</td><td><span class='" + productOrderStatusClass + "' title= '" + productOrderStatusTitle + "'>" + productOrderStatus + "</span></td><td><span class='td_special' title='查看订单详情'><a href='javascript:void(0)' onclick='getChildPage(this)'>详情</a></span></td><td hidden class='order_id'>" + productOrder_id + "</td></tr>");
                        }
                        //绑定事件
                        tbody.children("tr").click(function () {
                            trDataStyle($(this));
                        });
                    }
                    var order_address = info.order_address
					var map = new BMap.Map("allmap");
                    if (order_address.length>0) {
                    	map.centerAndZoom(new BMap.Point(order_address[0].product_lng,order_address[0].product_lat), 11);
                    	}
		        	map.enableScrollWheelZoom(true);
		        	map.addControl(new BMap.NavigationControl());               // 添加平移缩放控件  
		        	map.addControl(new BMap.ScaleControl());                    // 添加比例尺控件  
		        	map.addControl(new BMap.OverviewMapControl());     
		        	
		        	for (var i=0;i<order_address.length;i++)
		        	{
		        		var start = new BMap.Point(order_address[i].product_lng,order_address[i].product_lat);
		            	var end = new BMap.Point(order_address[i].city_lng,order_address[i].city_lat);
		            	var pause2 = new BMap.Point(order_address[i].cuntry_lng,order_address[i].cuntry_lat)
		            	var driving = new BMap.DrivingRoute(map, {renderOptions:{map: map, autoViewport: true}})
		            	driving.search(start, end,{waypoints:[pause2]});//waypoints表示途经点
		            	 
		        	}
                },
                beforeSend: function () {
                    $(".loader").css("display","block");
                    object.attr("disabled",true);
                },
                error: function () {

                }
            });
        }

        //获取订单子界面
        function getChildPage(obj) {
            //设置样式
            $("#div_home_title").children("span").text("订单详情");
            document.title = "大创项目管理后台 - 订单详情";
            //ajax请求页面
            ajaxUtil.getPage("order/" + $(obj).parents("tr").find(".order_id").text(), null, true);
        }

       
        
        window.init = function(){  
        	
        	var order_address = [
        			<c:forEach items="${requestScope.order_address}" var="order"> 
        			{
        				product_lng:"${order.product_lng}",
        			 	product_lat:"${order.product_lat}",
        			 	province_lng:"${order.province_lng}",
        			 	province_lat:"${order.province_lat}",
        			 	cuntry_lng:"${order.cuntry_lng}",
        			 	cuntry_lat:"${order.cuntry_lat}",
        			 	city_lng:"${order.city_lng}",
        			 	city_lat:"${order.city_lat}"	
        			},
    			
    				</c:forEach>];
        	var map = new BMap.Map("allmap");
        	if (order_address.length>0) {
        	map.centerAndZoom(new BMap.Point(order_address[0].product_lng,order_address[0].product_lat), 11);
        	}
        	map.enableScrollWheelZoom(true);
        	map.addControl(new BMap.NavigationControl());               // 添加平移缩放控件  
        	map.addControl(new BMap.ScaleControl());                    // 添加比例尺控件  
        	map.addControl(new BMap.OverviewMapControl());              //添加缩略地图控件  
        	for (var i=0;i<order_address.length;i++)
        	{
        		
        		var start = new BMap.Point(order_address[i].product_lng,order_address[i].product_lat);
            	var end = new BMap.Point(order_address[i].city_lng,order_address[i].city_lat);
            	
            	var pause2 = new BMap.Point(order_address[i].cuntry_lng,order_address[i].cuntry_lat)
            
            	var driving = new BMap.DrivingRoute(map, {renderOptions:{map: map, autoViewport: true}})
            	
            	driving.search(start, end,{waypoints:[pause2]},{strokeColor:"blue", strokeWeight:20, strokeOpacity:1});//waypoints表示途经点
        	}
        
			
        	
        }
    </script>
</head>
<body>
<div style="height: 1000px; wight:1000px;overflow-y:scroll" >
<div class="frm_div text_info">
    <div class="frm_group">
        <label class="frm_label" id="lbl_product_category_id" for="select_product_category">团号</label>
        <select class="selectpicker" id="select_product_category" data-size="10">
            <c:forEach items="${requestScope.groupid}" var="category">
                <option value="${category}">${category}</option>
            </c:forEach>
        </select>
        <input class="frm_btn" id="btn_product_submit" type="button" value="查询"/>
        <input class="frm_btn frm_clear" id="btn_clear" type="button" value="重置"/>
    </div>
</div>
<div class="details_div">
    <span class="details_title text_info">基本信息</span>
    <div class="frm_div">
        <label class="frm_label text_info" id="lbl_order_receiver">团号</label>
        <span class="details_value" id="span_order_receiver">1</span>
    </div>
    <div class="frm_div">
        <label class="frm_label text_info" id="lbl_order_address">发货地址</label>
        <span class="details_value details_value_noRows"
              id="span_order_address">${requestScope.product_info.product_address}</span>
    </div>
    </div>
<div class="details_div">
    <span class="details_title text_info">子订单</span>
   </div>
<div class="table_normal_div">
    <table class="table_normal" id="table_productOrder_list">
    <thead class="text_info">
    <tr>
        <th><input type="checkbox" class="cbx_select" id="cbx_select_all"><label for="cbx_select_all"></label></th>
        <th class="data_info" data-sort="asc" data-name="productOrder_code">
            <span>订单号</span>
            <span class="orderByDesc"></span>
            <span class="orderByAsc orderBySelect"></span>
        </th>
        <th class="data_info" data-sort="asc" data-name="productOrder_post">
            <span>邮政编码</span>
            <span class="orderByDesc"></span>
            <span class="orderByAsc orderBySelect"></span>
        </th>
        <th>收货人</th>
        <th>联系方式</th>
        <th class="data_info" data-sort="asc" data-name="productOrder_status">
            <span>订单状态</span>
            <span class="orderByDesc"></span>
            <span class="orderByAsc orderBySelect"></span>
        </th>
        <th>操作</th>
        <th hidden>订单ID</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${requestScope.productOrderList}" var="productOrder">
        <tr>
            <td><input type="checkbox" class="cbx_select" id="cbx_productOrder_select_${productOrder.productOrder_id}"><label for="cbx_productOrder_select_${productOrder.productOrder_id}"></label></td>
            <td title="${productOrder.productOrder_code}">${productOrder.productOrder_code}</td>
            <td title="${productOrder.productOrder_post}">${productOrder.productOrder_post}</td>
            <td title="${productOrder.productOrder_receiver}">${productOrder.productOrder_receiver}</td>
            <td title="${productOrder.productOrder_mobile}">${productOrder.productOrder_mobile}</td>
            <td>
                <c:choose>
                    <c:when test="${productOrder.productOrder_status==0}">
                        <span class="td_await" title="等待买家付款">等待买家付款</span>
                    </c:when>
                    <c:when test="${productOrder.productOrder_status==1}">
                        <span class="td_warn" title="买家已付款，等待卖家发货">等待卖家发货</span>
                    </c:when>
                    <c:when test="${productOrder.productOrder_status==2}">
                        <span class="td_wait" title="卖家已发货，等待买家确认">等待买家确认</span>
                    </c:when>
                    <c:when test="${productOrder.productOrder_status==3}">
                        <span class="td_success" title="交易成功">交易成功</span>
                    </c:when>
                    <c:otherwise><span class="td_error" title="交易关闭">交易关闭</span></c:otherwise>
                </c:choose>
            </td>
            <td><span class="td_special" title="查看订单详情"><a href="javascript:void(0)" onclick="getChildPage(this)">详情</a></span>
            </td>
            <td hidden class="order_id">${productOrder.productOrder_id}</td>
        </tr>
    </c:forEach>
    </tbody>
     </table>
     </div>
    <div class="details_div">
    	<span class="details_title text_info">物流信息</span>
    </div>
     <div id="allmap" style="width: 60%;height: 1000px; }"></div>
     </div>
</body>
</html>