package com.zhaoNode.crm.workbench.service.impl;

import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.dao.ActivityDao;
import com.zhaoNode.crm.workbench.dao.ActivityRemarkDao;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.ActivityRemark;
import com.zhaoNode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImp implements ActivityService {
   private ActivityDao activityDao=SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
   private ActivityRemarkDao activityRemarkDao=SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
   private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

   public boolean save(Activity activity) {
      boolean flag;
      int count=activityDao.save(activity);
      if(count!=1){
         flag=false;
      }else {
         flag=true;
      }
      return flag;
   }

   public PaginationVO<Activity> pageList(Map map) {
      PaginationVO<Activity> vo=new PaginationVO();
      int total=activityDao.getTotalByCondition(map);
      List<Activity> list=activityDao.getActivityByCondition(map);
      vo.setTotal(total);
      vo.setDataList(list);
      return vo;
   }

   public boolean delete(String[] arr) {
      boolean flag=true;
      int count1=activityRemarkDao.getCountByArr(arr);
      int count2=activityRemarkDao.deleteByArr(arr);
      if(count1!=count2){
         flag=false;
      }
      int count3=activityDao.delete(arr);
      if(count3!=arr.length){
         flag=false;
      }
      return flag;
   }

   public Map<String, Object> getUserListAndActivity(String id) {
      Map<String,Object> map=new HashMap<String, Object>();
      List<User> uList=userDao.getUserList();
      Activity activity=activityDao.getActivity(id);
      map.put("uList",uList);
      map.put("a",activity);
      return map;
   }

   public boolean update(Activity activity) {
      boolean flag=true;
      int total=activityDao.update(activity);
      if(total!=1){
         flag=false;
      }
      return flag;
   }

   public Activity detail(String id) {
      Activity activity=activityDao.detail(id);
      return activity;
   }

   public List<ActivityRemark> getRemarkListByAid(String activityId) {
      List<ActivityRemark> list=activityRemarkDao.getRemarkListByAid(activityId);
      return list;
   }

   public boolean deleteRemark(String id) {
      boolean flag=true;
      int count=activityRemarkDao.deleteRemark(id);
      if(count!=1){
         flag=false;
      }
      return flag;
   }

   public boolean saveRemark(ActivityRemark ar) {
      boolean flag=true;
      int count=activityRemarkDao.saveRemark(ar);
      if(count!=1){
         flag=false;
      }
      return flag;
   }

   public boolean updateRemark(ActivityRemark ar) {
      boolean flag=true;
      int count=activityRemarkDao.updateRemark(ar);
      if(count!=1){
         flag=false;
      }
      return flag;
   }

   public List<Map<String, Object>> showActivityChart() {
      List<Map<String,Object>> list=activityDao.getChart();
      return list;
   }
}












