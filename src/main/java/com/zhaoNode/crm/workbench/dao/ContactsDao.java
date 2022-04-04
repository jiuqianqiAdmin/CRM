package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.Contacts;

import java.util.List;
import java.util.Map;

public interface ContactsDao {

    int save(Contacts contacts);

    List<Contacts> searchContactsBYName(String name);

    List<Contacts> pageList(Map<String,Object> map);

    int getTotalByCondition(Map<String, Object> map);

    Contacts searchContactsBYId(String id);

    int update(Contacts contacts);

    Contacts detail(String id);

    List<Contacts> showContactsByCustomerId(String customerId);

    int updateContactsCustomerId(String id);

    int delete(String[] id);
}
