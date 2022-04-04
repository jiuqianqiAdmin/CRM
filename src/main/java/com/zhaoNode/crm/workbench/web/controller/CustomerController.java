package com.zhaoNode.crm.workbench.web.controller;

import com.sun.javafx.collections.MappingChange;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.UserService;
import com.zhaoNode.crm.settings.service.imp.UserServiceimp;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.PrintJson;
import com.zhaoNode.crm.utils.ServiceFactory;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.*;
import com.zhaoNode.crm.workbench.service.ClueService;
import com.zhaoNode.crm.workbench.service.CustomerService;
import com.zhaoNode.crm.workbench.service.TranService;
import com.zhaoNode.crm.workbench.service.impl.ClueServiceImp;
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


public class CustomerController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/customer/getUserList.do".equals(path)) {
            getUserList(request, response);
        }else if("/workbench/customer/saveCustomer.do".equals(path)){
            save(request,response);
        }else if("/workbench/customer/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/workbench/customer/getUserListAndCustomer.do".equals(path)){
            getUserListAndCustomer(request,response);
        }else if("/workbench/customer/updateCustomer.do".equals(path)){
            updateCustomer(request,response);
        }else if("/workbench/customer/deleteCustomerById.do".equals(path)){
            deleteCustomerById(request,response);
        }else if("/workbench/customer/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/customer/showTranRelation.do".equals(path)){
            showTranRelation(request,response);
        }else if("/workbench/customer/showContacts.do".equals(path)){
            showContacts(request,response);
        }else if("/workbench/customer/deleteCustomerRelationContacts.do".equals(path)){
            updateContactsCustomerId(request,response);
        }

    }

    private void updateContactsCustomerId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除联系人与客户的联系");
        String id=request.getParameter("contactsId");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        boolean flag=customerService.updateContactsCustomerId(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void showContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("展现客户下的联系人");
        String customerId=request.getParameter("id");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        List<Contacts> list=customerService.showContacts(customerId);
        PrintJson.printJsonObj(response,list);
    }

    private void showTranRelation(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("获取客户下的交易操作");
        String customerId=request.getParameter("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<Tran> list=tranService.getTranRelation(customerId);
        Map<String,String> map=(Map<String, String>) this.getServletContext().getAttribute("map1");
        for (Tran t:list){
            String stage=t.getStage();
            String possibility=map.get(stage);
            t.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到跳转客户详细信息的页面");
        String id=request.getParameter("id");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        Customer customer=customerService.detail(id);
        request.setAttribute("c",customer);
        request.getRequestDispatcher("/workbench/customer/detail.jsp").forward(request,response);
    }

    private void deleteCustomerById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到删除客户的操作");
        String arr[]=request.getParameterValues("id");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        boolean flag=customerService.delete(arr);
        PrintJson.printJsonFlag(response,flag);

    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改客户的操作");
        String id=request.getParameter("id");
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String description=request.getParameter("description");
        String address=request.getParameter("address");

        Customer customer=new Customer();

        customer.setId(id);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setOwner(owner);
        customer.setNextContactTime(nextContactTime);
        customer.setName(name);
        customer.setDescription(description);
        customer.setEditTime(editTime);
        customer.setEditBy(editBy);
        customer.setContactSummary(contactSummary);
        customer.setAddress(address);
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        boolean flag=customerService.update(customer);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndCustomer(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改客户详情页面");
        String id=request.getParameter("id");
        Map<String,Object> map=new HashMap<String, Object>();
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        map=customerService.getUserListAndCustomer(id);
        PrintJson.printJsonObj(response,map);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到更新客户的操作");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String name=request.getParameter("name");
        String owner=request.getParameter("owner");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("name",name);
        map.put("owner",owner);
        map.put("website",website);
        map.put("phone",phone);

        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        PaginationVO vo=customerService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加客户的操作");
        String id=UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String name=request.getParameter("name");
        String website=request.getParameter("website");
        String phone=request.getParameter("phone");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String description=request.getParameter("description");
        String address=request.getParameter("address");

        Customer customer=new Customer();

        customer.setId(id);
        customer.setWebsite(website);
        customer.setPhone(phone);
        customer.setOwner(owner);
        customer.setNextContactTime(nextContactTime);
        customer.setName(name);
        customer.setDescription(description);
        customer.setCreateTime(createTime);
        customer.setCreateBy(createBy);
        customer.setContactSummary(contactSummary);
        customer.setAddress(address);
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        boolean flag=customerService.save(customer);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户的操作");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceimp());
        List<User> list=userService.getUserList();
        PrintJson.printJsonObj(response,list);
    }
}