package com.xq.tmall.controller.admin;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.xq.tmall.controller.BaseController;
import com.xq.tmall.entity.Admin;
import com.xq.tmall.entity.OrderGroup;
import com.xq.tmall.entity.ProductSale;
import com.xq.tmall.service.AdminService;
import com.xq.tmall.service.ProductOrderService;
import com.xq.tmall.service.ProductService;
import com.xq.tmall.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
/**
 * 后台管理-主页
 */
@Controller
public class AdminHomeController extends BaseController {
    @Resource(name = "adminService")
    private AdminService adminService;
    @Resource(name = "productOrderService")
    private ProductOrderService productOrderService;
    @Resource(name = "productService")
    private ProductService productService;
    @Resource(name = "userService")
    private UserService userService;

    @RequestMapping(value ="admin/saleStatistics")
    public String getSaleStatistics() {
    	return "admin/saleStatistics";
    }
    @RequestMapping(value ="admin/productSellYear")
    public String getTestEcharts() {
    	return "admin/productSellYear";
    }
    @RequestMapping(value ="admin/zout")
    public String getZout() {
    	return "admin/zout";
    }
    @RequestMapping(value ="admin/powerBI")
    public String getBeijingMap() {
    	return "admin/powerBI";
    }

	
    //转到后台管理-主页
    @RequestMapping(value = "admin", method = RequestMethod.GET)
    public String goToPage(HttpSession session, Map<String, Object> map) throws ParseException {
        logger.info("检查管理员权限");
        Object adminId = checkAdmin(session);
        if (adminId == null) {
            return "redirect:/admin/login";
        }

        logger.info("获取管理员信息");
        Admin admin = adminService.get(null, Integer.parseInt(adminId.toString()));
        map.put("admin", admin);
        logger.info("获取统计信息");
        Integer productTotal = productService.getTotal(null, new Byte[]{0, 2});
        Integer userTotal = userService.getTotal(null);
        Integer orderTotal = productOrderService.getTotal(null, new Byte[]{3});
        logger.info("获取图表信息");
        map.put("jsonObject", getChartData(null,null));
        
        map.put("productTotal", productTotal);
        map.put("userTotal", userTotal);
        map.put("orderTotal", orderTotal);

        logger.info("转到后台管理-主页");
        return "admin/homePage";
    }

    //转到后台管理-主页-ajax
    @RequestMapping(value = "admin/home", method = RequestMethod.GET)
    public String goToPageByAjax(HttpSession session, Map<String, Object> map) throws ParseException {
        logger.info("检查管理员权限");
        Object adminId = checkAdmin(session);
        if (adminId == null) {
            return "admin/include/loginMessage";
        }

        logger.info("获取管理员信息");
        Admin admin = adminService.get(null, Integer.parseInt(adminId.toString()));
        map.put("admin", admin);
        logger.info("获取统计信息");
        Integer productTotal = productService.getTotal(null, new Byte[]{0, 2});
        Integer userTotal = userService.getTotal(null);
        Integer orderTotal = productOrderService.getTotal(null, new Byte[]{3});
        logger.info("获取图表信息");
        map.put("jsonObject", getChartData(null, null));
        logger.info("获取图表信息");
        map.put("jsonObject", getChartData(null,null));
        map.put("productTotal", productTotal);
        map.put("userTotal", userTotal);
        map.put("orderTotal", orderTotal);
        logger.info("转到后台管理-主页-ajax方式");
        return "admin/homeManagePage";
    }

