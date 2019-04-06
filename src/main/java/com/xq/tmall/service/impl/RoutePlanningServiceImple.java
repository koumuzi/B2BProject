package com.xq.tmall.service.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.dao.RoutePlanningMapper;
import com.xq.tmall.entity.Position;
import com.xq.tmall.service.RoutePlanningService;

@Service("routePlanningService")
public class RoutePlanningServiceImple implements RoutePlanningService {

	@Autowired
	private RoutePlanningMapper routePlanningMapper;
	
	private double[] getlongitudeAndlatitudeOfUser(String province, String city, String country) {
		
		Position position = routePlanningMapper.getlongitudeAndlatitudeOfUser(province, city, country);
		double[] lnanlaString = new double[2];

		if (position == null) {
			lnanlaString[0] = 116.303843;
			lnanlaString[1] = 39.983412;
			return lnanlaString;
		} 
		lnanlaString[0] = position.getLng();
		lnanlaString[1] = position.getLat();
		return lnanlaString;
	}

	
	private double[] getlongitudeAndlatitudeOfProduct(int pid) {
	
		Position position = routePlanningMapper.getlongitudeAndlatitudeOfProduct(pid);
		double[] lnanlaString = new double[2];

		if (position == null) {
			lnanlaString[0] = 116.303843;
			lnanlaString[1] = 39.983412;
			return lnanlaString;
		} 
		lnanlaString[0] = position.getLng();
		lnanlaString[1] = position.getLat();
		return lnanlaString;
	}

	@Override
	public JSONObject getlongitudeAndlat(String province, String city, String country,int pid) {
		JSONObject json = new JSONObject();
		
		json.put("product_lngAndLat", JSONArray.parseArray(JSON.toJSONString(getlongitudeAndlatitudeOfProduct(pid))));
		json.put("user_lngAndLat", JSONArray.parseArray(JSON.toJSONString(getlongitudeAndlatitudeOfUser(province,city,country))));
		
		return json;
	}

}
