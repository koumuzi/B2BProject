package com.xq.tmall.controller.admin;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.controller.BaseController;
import com.xq.tmall.entity.Group;
import com.xq.tmall.entity.ProductOrder;
import com.xq.tmall.service.RoutePlanningService;

@Controller
public class RoutePlanningController  extends BaseController  {
	 private static final int ProductOrder = 0;
	@Resource(name = "routePlanningService")
	private RoutePlanningService routePlanningService;
	
	@RequestMapping(value = "admin/product/RoutingPlanning/{pid}")
	public String getMap(@PathVariable int pid,@RequestParam("place") String place,HttpSession session,Map<String, Object> map) {
		logger.info("检查管理员权限");
        Object adminId = checkAdmin(session);
        if (adminId == null) {
            return "redirect:/admin/login";
        }
	
		String[] address = place.split(" ");
		String province = null;
		String city = null;
		String country = null;
		if (address.length==4) {
			province = address[0];
			city = address[1];
			country = address[2];
		} else if (address.length==3) {
			province = address[0];
			city = address[1];
		} else if (address.length==2) {
			province = address[0];
		}
		
		JSONObject json = routePlanningService.getlongitudeAndlat(province, city, country, pid);
		map.put("lngAndLat", json);
		return  "admin/maptest";
	}	
	
	@RequestMapping(value = "admin/mapTest")
	public String getMapTest() {
		
		return  "admin/maptest";
	}
	
	
	@RequestMapping(value = "admin/groupBuy")
	public String getGroupBuy(Map<String, Object> map,HttpSession session) {
		
		map.put("groupid",routePlanningService.getGroupBuyId());
		getGroupBuyInfoByGroupId(1, map, session);
		return  "admin/groupBuy";
	}
	public String getGroupBuyInfoByGroupId(@PathVariable int gid,Map<String, Object> map,HttpSession session) {
		
		 logger.info("检查管理员权限");
	        Object adminId = checkAdmin(session);
	        if (adminId == null) {
	            return "redirect:/admin/login";
	        }
	        
	        List<Object> res =routePlanningService.getGroupBuyInfoByGroupId(gid);
	        map.put("product_info",(Map<String,String>)res.get(0));
	        map.put("productOrderList", (List<ProductOrder>)res.get(1));
	        map.put("order_address", (List<Map<String,String>>)res.get(2));
	        JSONObject json = JSONObject.parseObject(JSON.toJSONString(map));
		return  "admin/groupBuy";
	}
	
	@ResponseBody
	@RequestMapping(value = "admin/groupBuy/{gid}",produces = {"application/text;charset=UTF-8"})
	public String getGroupBuyInfoByGroupIdAjax(@PathVariable int gid,Map<String, Object> map,HttpSession session) {
		 logger.info("检查管理员权限");
	        Object adminId = checkAdmin(session);
	        if (adminId == null) {
	            return "redirect:/admin/login";
	        }
	        
	        List<Object> res =routePlanningService.getGroupBuyInfoByGroupId(gid);
	        map.put("product_info", res.get(0));
	        map.put("productOrderList", res.get(1));
	        map.put("order_address", res.get(2));
	        JSONObject json = JSONObject.parseObject(JSON.toJSONString(map));
		return  json.toJSONString();
	}
	
	
	
	
}
