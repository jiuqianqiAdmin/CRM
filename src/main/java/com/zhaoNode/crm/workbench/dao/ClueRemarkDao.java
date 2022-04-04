package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {

    List<ClueRemark> getRemarkByCoulId(String clueId);

    int deleteByClueId(String clueId);
}
