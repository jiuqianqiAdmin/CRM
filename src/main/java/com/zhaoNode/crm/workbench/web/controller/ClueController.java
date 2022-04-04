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
import com.zhaoNode.crm.workbench.domain.Clue;
import com.zhaoNode.crm.workbench.domain.Tran;
import com.zhaoNode.crm.workbench.service.ClueService;
import com.zhaoNode.crm.workbench.service.impl.ClueServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;



public class ClueController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/workbench/clue/getUserList.do".equals(path)){
          getUserList(request,response);
        } else if("/workbench/clue/save.do".equals(path)) {
              save(request,response);
        }else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/clue/showActivityList.do".equals(path)){
            showActivityList(request,response);
        }else if("/workbench/clue/deleteActivityRelationById".equals(path)){
            deleteActivityRelationById(request,response);
        }else if ("/workbench/clue/searchActivityBYNameAndClueId.do".equals(path)){
            searchActivityBYNameAndClueId(request,response);
        }else if ("/workbench/clue/saveActivityRelationBYActivityIdAndClueId.do".equals(path)){
            saveActivityRelationBYActivityIdAndClueId(request,response);
        }else if("/workbench/clue/searchActivityByName.do".equals(path)){
            searchActivityByName(request,response);
        }else if("/workbench/activity/getUserListAndClue.do".equals(path)){
            getUserListAndClue(request,response);
        }else if("/workbench/clue/updateClue.do".equals(path)){
            updateClue(request,response);
        }else if("/workbench/clue/deleteClueById.do".equals(path)){
            deleteClueById(request,response);
        }else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }else if("/workbench/chart/Clue/showClueChart.do".equals(path)){
            showClueChart(request,response);
        }
    }

    private void showClueChart(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到获取线索图表");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        List<Map<String,Object>> list=cs.showClueChart();
        PrintJson.printJsonObj(response,list);
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到转换线索的操作");
        String clueId=request.getParameter("clueId");
        String flag=request.getParameter("flag");
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        Tran t=null;
        if("a".equals(flag)){
            t=new Tran();
            String money=request.getParameter("money");
            String stage=request.getParameter("stage");
            String name=request.getParameter("name");
            String activityId=request.getParameter("activityId");
            String expectedDate=request.getParameter("expectedDate");
            String createTime= DateTimeUtil.getSysTime();

            t.setActivityId(activityId);
            t.setStage(stage);
            t.setId(UUIDUtil.getUUID());
            t.setMoney(money);
            t.setName(name);
            t.setExpectedDate(expectedDate);
            t.setCreateBy(createBy);
            t.setCreateTime(createTime);
        }
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag1=cs.convert(clueId,t,createBy);
        if (flag1){
            response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
        }
    }
    private void deleteClueById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除线索的页面");
        String id[]=request.getParameterValues("id");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=cs.deleteClueById(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入修改线索的操作");
        String id=request.getParameter("id");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("apppellation");
        String owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String source=request.getParameter("source");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");

        Clue clue=new Clue();

        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setEditTime(editTime);
        clue.setEditBy(editBy);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=cs.updateClue(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndClue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询用户表和线索的操作");
        String id=request.getParameter("id");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        Map<String,Object> map=cs.getUserListAndClue(id);
        PrintJson.printJsonObj(response,map);
    }

    private void searchActivityByName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入根据名称查活动的操作");
        String name=request.getParameter("name");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        List<Activity> list=cs.searchActivityByName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void saveActivityRelationBYActivityIdAndClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入为线索添加活动关联的操作");
        String clueId=request.getParameter("clueId");
        String activityId[]=request.getParameterValues("activityId");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=cs.saveActivityRelationBYActivityIdAndClueId(clueId,activityId);
        PrintJson.printJsonFlag(response,flag);
    }


    private void searchActivityBYNameAndClueId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进如根据id和名称查活动的操作");
        String clueId=request.getParameter("clueId");
        String name=request.getParameter("name");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        Map<String,String> map=new HashMap<String, String>();
        map.put("clueId",clueId);
        map.put("name",name);
        List<Activity> list=cs.searchActivityBYNameAndClueId(map);
        PrintJson.printJsonObj(response,list);
    }

    private void deleteActivityRelationById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入删除线索关联操作");
        String id=request.getParameter("id");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=cs.deleteActivityRelationById(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void showActivityList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取市场关联表的操作");
        String clueId=request.getParameter("clueId");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        List<Activity> list=cs.showActivityList(clueId);
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入详细线索页面");
        String id=request.getParameter("id");
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        Clue clue=cs.detail(id);
        request.setAttribute("c",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入查询线索页面");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String fullname=request.getParameter("fullname");
        String createBy=request.getParameter("createBy");
        String source=request.getParameter("source");
        String company=request.getParameter("company");
        String phone=request.getParameter("phone");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("fullname",fullname);
        map.put("createBy",createBy);
        map.put("source",source);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("state",state);
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        PaginationVO vo=cs.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入新建线索操作");
        String id= UUIDUtil.getUUID();
        String fullname=request.getParameter("fullname");
        String appellation =request.getParameter("appellation");
        String owner=request.getParameter("owner");
        String company=request.getParameter("company");
        String job=request.getParameter("job");
        String email=request.getParameter("email");
        String phone=request.getParameter("phone");
        String website=request.getParameter("website");
        String mphone=request.getParameter("mphone");
        String state=request.getParameter("state");
        String source=request.getParameter("source");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");
        Clue clue=new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job);
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setState(state);
        clue.setSource(source);
        clue.setCreateTime(createTime);
        clue.setCreateBy(createBy);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService cs=(ClueService) ServiceFactory.getService(new ClueServiceImp());
        boolean flag=cs.save(clue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户的操作");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceimp());
        List<User> list=userService.getUserList();
        PrintJson.printJsonObj(response,list);
    }
}
