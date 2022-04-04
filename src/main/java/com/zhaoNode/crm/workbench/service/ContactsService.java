package com.zhaoNode.crm.workbench.service;

import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    PaginationVO pageList(Map<String,Object> map);

    boolean save(Contacts contacts, String customerName);

    Map<String, Object> getUserListAndContacts(String id);

    boolean updateContacts(Contacts contacts, String customerName);

    Contacts detail(String id);

    List<Activity> searchActivityBYName(Map<String,String> map);

    boolean activityRelationContacts(String contactsId, String[] activityId);

    List<Activity> showActivityList(String contactsId);

    boolean deleteActivityRelationContacts(String activityId);

    boolean deleteTranRelationContacts(String id);

    boolean delete(String[] id);
}
