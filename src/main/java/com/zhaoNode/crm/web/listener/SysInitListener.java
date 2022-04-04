package com.zhaoNode.crm.web.listener;

import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.domain.DicType;
import com.zhaoNode.crm.settings.domain.DicValue;
import com.zhaoNode.crm.settings.service.DeptService;
import com.zhaoNode.crm.settings.service.DicTypeService;
import com.zhaoNode.crm.settings.service.DicValueService;
import com.zhaoNode.crm.settings.service.imp.DeptServiceImp;
import com.zhaoNode.crm.settings.service.imp.DicTypeServiceImp;
import com.zhaoNode.crm.settings.service.imp.DicValueServiceImp;
import com.zhaoNode.crm.utils.ServiceFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    //该方法用来监听上下域的方法当服务器启动创建了上下域对象后立即执行该方法
       public void contextInitialized(ServletContextEvent sce) {
        System.out.println("上下文域对象创建了");
        //该参数能够获得监听对象 监听的是什么对象就能够通过该参数获得对象
        ServletContext application = sce.getServletContext();
        DicValueService ds= (DicValueService) ServiceFactory.getService(new DicValueServiceImp());
        Map<String, List<DicValue>> map=ds.getAll();
           Set<String> set = map.keySet();
           for (String s:set){
               application.setAttribute(s,map.get(s));
           }
           DicTypeService dicTypeService= (DicTypeService) ServiceFactory.getService(new DicTypeServiceImp());
           List<DicType> list1=dicTypeService.getAll();
           application.setAttribute("dicType",list1);
           DeptService deptService= (DeptService) ServiceFactory.getService(new DeptServiceImp());
           List<Dept> list=deptService.getAll();
           application.setAttribute("dept",list);
           //解析properties文件
           Map<String,String> map1=new HashMap<String,String>();
           ResourceBundle rb=ResourceBundle.getBundle("Stage2Possibility");
           Enumeration<String> e = rb.getKeys();
           while (e.hasMoreElements()){
               String key=e.nextElement();
               String value=rb.getString(key);
               map1.put(key,value);
           }
           application.setAttribute("map1",map1);
    }
}
