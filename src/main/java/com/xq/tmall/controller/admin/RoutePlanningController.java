package com.xq.tmall.controller.admin;


import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.controller.BaseController;
import com.xq.tmall.service.RoutePlanningService;

@Controller
public class RoutePlanningController  extends BaseController  {
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
		return  "admin/map";
	}	
	
}
