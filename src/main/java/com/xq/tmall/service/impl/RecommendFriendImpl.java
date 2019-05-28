package com.xq.tmall.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.xq.tmall.dao.RecommedFriendMapper;
import com.xq.tmall.entity.Product;
import com.xq.tmall.entity.User;
import com.xq.tmall.service.RecommendFriendServer;

@Service("recommendFriendServer")
public class RecommendFriendImpl implements RecommendFriendServer {

	@Resource(name="recommedFriendMapper")
	private RecommedFriendMapper recommedFriendMapper;
	
	@Override
	public List<String> getProvinceInfo() {
		
		return recommedFriendMapper.selectProvince();
	}

	@Override
	public Map getRecommend(String province_name) {
		Map<Object,Object> map = new HashMap<Object, Object>();
		List<User> users = recommedFriendMapper.selectFriendsByProvince(province_name);
		map.put("userList", recommedFriendMapper.selectFriendsByProvince(province_name));
		List<String> users_id = new ArrayList<String>();
		for (User user: users) {
			users_id.add(String.valueOf(user.getUser_id()));
		}
		if (users_id.size() >0 ) {
			//System.out.print(recommedFriendMapper.selectProductByFriendUser(users_id));
			map.put("productList", recommedFriendMapper.selectProductByFriendUser(users_id));
		} else {
			map.put("productList",new ArrayList<Product>());
		}
		
		return map;
	}

}
