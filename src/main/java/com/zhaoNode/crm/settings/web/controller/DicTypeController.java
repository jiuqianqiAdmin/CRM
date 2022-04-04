package com.zhaoNode.crm.settings.web.controller;

import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.domain.DicType;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.DeptService;
import com.zhaoNode.crm.settings.service.DicTypeService;
import com.zhaoNode.crm.settings.service.imp.DeptServiceImp;
import com.zhaoNode.crm.settings.service.imp.DicTypeServiceImp;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.PrintJson;
import com.zhaoNode.crm.utils.ServiceFactory;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class DicTypeController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/dicType/pageList.do".equals(path)) {
            pageList(request, response);
        }else if("/settings/dicType/saveDicType".equals(path)) {
            saveDicType(request, response);
        }else if("/settings/dicType/edit.do".equals(path)){
            edit(request,response);
        }else if ("/settings/dicType/updateDicType.do".equals(path)){
            updateDicType(request,response);
        }else if("/settings/dicType/deleteDicType.do".equals(path)){
            deleteDicType(request,response);
        }
    }

    private void deleteDicType(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除数据字典类型");
        String arr[]=request.getParameterValues("id");
        DicTypeService dicTypeService=(DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
        boolean flag=dicTypeService.deleteDicType(arr);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateDicType(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改数据字典类型");
        String id=request.getParameter("id");
        String code=request.getParameter("code");
        String name=request.getParameter("name");
        String description=request.getParameter("description");
        Map<String,String> map=new HashMap<String, String>();
        map.put("id",id);
        map.put("code",code);
        map.put("name",name);
        map.put("description",description);
        DicTypeService dicTypeService=(DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
        boolean flag=dicTypeService.updateDicType(map);
        PrintJson.printJsonFlag(response,flag);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("展现要修改的数据字典类型数据");
        String id=request.getParameter("id");
        DicTypeService dicTypeService=(DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
        DicType dicType=dicTypeService.edit(id);
       request.setAttribute("dicType",dicType);
        request.getRequestDispatcher("/settings/dictionary/type/edit.jsp").forward(request,response);
    }

    private void saveDicType(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("新增数据字典类型");
        String code=request.getParameter("code");
        String name=request.getParameter("name");
        String description=request.getParameter("description");
        DicType dicType=new DicType();
        dicType.setCode(code);
        dicType.setDescription(description);
        dicType.setName(name);
        DicTypeService dicTypeService=(DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
        boolean flag=dicTypeService.saveDicType(dicType);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新数据字典类型");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        DicTypeService dicTypeService=(DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
        PaginationVO vo=dicTypeService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
