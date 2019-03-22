package com.xq.tmall.entity;

public class UserDistributionInfo {
	
	private String name;
	
	private Integer count;
	
	public Integer getCount() {
		return count;
	}

	public void setCount(Integer count) {
		this.count = count;
	}

	private Double lng;  //经度
	
	private Double lat;  //纬度
	

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	

	public Double getLng() {
		return lng;
	}

	public void setLng(Double lng) {
		this.lng = lng;
	}

	public Double getLat() {
		return lat;
	}

	public void setLat(Double lat) {
		this.lat = lat;
	}

	

}
