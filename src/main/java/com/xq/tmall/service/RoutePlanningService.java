package com.xq.tmall.service;

import com.alibaba.fastjson.JSONObject;



public interface RoutePlanningService {

	JSONObject getlongitudeAndlat(String province, String city, String country,int pid);
}
