package com.xq.tmall.dao;

import org.apache.ibatis.annotations.Param;

import com.xq.tmall.entity.Position;

public interface RoutePlanningMapper {
			 
	Position getlongitudeAndlatitudeOfUser(@Param("province") String province ,@Param("city") String city,@Param("country") String country);
	
	Position getlongitudeAndlatitudeOfProduct(@Param("pid") int pid);

}
