package com.zhaoNode.crm.workbench.service;

import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.Contacts;
import com.zhaoNode.crm.workbench.domain.Tran;
import com.zhaoNode.crm.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    List<Activity> searchActivityBYName(String name);

    List<Contacts> searchContactsBYName(String name);

    boolean save(Tran t, String customerName);

    PaginationVO pageList(Map<String, Object> map);

    Tran detail(String id);

    List<TranHistory> showTranHistory(String tranId);

    boolean changeStage(Tran tran);

    List<Map<String, Object>> showTranChart();

    Map<String, Object> getUserListAndTran(String id);

    boolean update(Tran t, String customerName);

    boolean deleteTranById(String[] id);

    List<Tran> getTranRelation(String customerId);

    List<Tran> getTranRelationByContactsId(String contactsId);
}
