package com.xq.tmall.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.dao.RoutePlanningMapper;
import com.xq.tmall.entity.Group;
import com.xq.tmall.entity.Position;
import com.xq.tmall.entity.ProductOrder;
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


	@Override
	public List<Object> getGroupBuyInfoByGroupId(int gid) {
		
		JSONObject json = new JSONObject();
		List<Group> group_info = routePlanningMapper.getGroupBuyInfo(gid); 
		List<ProductOrder> productOrderList = new ArrayList<ProductOrder>();
		List<Map<String,String>> order_address = new ArrayList<Map<String,String>>();
		Map<String,String> product_info = new HashMap<String,String>();
	       
		product_info.put("product_address",group_info.get(0).getProduct_address_name()+" "+group_info.get(0).getProduct_shortname()+" "+ group_info.get(0).getProduct_place_name());
		
		for (Group group: group_info) {
			ProductOrder tem = new ProductOrder();
			tem.setProductOrder_id(group.getProductorder_id());
			tem.setProductOrder_code(group.getProductorder_code());
			tem.setProductOrder_post(group.getProductorder_post());
			tem.setProductOrder_receiver(group.getProductorder_receiver());
			tem.setProductOrder_mobile(group.getProductorder_mobile());
			tem.setProductOrder_status(group.getProductorder_status());
			productOrderList.add(tem);
			Map<String,String> map = new HashMap<String,String>();
			map.put("product_lng", group.getProduct_lng());
			map.put("product_lat", group.getProduct_lat());
			map.put("province_lng", group.getProvince_lng());
			map.put("province_lng", group.getProduct_lat());
			map.put("cuntry_lng", group.getCuntry_lng());
			map.put("cuntry_lat",group.getCuntry_lat());
			map.put("city_lng",group.getCity_lng());
			map.put("city_lat",group.getCity_lat());
			order_address.add(map);
		}
		List<Object> res = new ArrayList<Object>();
		res.add(product_info);
		res.add(productOrderList);
		res.add(order_address);	
		return res;
	}


	@Override
	public List<Integer> getGroupBuyId() {
		
		return routePlanningMapper.getGroupBuyId();
	}

}
