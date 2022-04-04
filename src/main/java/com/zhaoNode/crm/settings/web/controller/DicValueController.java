package com.zhaoNode.crm.settings.web.controller;

import com.zhaoNode.crm.settings.domain.DicValue;
import com.zhaoNode.crm.settings.service.DicTypeService;
import com.zhaoNode.crm.settings.service.DicValueService;
import com.zhaoNode.crm.settings.service.imp.DicTypeServiceImp;
import com.zhaoNode.crm.settings.service.imp.DicValueServiceImp;
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

public class DicValueController extends HttpServlet {
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/dicValue/pageList.do".equals(path)) {
            pageList(request, response);
        } else if ("/settings/dicValue/saveDicValue.do".equals(path)) {
            saveDicValue(request, response);
        }else if("/settings/dicValue/edit.do".equals(path)){
            edit(request,response);
        }else if("/settings/dicValue/updateDicValue.do".equals(path)){
            updateDicValue(request,response);
        }else if("/settings/dicValue/deleteDicValue.do".equals(path)){
            deleteDicValue(request,response);
        }
    }

    private void deleteDicValue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("删除数据字典值");
        String arr[]=request.getParameterValues("id");
        DicValueService dicValueService=(DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        boolean flag=dicValueService.deleteDicValue(arr);
        PrintJson.printJsonFlag(response,flag);
    }

    private void updateDicValue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("修改数据字典值");
        String id=request.getParameter("id");
        String value=request.getParameter("value");
        String text=request.getParameter("text");
        String orderNo=request.getParameter("orderNo");
        String typeCode=request.getParameter("typeCode");

        DicValue dicValue=new DicValue();

        dicValue.setId(id);
        dicValue.setOrderNo(orderNo);
        dicValue.setText(text);
        dicValue.setTypeCode(typeCode);
        dicValue.setValue(value);

        DicValueService dicValueService=(DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        boolean flag=dicValueService.updateDicValue(dicValue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("展现数据字典值");
        String id=request.getParameter("id");
        DicValueService dicValueService=(DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        DicValue dicValue=dicValueService.edit(id);
        request.setAttribute("dicValue",dicValue);
        request.getRequestDispatcher("/settings/dictionary/value/edit.jsp").forward(request,response);
    }

    private void saveDicValue(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("添加数据字典值");
        String id= UUIDUtil.getUUID();
        String value=request.getParameter("value");
        String text=request.getParameter("text");
        String orderNo=request.getParameter("orderNo");
        String typeCode=request.getParameter("typeCode");

        DicValue dicValue=new DicValue();

        dicValue.setId(id);
        dicValue.setOrderNo(orderNo);
        dicValue.setText(text);
        dicValue.setTypeCode(typeCode);
        dicValue.setValue(value);

        DicValueService dicValueService=(DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        boolean flag=dicValueService.saveDicValue(dicValue);
        PrintJson.printJsonFlag(response,flag);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("刷新数据字典值");
        String pageNoStr=request.getParameter("pageNo");
        String pageSizeStr=request.getParameter("pageSize");
        int pageNo=Integer.valueOf(pageNoStr);
        int pageSize=Integer.valueOf(pageSizeStr);
        int skipCount=(pageNo-1)*pageSize;
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);
        DicValueService dicValueService=(DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        PaginationVO vo=dicValueService.pageList(map);
        PrintJson.printJsonObj(response,vo);
    }
}
