package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);

    List<Activity> getActivityByCondition(Map map);

    int getTotalByCondition(Map map);

    int delete(String[] arr);

    Activity getActivity(String id);

    int update(Activity activity);

    Activity detail(String id);

    List<Activity> showActivityList(String clueId);

    List<Activity> searchActivityBYNameAndClueId(Map<String, String> map);

    List<Activity> searchActivityByNameAndContactsId(Map<String,String> map);

    List<Map<String, Object>> getChart();

    List<Activity> showActivityListByContactsId(String contactsId);

    List<Activity> searchActivityByName(String name);
}
