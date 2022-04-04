package com.zhaoNode.crm.settings.web.controller;

import com.sun.javafx.collections.MappingChange;
import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.UserService;
import com.zhaoNode.crm.settings.service.imp.UserServiceimp;
import com.zhaoNode.crm.utils.*;
import com.zhaoNode.crm.vo.PaginationVO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path=request.getServletPath();
        if("/settings/user/login.do".equals(path)){
            login(request,response);
        }else if("/settings/user/updatePwd.do".equals(path)){
            updatePwd(request,response);
        }else if("/settings/user/pageList.do".equals(path)){
            pageList(request,response);
        }else if("/settings/user/saveUser.do".equals(path)){
            saveUser(request,response);
        }else if("/settings/user/deleteUserById.do".equals(path)){
            deleteUserById(request,response);
        }else if("/settings/user/detail.do".equals(path)){
            detail(request,response);
        }else if("/settings/user/updateUser.do".equals(path)){
            updateUser(request,response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改用户的操作");
        String id= request.getParameter("id");
        String loginAct=request.getParameter("loginAct");
        String name=request.getParameter("name");
        String loginPwd=MD5Util.getMD5(request.getParameter("loginPwd"));
        String email=request.getParameter("email");
        String expireTime=request.getParameter("expireTime");
        String lockState=request.getParameter("lockState");
        String deptno=request.getParameter("deptno");
        String allowIps=request.getParameter("allowIps");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();

        User user=new User();
        user.setName(name);
        user.setLoginPwd(loginPwd);
        user.setLoginAct(loginAct);
        user.setLockState(lockState);
        user.setId(id);
        user.setExpireTime(expireTime);
        user.setEmail(email);
        user.setDeptno(deptno);
        user.setEditTime(editTime);
        user.setEditBy(editBy);
        user.setAllowIps(allowIps);

        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        boolean flag=us.updateUser(user);
        PrintJson.printJsonFlag(response,flag);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户详细页面");
        String id=request.getParameter("id");
        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        User user=us.detail(id);
        request.setAttribute("user",user);
        request.getRequestDispatcher("/settings/qx/user/detail.jsp").forward(request,response);
    }

    private void deleteUserById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除用户的操作");
        String arr[]=request.getParameterValues("id");
        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        boolean flag=us.deleteUserById(arr);
        PrintJson.printJsonFlag(response,flag);
    }

    private void saveUser(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加用户的操作");
        String id= UUIDUtil.getUUID();
        String loginAct=request.getParameter("loginAct");
        String name=request.getParameter("name");
        String loginPwd=MD5Util.getMD5(request.getParameter("loginPwd"));
        String email=request.getParameter("email");
        String expireTime=request.getParameter("expireTime");
        String lockState=request.getParameter("lockState");
        String deptno=request.getParameter("deptno");
        String allowIps=request.getParameter("allowIps");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();

       User user=new User();
       user.setName(name);
       user.setLoginPwd(loginPwd);
       user.setLoginAct(loginAct);
       user.setLockState(lockState);
       user.setId(id);
       user.setExpireTime(expireTime);
       user.setEmail(email);
       user.setDeptno(deptno);
       user.setCreateTime(createTime);
       user.setCreateBy(createBy);
       user.setAllowIps(allowIps);

        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        boolean flag=us.saveUser(user);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新用户列表");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        String name=request.getParameter("name");
        String deptName=request.getParameter("deptName");
        String lockState=request.getParameter("lockState");
        String startTime=request.getParameter("startTime");
        String endTime=request.getParameter("endTime");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        map.put("name",name);
        map.put("deptName",deptName);
        map.put("lockState",lockState);
        map.put("startTime",startTime);
        map.put("endTime",endTime);
        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        PaginationVO vo=us.pageList(map);
        PrintJson.printJsonObj(response,vo);

    }

    private void updatePwd(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改密码的操作");
        String id=request.getParameter("id");
        String oldPwd=MD5Util.getMD5(request.getParameter("oldPwd"));
        String nwePwd=MD5Util.getMD5(request.getParameter("newPwd"));
        Map<String,String> map=new HashMap<String, String>();
        map.put("id",id);
        map.put("oldPwd",oldPwd);
        map.put("newPwd",nwePwd);
        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        boolean flag=us.updatePwd(map);
        PrintJson.printJsonFlag(response,flag);
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        String loginAct=request.getParameter("loginAct");
        String loginPwd= MD5Util.getMD5(request.getParameter("loginPwd"));
        System.out.println(loginPwd);
        String ip=request.getRemoteAddr();
        System.out.println(ip);
        UserService us= (UserService) ServiceFactory.getService(new UserServiceimp());
        try {
            User user=us.login(loginAct,loginPwd,ip);
           request.getSession().setAttribute("User",user);
           PrintJson.printJsonFlag(response,true);
        }catch (Exception e){
            e.printStackTrace();
            String msg=e.getMessage();
            Map<String,Object> map=new HashMap<String, Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }
}
