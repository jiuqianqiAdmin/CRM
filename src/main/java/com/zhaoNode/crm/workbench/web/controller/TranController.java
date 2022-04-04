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
import com.zhaoNode.crm.workbench.domain.Contacts;
import com.zhaoNode.crm.workbench.domain.Tran;
import com.zhaoNode.crm.workbench.domain.TranHistory;
import com.zhaoNode.crm.workbench.service.CustomerService;
import com.zhaoNode.crm.workbench.service.TranService;
import com.zhaoNode.crm.workbench.service.impl.CustomerServiceImp;
import com.zhaoNode.crm.workbench.service.impl.TranServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;


public class TranController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/transaction/getUserList.do".equals(path)) {
            getUserList(request, response);
        } else if ("/workbench/transaction/getCustomerName.do".equals(path)) {
            getCustomerName(request, response);
        }else if("/workbench/transaction/save.do".equals(path)){
            save(request,response);
        }else if("/workbench/transaction/searchActivityBYName.do".equals(path)){
            searchActivityBYName(request,response);
        }else if("/workbench/transaction/searchContactsBYName.do".equals(path)){
            searchContactsBYName(request,response);
        }else if("/workbench/transaction/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/transaction/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/transaction/showTranHistory.do".equals(path)){
            showTranHistory(request,response);
        }else if ("/workbench/transaction/changeStage.do".equals(path)){
            changeStage(request,response);
        }else if("/workbench/chart/transaction/showTranChart.do".equals(path)){
            showTranChart(request,response);
        }else if("/workbench/transaction/getUserListAndTran.do".equals(path)){
            getUserListAndTran(request,response);
        }else if("/workbench/transaction/update.do".equals(path)){
            update(request,response);
        }else if("/workbench/transaction/deleteTranById.do".equals(path)){
            deleteTranById(request,response);
        }
    }

    private void deleteTranById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除交易的操作");
        String id[]=request.getParameterValues("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        boolean flag=tranService.deleteTranById(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到修改交易的操作");
        String id=request.getParameter("id");
        String owner=request.getParameter("owner");
        String money=request.getParameter("money");
        String name=request.getParameter("name");
        String expectedDate=request.getParameter("expectedDate");
        String customerName=request.getParameter("customerName");
        String stage=request.getParameter("stage");
        String type=request.getParameter("type");
        String source=request.getParameter("source");
        String activityId=request.getParameter("activityId");
        String contactsId=request.getParameter("contactsId");
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();

        Tran t=new Tran();

        t.setType(type);
        t.setActivityId(activityId);
        t.setStage(stage);
        t.setId(id);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setEditBy(editBy);
        t.setEditTime(editTime);
        t.setSource(source);
        t.setOwner(owner);
        t.setNextContactTime(nextContactTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        boolean flag=tranService.update(t,customerName);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }

    }

    private void getUserListAndTran(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到跳转修改交易的页面");
        String id=request.getParameter("tranId");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        Map<String,Object> map=tranService.getUserListAndTran(id);
        PrintJson.printJsonObj(response,map);
    }

    private void showTranChart(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取交易图表");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<Map<String,Object>> dataList=tranService.showTranChart();
        PrintJson.printJsonObj(response,dataList);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入改变交易状态的操作");
        String id=request.getParameter("id");
        String money=request.getParameter("money");
        String stage=request.getParameter("stage");
        String expectedDate=request.getParameter("expectedDate");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();

        Tran tran=new Tran();

        tran.setId(id);
        tran.setMoney(money);
        tran.setStage(stage);
        tran.setExpectedDate(expectedDate);
        tran.setEditBy(editBy);
        tran.setEditTime(editTime);
        Map<String,String> map1=(Map<String, String>) this.getServletContext().getAttribute("map1");
        String possibility=map1.get(stage);
        tran.setPossibility(possibility);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        boolean flag=tranService.changeStage(tran);
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("success",flag);
        map.put("t",tran);
        PrintJson.printJsonObj(response,map);

    }

    private void showTranHistory(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取交易详情页面的交易历史");
        String tranId=request.getParameter("tranId");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<TranHistory> list=tranService.showTranHistory(tranId);
        Map<String,String> map=(Map<String, String>) this.getServletContext().getAttribute("map1");
        for (TranHistory th:list){
        String stage=th.getStage();
        String possibility=map.get(stage);
        th.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到交易详情页面的操作");
        String id=request.getParameter("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        Tran t=tranService.detail(id);
        Map<String,String> map=(Map<String, String>) this.getServletContext().getAttribute("map1");
        String stage=t.getStage();
        String possibility=map.get(stage);
        t.setPossibility(possibility);
        request.setAttribute("t",t);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到更新交易页面的操作");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String ownerName=request.getParameter("ownerName");
        String name=request.getParameter("name");
        String customerName=request.getParameter("customerName");
        String stage=request.getParameter("stage");
        String type=request.getParameter("type");
        String source=request.getParameter("source");
        String contactsName=request.getParameter("contactsName");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String, Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("ownerName",ownerName);
        map.put("name",name);
        map.put("customerName",customerName);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contactsName",contactsName);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        PaginationVO vo=tranService.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    private void searchContactsBYName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询联系人的操作");
        String name=request.getParameter("name");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<Contacts> list=tranService.searchContactsBYName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void searchActivityBYName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动的操作");
        String name=request.getParameter("name");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<Activity> list=tranService.searchActivityBYName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("进入到添加交易的操作");
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String money =request.getParameter("money");
        String name=request.getParameter("name");
        String expectedDate=request.getParameter("expectedDate");
        String customerName=request.getParameter("customerName");
        String stage=request.getParameter("stage");
        String type=request.getParameter("type");
        String source=request.getParameter("source");
        String activityId=request.getParameter("activityId");
        String contactsId =request.getParameter("contactsId");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");

        Tran t=new Tran();

        t.setType(type);
        t.setActivityId(activityId);
        t.setStage(stage);
        t.setId(id);
        t.setMoney(money);
        t.setName(name);
        t.setExpectedDate(expectedDate);
        t.setCreateBy(createBy);
        t.setCreateTime(createTime);
        t.setSource(source);
        t.setOwner(owner);
        t.setNextContactTime(nextContactTime);
        t.setDescription(description);
        t.setContactSummary(contactSummary);
        t.setContactsId(contactsId);

        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        boolean flag=tranService.save(t,customerName);
        if(flag){
            response.sendRedirect(request.getContextPath()+"/workbench/transaction/index.jsp");
        }

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到搜索自动补全的操作");
        String name=request.getParameter("name");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        List<String> list=customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入获取用户的操作");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceimp());
        List<User> list=userService.getUserList();
        request.setAttribute("list",list);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }
}