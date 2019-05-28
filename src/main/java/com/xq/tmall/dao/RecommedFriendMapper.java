package com.xq.tmall.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.xq.tmall.entity.Product;
import com.xq.tmall.entity.User;

public interface RecommedFriendMapper {
	
	List<String> selectProvince();
	
	List<User> selectFriendsByProvince(@Param("province") String province);
	
	List<Product> selectProductByFriendUser(@Param("users_id") List<String> users_id);

}
