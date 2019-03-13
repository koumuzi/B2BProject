<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <script>
    var dom = document.getElementById("chartDiv");
    var myChart = echarts.init(dom);
    var app = {};
    option = null;
    app.title = '销售情况统计';

    option = {
        title: {
            text: '销售情况统计',
            subtext: '数据来自系统数据库'
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['销售量']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'value',
            boundaryGap: [0, 0.01]
        },
        yAxis: {
            type: 'category',
            data: []
        },
        series: [
            {
                name: '销售量',
                type: 'bar',
                data: []
            }
        ]
    };
    ;
    if (option && typeof option === "object") {
        myChart.setOption(option, true);
    }
    
    //设置日期控件约束
    var date = new Date();
    date.setDate(date.getDate() - 1);
    var formatDate = FormatDate(date);
    $("#input_endDate").attr("max", formatDate).attr("min", "2018-01-07").val(formatDate);
    date.setDate(date.getDate() - 6);
    formatDate = FormatDate(date);
    $("#input_beginDate").val(formatDate).attr("min", formatDate).attr("max", formatDate);
    </script>
    <style rel="stylesheet">
        #chartByDate {
            padding: 0;
            margin-bottom: 40px;
        }

        #chartByDate > li {
            display: inline-block;
            list-style: none;
        }

        #chartByDate > li > .frm_input {
            color: #999;
            height: 29px;
            cursor: pointer;
        }

        #chartTotal {
            width: 100%;
            margin-bottom: 30px;
            padding: 0 20px;
        }

        #chartTotal > li {
            width: 35%;
            display: inline-block;
            list-style: none;
            padding: 0 40px;
            cursor: pointer;
        }

        #chartTotal > li + li {
            border-left: 2px solid #eee;
        }

        #chartTotal > li:first-child {
            width: 31.5%;
            padding-left: 0;
        }

        #chartTotal > li:last-child {
            width: 31.5%;
            padding-right: 0;
        }

        #chartTotal .chartTotalTitle {
            height: 20px;
            text-indent: 3px;
        }

        .chartTotalTitle .chartTitleText {
            float: left;
            font-weight: bold;
            font-size: 14px;
            color: #666;
        }

        .chartTotalTitle .chartTitleUnit {
            float: right;
            font-weight: bold;
            font-size: 14px;
            color: #666;
        }

        #chartTotal .chartTotalValue {
            font-size: 28px;
            font-weight: bold;
            color: #666;
        }

        #chartTotal .chartTotalStyle {
            width: 100%;
            height: 6px;
            border-radius: 10px;
            margin-top: 10px;
        }

        .chartDateBtn {
            display: inline-block;
            padding: 5px 10px;
            color: #999;
            margin: 0 20px 0 0;
            border-radius: 3px;
            border: 1px solid #e9ebef;
            font-size: 12px;
            cursor: pointer;
        }

        span.chartDateBtn.select {
            background: #70BBF4;
            border: 1px solid #70BBF4;
            color: white;
        }

        .chartDateInput {
            color: #999;
            outline: none;
            border: 0;
        }

        input[type=date]::-webkit-inner-spin-button {
            display: none
        }

        input[type=date]::-webkit-clear-button {
            display: none
        }

        #btn_chart_search {
            position: relative;
            top: 1px;
        }

        .split {
            color: #999;
            padding-right: 10px;
        }

        #chartDiv {
            border: 1px solid #eee;
            padding: 20px;
        }

    </style>
</head>
<body>
<ul id="chartByDate">
    <li><span class="chartDateBtn text_info select">最近一周</span></li>
    <li class="chartDateBtn"><input class="chartDateInput" id="input_beginDate" type="date" title="开始日期"/><span
            class="split">—</span> <input class="chartDateInput details_unit" id="input_endDate" type="date"
                                          title="结束日期"/></li>
    <li><input class="frm_btn" id="btn_chart_search" type="button" value="查询"/></li>
</ul>
<div id="chartDiv" style="width: 100%;height: 500px"></div>
<div class="container"></div>
</body>
</html>
