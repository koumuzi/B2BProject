package com.xq.tmall.service;

import java.util.List;
import java.util.Map;

import com.xq.tmall.entity.User;

public interface RecommendFriendServer {
	
	public abstract List<String> getProvinceInfo();
	
	public abstract Map getRecommend(String province_name);

}
