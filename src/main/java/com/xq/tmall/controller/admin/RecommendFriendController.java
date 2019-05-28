package com.xq.tmall.controller.admin;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.controller.BaseController;
import com.xq.tmall.service.RecommendFriendServer;

@Controller
public class RecommendFriendController extends BaseController{
	
	@Resource(name = "recommendFriendServer")
	private RecommendFriendServer recommendFriendServer;
	
	@RequestMapping(value="admin/recommendFriend")
	public String get(Map<String, Object> map,HttpSession session) {
		logger.info("检查管理员权限");
        Object adminId = checkAdmin(session);
        if (adminId == null) {
            return "redirect:/admin/login";
        }
		map.put("province_name",recommendFriendServer.getProvinceInfo());
		return "admin/RecommendFriend";
	}
	
	@ResponseBody
	@RequestMapping(value = "admin/recommendFriend/{province_name}",produces = {"application/text;charset=UTF-8"})
	public String getRecommend(@PathVariable String province_name,HttpSession session) {
		logger.info("检查管理员权限");
        Object adminId = checkAdmin(session);
        if (adminId == null) {
            return "redirect:/admin/login";
        }
		JSONObject json = new JSONObject();
		return json.toJSONString(recommendFriendServer.getRecommend(province_name));
	}

}
