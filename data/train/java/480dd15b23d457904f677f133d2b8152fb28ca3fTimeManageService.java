package com.syuesoft.fin.service;

import org.jfree.chart.JFreeChart;

import com.syuesoft.bas.service.BaseService;
import com.syuesoft.fin.vo.TimeManageVo;
import com.syuesoft.systemmanagement.vo.DatagridAnalyze;

public interface TimeManageService extends BaseService
{

	/**查询日经营情况*/
    public String findDayManage(TimeManageVo timeManageVo)throws Exception;
    /**查询年经营情况*/
    public String findMonthManage(TimeManageVo timeManageVo)throws Exception;
    /**查询年经营情况*/
    public String findYearManage(TimeManageVo timeManageVo)throws Exception;
    /**获取年经营情况折线图信息*/
    public JFreeChart findYearManageSnapMap(TimeManageVo timeManageVo)throws Exception;
    /**获取年经营情况饼图信息*/
    public JFreeChart findYearManageCakeMap(TimeManageVo timeManageVo)throws Exception;
    /**获取月经营情况折线图信息*/
    public JFreeChart findMonthManageSnapMap(TimeManageVo timeManageVo)throws Exception;
    /**获取月经营情况饼图信息*/
    public JFreeChart findMonthManageCakeMap(TimeManageVo timeManageVo)throws Exception;
    /**获取日经营情况折线图信息*/
    public JFreeChart findDayManageSnapMap(TimeManageVo timeManageVo)throws Exception;
    /**获取日经营情况饼图信息*/
    public JFreeChart findDayManageCakeMap(TimeManageVo timeManageVo)throws Exception;
    /**日营业情况查询*/
    public DatagridAnalyze findDayBusinessThing(TimeManageVo timeManageVo,Boolean flag)throws Exception;
    /**获取日营业情况折线图信息*/
    public JFreeChart findDayBusinessThingSnapMap(TimeManageVo timeManageVo)throws Exception;
    /**获取日营业情况柱状图信息*/
    public JFreeChart findDayBusinessThingPoleMap(TimeManageVo timeManageVo)throws Exception;
    
}
