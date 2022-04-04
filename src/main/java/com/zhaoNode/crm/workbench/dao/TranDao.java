package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {

    int save(Tran t);

    int getTotalByCondition(Map<String, Object> map);

    List<Tran> getCustomerByCondition(Map<String, Object> map);

    Tran detail(String id);

    int changeStage(Tran tran);

    List<Map<String, Object>> getChars();

    Tran getTran(String id);

    int update(Tran t);

    int deleteTranById(String[] id);

    List<Tran> getTranRelation(String customerId);

    List<Tran> getTranRelationByContactsId(String contactsId);

    int updateContacts(String id);
}
