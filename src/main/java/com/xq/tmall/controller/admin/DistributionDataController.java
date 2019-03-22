package com.xq.tmall.controller.admin;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.service.DistributionDataServer;

/**
 * 负责处理销售地区分布，用户分布等数据的ajex请求
 * @author 魏达
 *
 */
@Controller
public class DistributionDataController {
	
	@Resource(name = "distributionDataServer")
	private DistributionDataServer distributionDataServer = null;

	
	@RequestMapping(value ="admin/RegionalDistribution")
    public String getDistributionDate(Map<String, Object> map) {
    	
    	map.put("Distribution", distributionDataServer.getUserDistributionData().toJSONString());
    	
    	return "admin/regionalDistribution";
    }
	
	 @ResponseBody
	    @RequestMapping(value = "admin/home/consumer", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	    public String getConsumerDistributionData(Map<String, Object> map) throws ParseException {
	            return distributionDataServer.getUserDistributionData().toJSONString();
	    }
}