    //按日期查询图表数据-ajax
    @ResponseBody
    @RequestMapping(value = "admin/home/charts", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getChartDataByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate) throws ParseException {
        if (beginDate != null && endDate != null) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getChartData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getChartData(null, null).toJSONString();
        }
    }
    
    //获取图表的JSON数据
    private JSONObject getChartData(Date beginDate,Date endDate) throws ParseException {
        JSONObject jsonObject = new JSONObject();
        SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd", Locale.UK);
        SimpleDateFormat timeSpecial = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.UK);
        if (beginDate == null || endDate == null) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -7);
            beginDate = time.parse(time.format(cal.getTime()));
            cal = Calendar.getInstance();
            endDate = cal.getTime();
        } else {
            beginDate = time.parse(time.format(beginDate));
            endDate = timeSpecial.parse(time.format(endDate) + " 23:59:59");
        }
        String[] dateStr = new String[7];
        SimpleDateFormat time2 = new SimpleDateFormat("MM/dd", Locale.UK);
        logger.info("获取时间段数组");
        for (int i = 0; i < dateStr.length; i++) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(beginDate);
            cal.add(Calendar.DATE, i);
            dateStr[i] = time2.format(cal.getTime());
        }
        logger.info("获取总交易额订单列表");
        List<OrderGroup> orderGroupList = productOrderService.getTotalByDate(beginDate, endDate);
        logger.info("根据订单状态分类");
        //总交易订单数组
        int[] orderTotalArray = new int[7];
        //未付款订单数组
        int[] orderUnpaidArray = new int[7];
        //未发货订单叔祖
        int[] orderNotShippedArray = new int[7];
        //未确认订单数组
        int[] orderUnconfirmedArray = new int[7];
        //交易成功数组
        int[] orderSuccessArray = new int[7];
        for (OrderGroup orderGroup : orderGroupList) {
            int index = 0;
            for (int j = 0; j < dateStr.length; j++) {
                if (dateStr[j].equals(orderGroup.getProductOrder_pay_date())) {
                    index = j;
                }
            }
            switch (orderGroup.getProductOrder_status()) {
                case 0:
                    orderUnpaidArray[index] = orderGroup.getProductOrder_count();
                    break;
                case 1:
                    orderNotShippedArray[index] = orderGroup.getProductOrder_count();
                    break;
                case 2:
                    orderUnconfirmedArray[index] = orderGroup.getProductOrder_count();
                    break;
                case 3:
                    orderSuccessArray[index] = orderGroup.getProductOrder_count();
                    break;
                default:
                    throw new RuntimeException("错误的订单类型!");
            }
        }
        logger.info("获取总交易订单数组");
        for (int i = 0; i < dateStr.length; i++) {
            orderTotalArray[i] = orderUnpaidArray[i] + orderNotShippedArray[i] + orderUnconfirmedArray[i] + orderSuccessArray[i];
        }
        logger.info("返回结果集map");
        jsonObject.put("orderTotalArray", JSONArray.parseArray(JSON.toJSONString(orderTotalArray)));
        jsonObject.put("orderUnpaidArray", JSONArray.parseArray(JSON.toJSONString(orderUnpaidArray)));
        jsonObject.put("orderNotShippedArray", JSONArray.parseArray(JSON.toJSONString(orderNotShippedArray)));
        jsonObject.put("orderUnconfirmedArray", JSONArray.parseArray(JSON.toJSONString(orderUnconfirmedArray)));
        jsonObject.put("orderSuccessArray", JSONArray.parseArray(JSON.toJSONString(orderSuccessArray)));
        jsonObject.put("dateStr",JSONArray.parseArray(JSON.toJSONString(dateStr)));
        return jsonObject;
    }

    //按日期查询图表数据-ajax
    @ResponseBody
    @RequestMapping(value = "admin/home/sale", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getSaleDataByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate,Map<String, Object> map) throws ParseException {
    
    	if (beginDate != null && endDate != null && beginDate.length()!=0 && endDate.length()!=0) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getSaleData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getSaleData(null, null).toJSONString();
        }
    }
    
    //获取图表的JSON数据
    private JSONObject getSaleData(Date beginDate,Date endDate) throws ParseException {
        JSONObject saleJson = new JSONObject();
        SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd", Locale.UK);
        SimpleDateFormat timeSpecial = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.UK);
        if (beginDate == null || endDate == null) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -7);
            beginDate = time.parse(time.format(cal.getTime()));
            cal = Calendar.getInstance();
            endDate = cal.getTime();
        } else {
            beginDate = time.parse(time.format(beginDate));
            endDate = timeSpecial.parse(time.format(endDate) + " 23:59:59");
        }
  
        SimpleDateFormat time2 = new SimpleDateFormat("MM/dd", Locale.UK);
        logger.info("获取时间段数组");
        
        logger.info("获取总交易额订单列表");
        
        List<ProductSale> ProductSaleGroup = productOrderService.getSaleByDate(beginDate, endDate);
        //List<ProductSale> ProductSaleVolume = productOrderService.getSaleVolumeByDate(beginDate, endDate);
        
        logger.info("根据订单状态分类");
        //产品种类
        List<String> categorylist = new ArrayList<>();
        //销售量
        List<Integer> salecountlist = new ArrayList<>();
        
        //Map<String,Double> saleVolume = new HashMap<String,Double>();
        for (ProductSale sale :ProductSaleGroup ) {
        	categorylist.add(sale.getProduct_category_name());
        	salecountlist.add(sale.getCount());
        }
        
