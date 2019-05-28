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
		    "product_name": null,
		    "category_id": null,
		    "product_sale_price": null,
		    "product_price": null,
		    "product_isEnabled_array": null,
		    "orderBy": null,
		    "isDesc": true
		};
        $(function () {
        	getData($(this), "admin/recommendFriend/北京");
            //刷新下拉框
            $('#select_product_category').selectpicker('refresh');
            /******
             * event
             ******/
            //点击查询按钮时
            $("#btn_product_submit").click(function () {
            	
                var province = $("#select_product_category").val();
				console.log(province)
              
                //产品状态数组
       
                getData($(this), "admin/recommendFriend/"+province);
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
                getData($(this), "admin/recommendFriend/"+province);
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
        //获取用户数据
        function getData(object,url) {
            var table_user = $("#table_user_list");
            var tbody_user = table_user.children("tbody").first();
            
            var table_product = $("#table_product_list");
            var tbody_product = table_product.children("tbody").first();
            $.ajax({
                url: url,
                type: "get",
                traditional: true,
                success: function (data) {
                    //清空原有数据
                    tbody_user.empty();
                    tbody_product.empty();
                    data = JSON.parse(data)
                    //console.log(data);
                    //设置样式
                    $(".loader").css("display","none");
                    object.attr("disabled",false);
                
                    if (data.userList.length > 0) {
                        for (var i = 0; i < data.userList.length; i++) {
                            var gender;
                            if (data.userList[i].user_gender === 0) {
                                gender = "男";
                            } else {
                                gender = "女";
                            }
                            var user_id = data.userList[i].user_id;
                            var user_name = data.userList[i].user_name;
                            var user_nickname = data.userList[i].user_nickname;
                            var user_realname = data.userList[i].user_realname;
                            var user_birthday = data.userList[i].user_birthday;
                            //显示用户数据
                            tbody_user.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_user_select_" + user_id + "'><label for='cbx_user_select_" + user_id + "'></label></td><td title='" + user_name + "'>" + user_name + "</td><td title='" + user_nickname + "'>" + user_nickname + "</td><td title='" + user_realname + "'>" + user_realname + "</td><td title='" + user_birthday + "'>" + user_birthday + "</td><td title='" + gender + "'>" + gender + "</td><td><span class='td_special' title='查看用户详情'><a href='javascript:void(0);' onclick='getChildPage(this)'>详情</a></span></td><td hidden  class='user_id'>" + user_id + "</td></tr>");
                        }
                        //绑定事件
                        tbody_user.children("tr").click(function () {
                            trDataStyle($(this));
                        });
                    }
                    //console.log(data.productList);
                    if (data.productList.length > 0) {
                        for (var i = 0; i < data.productList.length; i++) {
                            var isEnabledClass;
                            var isEnabledTitle;
                            var isEnabled;
                            switch (data.productList[i].product_isEnabled) {
                                case 0:
                                    isEnabledClass = "td_success";
                                    isEnabledTitle = "产品正常销售中";
                                    isEnabled = "销售中";
                                    break;
                                case 2:
                                    isEnabledClass = "td_warn";
                                    isEnabledTitle = "产品显示在主页促销中";
                                    isEnabled = "促销中";
                                    break;
                                default:
                                    isEnabledClass = "td_error";
                                    isEnabledTitle = "产品缺货或违规停售中";
                                    isEnabled = "停售中";
                                    break;
                            }
                            var product_price = data.productList[i].product_price.toFixed(1);
                            var product_sale_price = data.productList[i].product_sale_price.toFixed(1);
                            var product_id = data.productList[i].product_id;
                            var product_name = data.productList[i].product_name;
                            var product_title = data.productList[i].product_title;
                            var product_create_date = data.productList[i].product_create_date;
                            //显示产品数据
                            tbody_product.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_product_select_" + product_id + "'><label for='cbx_product_select_" + product_id + "'></label></td><td title='"+product_name+"'>" + product_name + "</td><td title='"+product_title+"'>" + product_title + "</td><td title='"+product_price+"'>" + product_price + "</td><td title='"+product_sale_price+"'>" + product_sale_price + "</td><td title='"+product_create_date+"'>" + product_create_date + "</td><td><span class='" + isEnabledClass + "' title='"+isEnabledTitle+"'>"+ isEnabled + "</span></td><td><span class='td_special' title='查看产品详情'><a href='javascript:void(0);' onclick='getChildPage(this)'>详情</a></span></td><td><span class='td_special' title='查看产品详情'><a href='javascript:void(0);' onclick='delet(this)'>删除</a></span></td><td></tr><span class='product_id'>" + product_id + "</span></td></tr>");
                        }
                        //绑定事件
                        tbody_product.children("tr").click(function () {
                            trDataStyle($(this));
                        });
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
        
        
      //获取用户子界面
        function getChildPage(obj) {
            //设置样式
            $("#div_home_title").children("span").text("用户详情");
            document.title = "大创项目管理后台 - 用户详情";
            //ajax请求页面
            ajaxUtil.getPage("user/" + $(obj).parents("tr").find(".user_id").text(), null, true);
        }

    </script>
</head>
<body>
<div style="height: 1000px; wight:1000px;overflow-y:scroll" >
<div class="frm_div text_info">
    <div class="frm_group">
        <label class="frm_label" id="lbl_product_category_id" for="select_product_category">地区</label>
        <select class="selectpicker" id="select_product_category" data-size="10">
            <c:forEach items="${requestScope.province_name}" var="province">
                <option value="${province}">${province}</option>
            </c:forEach>
        </select>
        <input class="frm_btn" id="btn_product_submit" type="button" value="查询"/>
        <input class="frm_btn frm_clear" id="btn_clear" type="button" value="重置"/>
    </div>
</div>
<div class="details_div">
    <span class="details_title text_info">潜在好友</span>
   </div>
<div class="table_normal_div">
    <table class="table_normal" id="table_user_list">
        <thead class="text_info">
        <tr>
            <th><input type="checkbox" class="cbx_select" id="cbx_select_all"><label for="cbx_select_all"></label></th>
            <th class="data_info" data-sort="asc" data-name="user_name">
                <span>用户名</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="user_nickname">
                <span>昵称</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="user_realname">
                <span>姓名</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="user_birthday">
                <span>出生日期</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="user_gender">
                <span>性别</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th>操作</th>
            <th hidden>用户ID</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
<div class="details_div">
    <span class="details_title text_info">推荐商品</span>
   </div>
<div class="table_normal_div">
    <table class="table_normal" id="table_product_list">
        <thead class="text_info">
        <tr>
            <th><input type="checkbox" class="cbx_select" id="cbx_select_all"><label for="cbx_select_all"></label></th>
            <th class="data_info" data-sort="asc" data-name="product_name">
                <span>产品名称</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="product_title">
                <span>产品标题</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="product_price">
                <span>原价</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="product_sale_price">
                <span>促销价</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="product_create_date">
                <span>创建时间</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th class="data_info" data-sort="asc" data-name="product_isEnabled">
                <span>上架状态</span>
                <span class="orderByDesc"></span>
                <span class="orderByAsc orderBySelect"></span>
            </th>
            <th>操作</th>
            <th>删除产品</th>
            <th hidden>产品ID</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
    </table>
</div>
</body>
</html>