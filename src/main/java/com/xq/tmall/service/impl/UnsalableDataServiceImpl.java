package com.xq.tmall.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.dao.UnsalableDataMapper;
import com.xq.tmall.entity.UnsalableInfo;
import com.xq.tmall.service.UnsalableDataService;

@Service("unsalableDataService")
public class UnsalableDataServiceImpl implements UnsalableDataService{

    private UnsalableDataMapper unsalableDataMapper;
    
    @Resource(name="unsalableDataMapper")
     public void setUnsalableDataMapper(UnsalableDataMapper unsalableDataMapper) {
		this.unsalableDataMapper = unsalableDataMapper;
	}
    
	@Override
	public JSONObject getUnsalableData() {
		// TODO Auto-generated method stub
        JSONObject jsonObject=new JSONObject();
        List<UnsalableInfo> UnsalableInfo=unsalableDataMapper.getUnsalableInfos();
        
        List<Map<String, String>> counts=new ArrayList<>();
        
    	Map<String,Double[]>  lngLat= new HashMap<String, Double[]>();
		for (UnsalableInfo user : UnsalableInfo) {
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
		jsonObject.put("geoCoordMap", JSON.toJSONString(lngLat));
		jsonObject.put("count_data", JSON.toJSONString(counts));

		return jsonObject;
	}
	

}