//        for (ProductSale sale :ProductSaleVolume ) {
//        	saleVolume.put(sale.getProduct_category_name(), sale.getSalecolume());
//        }


        String[] category = new String[categorylist.size()];

        categorylist.toArray(category);
        
        int[] salecount = salecountlist.stream().mapToInt(Integer::intValue).toArray();

       // saleJson.put("saleVolume", saleVolume);
        
        
        saleJson.put("category", JSONArray.parseArray(JSON.toJSONString(category)));
        saleJson.put("salecount", JSONArray.parseArray(JSON.toJSONString(salecount)));
        return saleJson;
    }
  //按日期查询图表数据-ajax
    @ResponseBody
    @RequestMapping(value = "admin/home/sellYear", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getSellDataByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate,Map<String, Object> map) throws ParseException {
    
    	if (beginDate != null && endDate != null && beginDate.length()!=0 && endDate.length()!=0) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getSaleData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getSaleData(null, null).toJSONString();
        }
    }
    @ResponseBody
    @RequestMapping(value = "admin/home/map", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getMapByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate,Map<String, Object> map) throws ParseException {
    
    	if (beginDate != null && endDate != null && beginDate.length()!=0 && endDate.length()!=0) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getSaleData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getSaleData(null, null).toJSONString();
        }
    }
    
    @ResponseBody
    @RequestMapping(value = "admin/home/beijingMap", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getBeijingMapByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate,Map<String, Object> map) throws ParseException {
    
    	if (beginDate != null && endDate != null && beginDate.length()!=0 && endDate.length()!=0) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getSaleData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getSaleData(null, null).toJSONString();
        }
    }
    
    //获取图表的JSON数据
    private JSONObject getsellYearData(Date beginDate,Date endDate) throws ParseException {
        JSONObject sellJson = new JSONObject();
        SimpleDateFormat time = new SimpleDateFormat("yyyy", Locale.UK);
        SimpleDateFormat timeSpecial = new SimpleDateFormat("yyyy", Locale.UK);
        if (beginDate == null || endDate == null) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DATE, -365);
            beginDate = time.parse(time.format(cal.getTime()));
            cal = Calendar.getInstance();
            endDate = cal.getTime();
        } else {
            beginDate = time.parse(time.format(beginDate));
            endDate = timeSpecial.parse(time.format(endDate) + " 23:59:59");
        }
  
        SimpleDateFormat time2 = new SimpleDateFormat("MM/dd", Locale.UK);
        logger.info("获取时间段数组");
        
        logger.info("获取总交易额订单列表");
        List<ProductSale> ProductSaleGroup = productOrderService.getSaleByDate(beginDate, endDate);
        logger.info("根据订单状态分类");
        //产品种类
        List<String> categorylist = new ArrayList<>();
        //销售量
        List<Integer> salecountlist = new ArrayList<>();
        
        for (ProductSale sale :ProductSaleGroup ) {
        	categorylist.add(sale.getProduct_category_name());
        	salecountlist.add(sale.getCount());
        }
        String[] category = new String[categorylist.size()];
        categorylist.toArray(category);
        int[] salecount = salecountlist.stream().mapToInt(Integer::intValue).toArray();
        sellJson.put("category", JSONArray.parseArray(JSON.toJSONString(category)));
        sellJson.put("salecount", JSONArray.parseArray(JSON.toJSONString(salecount)));
        return sellJson;
    }
  //按日期查询图表数据-ajax
    @ResponseBody
    @RequestMapping(value = "admin/home/zout", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
    public String getzoutDataByDate(@RequestParam(required = false) String beginDate, @RequestParam(required = false) String endDate,Map<String, Object> map) throws ParseException {
        
    	if (beginDate != null && endDate != null && beginDate.length()!=0 && endDate.length()!=0) {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
            return getSaleData(simpleDateFormat.parse(beginDate), simpleDateFormat.parse(endDate)).toJSONString();
        } else {
            return getSaleData(null, null).toJSONString();
        }
    }
    
    //获取图表的JSON数据
    private JSONObject getzoutData(Date beginDate,Date endDate) throws ParseException {
    	 JSONObject zoutJson = new JSONObject();
         SimpleDateFormat time = new SimpleDateFormat("yyyy-MM-dd", Locale.UK);
         SimpleDateFormat timeSpecial = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.UK);
         if (beginDate == null || endDate == null) {
             Calendar cal = Calendar.getInstance();
             cal.add(Calendar.MONTH, -1);
             beginDate = time.parse(time.format(cal.getTime()));
             cal = Calendar.getInstance();
             endDate = cal.getTime();
         } else {
             beginDate = time.parse(time.format(beginDate));
             endDate = timeSpecial.parse(time.format(endDate) + " 23:59:59");
         }
   
  
        SimpleDateFormat time2 = new SimpleDateFormat("MM/dd", Locale.UK);
        logger.info("获取时间段数组");
        
        logger.info("获取总交易额订单列表");
        List<ProductSale> ProductSaleGroup = productOrderService.getSaleByDate(beginDate, endDate);
        logger.info("根据订单状态分类");
        //产品种类
        List<String> categorylist = new ArrayList<>();
        //销售量
        List<Integer> salecountlist = new ArrayList<>();
        
        for (ProductSale sale :ProductSaleGroup ) {
        	categorylist.add(sale.getProduct_category_name());
        	salecountlist.add(sale.getCount());
        }

        String[] category = new String[categorylist.size()];

        categorylist.toArray(category);
        
        int[] salecount = salecountlist.stream().mapToInt(Integer::intValue).toArray();

        zoutJson.put("category", JSONArray.parseArray(JSON.toJSONString(category)));
        zoutJson.put("salecount", JSONArray.parseArray(JSON.toJSONString(salecount)));
        return zoutJson;
    }
    
}