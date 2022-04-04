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
import com.zhaoNode.crm.workbench.domain.Customer;
import com.zhaoNode.crm.workbench.domain.Tran;
import com.zhaoNode.crm.workbench.service.ContactsService;
import com.zhaoNode.crm.workbench.service.CustomerService;
import com.zhaoNode.crm.workbench.service.TranService;
import com.zhaoNode.crm.workbench.service.impl.ContactsServiceImp;
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

public class ContactsController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/workbench/contacts/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/workbench/contacts/getUserList.do".equals(path)) {
            getUserList(request,response);
        }else if("/workbench/contacts/getCustomerName.do".equals(path)){
            getCustomerName(request,response);
        }else if("/workbench/contacts/saveContacts.do".equals(path)){
            saveContacts(request,response);
        }else if("/workbench/contacts/getUserListAndContacts.do".equals(path)){
            getUserListAndContacts(request,response);
        }else if("/workbench/contacts/updateContacts.do".equals(path)){
            updateContacts(request,response);
        }else if("/workbench/contacts/detail.do".equals(path)){
            detail(request,response);
        }else if("/workbench/contacts/showTran.do".equals(path)){
            showTran(request,response);
        }else if("/workbench/contacts/searchActivityBYNameAndByContactsId.do".equals(path)){
            searchActivityBYNameAndByContactsId(request,response);
        }else if("/workbench/contacts/activityRelationContacts.do".equals(path)){
            activityRelationContacts(request,response);
        }else if("/workbench/contacts/showActivityList.do".equals(path)){
            showActivityList(request,response);
        }else if("/workbench/contacts/deleteActivityRelationContacts.do".equals(path)){
            deleteActivityRelationContacts(request,response);
        }else if("/workbench/contacts/deleteTranRelationContacts.do".equals(path)){
            deleteTranRelationContacts(request,response);
        }else if("/workbench/contacts/delete.do".equals(path)){
            delete(request,response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除联系人的操作");
        String id[]=request.getParameterValues("id");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.delete(id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void deleteTranRelationContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除联系人的交易");
        String Id=request.getParameter("tranId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.deleteTranRelationContacts(Id);
        PrintJson.printJsonFlag(response,flag);
    }

    private void deleteActivityRelationContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除联系人与市场活动的关系");
        String activityId=request.getParameter("id");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.deleteActivityRelationContacts(activityId);
        PrintJson.printJsonFlag(response,flag);
    }

    private void showActivityList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("展现联系人联系人与市场活动的关系");
        String contactsId=request.getParameter("contactsId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        List<Activity> list=contactsService.showActivityList(contactsId);
        PrintJson.printJsonObj(response,list);
    }

    private void activityRelationContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("关联联系人与市场活动");
        String contactsId=request.getParameter("contactsId");
        String activityId[]=request.getParameterValues("activityId");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.activityRelationContacts(contactsId,activityId);
        PrintJson.printJsonFlag(response,flag);
    }

    private void searchActivityBYNameAndByContactsId(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到查询市场活动的操作");
        String contactsId=request.getParameter("id");
        String name=request.getParameter("name");
        Map<String,String> map=new HashMap<String, String>();
        map.put("contactsId",contactsId);
        map.put("name",name);
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        List<Activity> list=contactsService.searchActivityBYName(map);
        PrintJson.printJsonObj(response,list);
    }

    private void showTran(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("展现联系人交易");
        String contactsId=request.getParameter("id");
        TranService tranService=(TranService) ServiceFactory.getService(new TranServiceImp());
        List<Tran> list=tranService.getTranRelationByContactsId(contactsId);
        Map<String,String> map=(Map<String, String>) this.getServletContext().getAttribute("map1");
        for (Tran t:list){
            String stage=t.getStage();
            String possibility=map.get(stage);
            t.setPossibility(possibility);
        }
        PrintJson.printJsonObj(response,list);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入到获取联系人详细页面的操作");
        String id=request.getParameter("id");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        Contacts contacts=contactsService.detail(id);
        request.setAttribute("c",contacts);
        request.getRequestDispatcher("/workbench/contacts/detail.jsp").forward(request,response);
    }

    private void updateContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改联系人的操作中");
        String id= request.getParameter("id");
        String owner=request.getParameter("owner");
        String source=request.getParameter("source");
        String customerName=request.getParameter("customerName");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String email=request.getParameter("email");
        String mphone=request.getParameter("mphone");
        String job=request.getParameter("job");
        String birth=request.getParameter("birth");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");

        Contacts contacts=new Contacts();

        contacts.setBirth(birth);
        contacts.setNextContactTime(nextContactTime);
        contacts.setMphone(mphone);
        contacts.setJob(job);
        contacts.setId(id);
        contacts.setEmail(email);
        contacts.setDescription(description);
        contacts.setEditBy(editBy);
        contacts.setEditTime(editTime);
        contacts.setContactSummary(contactSummary);
        contacts.setAppellation(appellation);
        contacts.setAddress(address);
        contacts.setSource(source);
        contacts.setOwner(owner);
        contacts.setFullname(fullname);

        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.updateContacts(contacts,customerName);
        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserListAndContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到修改联系人的详情页面");
        String id=request.getParameter("id");
        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        Map<String,Object> map=contactsService.getUserListAndContacts(id);
        PrintJson.printJsonObj(response,map);
    }

    private void saveContacts(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到添加联系人的操作");
        String id= UUIDUtil.getUUID();
        String owner=request.getParameter("owner");
        String source=request.getParameter("source");
        String customerName=request.getParameter("customerName");
        String fullname=request.getParameter("fullname");
        String appellation=request.getParameter("appellation");
        String email=request.getParameter("email");
        String mphone=request.getParameter("mphone");
        String job=request.getParameter("job");
        String birth=request.getParameter("birth");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();
        String description=request.getParameter("description");
        String contactSummary=request.getParameter("contactSummary");
        String nextContactTime=request.getParameter("nextContactTime");
        String address=request.getParameter("address");

        Contacts contacts=new Contacts();

        contacts.setBirth(birth);
        contacts.setNextContactTime(nextContactTime);
        contacts.setMphone(mphone);
        contacts.setJob(job);
        contacts.setId(id);
        contacts.setEmail(email);
        contacts.setDescription(description);
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(contactSummary);
        contacts.setAppellation(appellation);
        contacts.setAddress(address);
        contacts.setSource(source);
        contacts.setOwner(owner);
        contacts.setFullname(fullname);

        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        boolean flag=contactsService.save(contacts,customerName);
        PrintJson.printJsonFlag(response,flag);

    }

    private void getCustomerName(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到搜索自动补全的操作");
        String name=request.getParameter("name");
        CustomerService customerService=(CustomerService) ServiceFactory.getService(new CustomerServiceImp());
        List<String> list=customerService.getCustomerName(name);
        PrintJson.printJsonObj(response,list);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入获取用户的操作");
        UserService userService=(UserService) ServiceFactory.getService(new UserServiceimp());
        List<User> list=userService.getUserList();
        PrintJson.printJsonObj(response,list);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新联系人列表");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String fullname=request.getParameter("name");
        String ownerName=request.getParameter("ownerName");
        String customerName=request.getParameter("customerName");
        String source=request.getParameter("source");

        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("fullname",fullname);
        map.put("ownerName",ownerName);
        map.put("source",source);
        map.put("customerName",customerName);

        ContactsService contactsService=(ContactsService) ServiceFactory.getService(new ContactsServiceImp());
        PaginationVO vo=contactsService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}