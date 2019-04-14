package com.xq.tmall.service;

import java.util.List;

import com.alibaba.fastjson.JSONObject;



public interface RoutePlanningService {

	JSONObject getlongitudeAndlat(String province, String city, String country,int pid);
	
	 List<Object> getGroupBuyInfoByGroupId(int gid);
	
	List<Integer> getGroupBuyId();
}
