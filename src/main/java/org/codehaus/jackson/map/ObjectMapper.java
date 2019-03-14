package org.codehaus.jackson.map;

import java.util.List;

import com.alibaba.fastjson.JSON;
import com.xq.tmall.service.ProductTest;

public class ObjectMapper {

	public String writeValueAsString(List<ProductTest> list) {
		// TODO Auto-generated method stub
		 String jsons = JSON.toJSONString(list);
	        return jsons;
	}

}
