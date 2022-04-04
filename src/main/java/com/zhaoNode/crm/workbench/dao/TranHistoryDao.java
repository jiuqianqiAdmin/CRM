package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> showTranHistory(String id);
}
