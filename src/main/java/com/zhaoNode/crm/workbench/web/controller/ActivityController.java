package com.zhaoNode.crm.workbench.web.controller;

import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.UserService;
import com.zhaoNode.crm.settings.service.imp.UserServiceimp;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.PrintJson;
import com.zhaoNode.crm.utils.ServiceFactory;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.ActivityRemark;
import com.zhaoNode.crm.workbench.service.ActivityService;
import com.zhaoNode.crm.workbench.service.impl.ActivityServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.interfaces.RSAKey;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        } else if("/workbench/activity/save.do".equals(path)){
           save(request,response);
        }else if("/workbench/activity/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/activity/delete.do".equals(path)){
            delete(request,response);
        }else if ("/workbench/activity/getUserListAndActivity.do".equals(path)){
            getUserListAndActivity(request,response);
        }else if("/workbench/activity/update.do".equals(path)){
            update(request,response);
        }else if ("/workbench/activity/detail.do".equals(path)){
            detail(request,response);
        }else if ("/workbench/activity/getRemarkListByAid.do".equals(path)){
            getRemarkListByAid(request,response);
        }else if("/workbench/activity/deleteRemark.do".equals(path)){
            deleteRemark(request,response);
        }else if("/workbench/activity/saveRemark.do".equals(path)){
            saveRemark(request,response);
        }else if("/workbench/activity/updateRemark.do".equals(path)){
            updateRemark(request,response);
        }else if("/workbench/chart/activity/showActivityChart.do".equals(path)){
            showActivityChart(request,response);
        }

        }

    private void showActivityChart(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取市场图表的操作");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        List<Map<String,Object>> list=activityService.showActivityChart();
        PrintJson.printJsonObj(response,list);
    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进如到修改备注操作");
        String id=request.getParameter("id");
        String noteContent=request.getParameter("noteContent");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();
        String editFlag="1";
        ActivityRemark ar=new ActivityRemark();
        ar.setId(id);
        ar.setEditFlag(editFlag);
        ar.setNoteContent(noteContent);
        ar.setEditTime(editTime);
        ar.setEditBy(editBy);

        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.updateRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("ar",ar);
        map.put("success",flag);
        PrintJson.printJsonObj(response,map);

    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加备注的操作");
        String id=UUIDUtil.getUUID();
        String activityId=request.getParameter("activityId");
        String noteContent=request.getParameter("noteContent");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        String editFlag="0";

        ActivityRemark ar=new ActivityRemark();
        ar.setId(id);
        ar.setActivityId(activityId);
        ar.setCreateBy(createBy);
        ar.setEditFlag(editFlag);
        ar.setNoteContent(noteContent);
        ar.setCreateTime(createTime);

        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.saveRemark(ar);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("ar",ar);
        map.put("success",flag);
        PrintJson.printJsonObj(response,map);

    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除备注的操作");
        String id=request.getParameter("id");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.deleteRemark(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getRemarkListByAid(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入通过id获取备注的操作");
        String activityId=request.getParameter("activityId");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        List<ActivityRemark> list=activityService.getRemarkListByAid(activityId);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入获取活动详细页面的操作");
        String id=request.getParameter("id");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Activity activity=activityService.detail(id);
        request.setAttribute("a",activity);
        request.getRequestDispatcher("/workbench/activity/detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改活动的操作");
        Activity activity=new Activity();
        activity.setId(request.getParameter("id"));
        activity.setOwner(request.getParameter("owner"));
        activity.setName(request.getParameter("name"));
        activity.setStartDate(request.getParameter("startDate"));
        activity.setEndDate(request.getParameter("endDate"));
        activity.setCost(request.getParameter("cost"));
        activity.setDescription(request.getParameter("description"));
        activity.setEditTime(DateTimeUtil.getSysTime());
        activity.setEditBy(((User)request.getSession().getAttribute("User")).getName());
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.update(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户信息和市场活动的操作");
        String id=request.getParameter("id");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Map<String,Object> map=activityService.getUserListAndActivity(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除活动的操作");
        String arr[]=request.getParameterValues("id");
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.delete(arr);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入分页查询活动的操作");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Map<String,Object> map=new HashMap();
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        PaginationVO<Activity> VO= activityService.pageList(map);
        PrintJson.printJsonObj(response,VO);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入添加活动的操作");
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String startDate=request.getParameter("startDate");
        String endDate=request.getParameter("endDate");
        String cost=request.getParameter("cost");
        String description=request.getParameter("description");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        Activity activity=new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setDescription(description);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        ActivityService activityService=(ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        boolean flag=activityService.save(activity);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户的操作");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceimp());
        List<User> list=userService.getUserList();
        PrintJson.printJsonObj(response,list);
    }
}
