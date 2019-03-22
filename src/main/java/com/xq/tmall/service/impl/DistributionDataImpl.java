package com.xq.tmall.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.dao.DistributionDataMapper;
import com.xq.tmall.entity.UserDistributionInfo;
import com.xq.tmall.service.DistributionDataServer;

@Service("distributionDataServer")
public class DistributionDataImpl implements DistributionDataServer {

	
	private DistributionDataMapper distributionDataMapper;
	
	@Resource(name = "distributionDataMapper")
	public void setDistributionDataMapper(DistributionDataMapper distributionDataMapper) {
		this.distributionDataMapper = distributionDataMapper;
	}

	@Override
	public JSONObject getUserDistributionData() {
		JSONObject jsonobject = new JSONObject();
		List<UserDistributionInfo>  usersInfo =  distributionDataMapper.getUserDistributionData();
		//Map<Map<String, String>, Map<String, Integer>> count = new HashMap<Map<String,String>, Map<String,Integer>>();
		List<Map<String, String>> counts = new ArrayList<>();
		
		Map<String,Double[]>  lngLat= new HashMap<String, Double[]>();
		for (UserDistributionInfo user : usersInfo) {
			Map<String,String> count_info =  new HashMap<String, String>();
			count_info.put("name", user.getName());
			count_info.put("value", user.getCount().toString());
			counts.add(count_info);
			List<Double> dou = new ArrayList<Double>();
			dou.add(user.getLng());
			dou.add(user.getLat());
			Double[] countArray = new Double[dou.size()];
			dou.toArray(countArray);
			lngLat.put(user.getName(), countArray);
		}
		jsonobject.put("geoCoordMap", JSON.toJSONString(lngLat));
		jsonobject.put("data", JSON.toJSONString(counts));
		return jsonobject;
	}

}
