package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.ContactsActivityRelation;

public interface ContactsActivityRelationDao {

    int save(ContactsActivityRelation contactsActivityRelation);

    int deleteByActivityId(String activityId);
}
