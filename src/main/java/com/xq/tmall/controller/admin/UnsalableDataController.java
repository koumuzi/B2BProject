package com.xq.tmall.controller.admin;

import java.text.ParseException;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xq.tmall.service.UnsalableDataService;;

public class UnsalableDataController{
	@Resource(name = "unsalableDataServer")
	private UnsalableDataService unsalableDataServer = null;

	
	@RequestMapping(value ="admin/unsalableData")
    public String getUnsalableData(Map<String, Object> map) {   	
    	return "admin/unsalableData";
    }
	
	 @ResponseBody
	    @RequestMapping(value = "admin/home/datamap", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	    public String getFormProduceData(Map<String, Object> map) throws ParseException {
	            return unsalableDataServer.getUnsalableData().toJSONString();
	    }

}
