package com.zhaoNode.crm.settings.web.controller;

import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.DeptService;
import com.zhaoNode.crm.settings.service.UserService;
import com.zhaoNode.crm.settings.service.imp.DeptServiceImp;
import com.zhaoNode.crm.settings.service.imp.UserServiceimp;
import com.zhaoNode.crm.utils.*;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.service.CustomerService;
import com.zhaoNode.crm.workbench.service.impl.CustomerServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class DeptController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/dept/pageList.do".equals(path)) {
           pageList(request,response);
        } else if ("/settings/dept/saveDept.do".equals(path)) {
            saveDept(request,response);
        }else if("/settings/dept/editDept.do".equals(path)){
            editDept(request,response);
        }else if("/settings/dept/updateDept.do".equals(path)){
            updateDept(request,response);
        }else if("/settings/dept/deleteDeptById.do".equals(path)){
            deleteDeptById(request,response);
        }

    }

    private void deleteDeptById(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("根据id删除部门的操作");
        String arr[]=request.getParameterValues("id");
        DeptService deptService=(DeptService) ServiceFactory.getService(new DeptServiceImp());
        boolean flag=deptService.deleteDept(arr);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateDept(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改部门的操作");
        String id=request.getParameter("id");
        String deptno=request.getParameter("deptno");
        String deptname=request.getParameter("deptname");
        String principal=request.getParameter("principal");
        String phone=request.getParameter("phone");
        String description=request.getParameter("description");
        String editTime= DateTimeUtil.getSysTime();
        String editBy=((User)request.getSession().getAttribute("User")).getName();

        Dept dept=new Dept();

        dept.setPrincipal(principal);
        dept.setPhone(phone);
        dept.setId(id);
        dept.setDescription(description);
        dept.setDeptno(deptno);
        dept.setDeptname(deptname);
        dept.setEditBy(editBy);
        dept.setEditTime(editTime);

        DeptService deptService=(DeptService) ServiceFactory.getService(new DeptServiceImp());
        boolean flag=deptService.updateDept(dept);
        PrintJson.printJsonFlag(response,flag);
    }

    private void editDept(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("展现要修改页面的信息");
        String id=request.getParameter("id");
        DeptService deptService=(DeptService) ServiceFactory.getService(new DeptServiceImp());
        Dept dept=deptService.editDept(id);
        PrintJson.printJsonObj(response,dept);
    }

    private void saveDept(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加部门的操作");
        String id=UUIDUtil.getUUID();
        String deptno=request.getParameter("deptno");
        String deptname=request.getParameter("deptname");
        String principal=request.getParameter("principal");
        String phone=request.getParameter("phone");
        String description=request.getParameter("description");
        String createTime= DateTimeUtil.getSysTime();
        String createBy=((User)request.getSession().getAttribute("User")).getName();

        Dept dept=new Dept();

        dept.setPrincipal(principal);
        dept.setPhone(phone);
        dept.setId(id);
        dept.setDescription(description);
        dept.setDeptno(deptno);
        dept.setDeptname(deptname);
        dept.setCreateTime(createTime);
        dept.setCreateBy(createBy);

        DeptService deptService=(DeptService) ServiceFactory.getService(new DeptServiceImp());
        boolean flag=deptService.saveDept(dept);
        PrintJson.printJsonFlag(response,flag);

    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新部门的操作");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        DeptService deptService=(DeptService) ServiceFactory.getService(new DeptServiceImp());
        PaginationVO vo=deptService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
