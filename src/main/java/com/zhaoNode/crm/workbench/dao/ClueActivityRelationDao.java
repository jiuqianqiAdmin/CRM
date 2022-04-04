package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationDao {


    int deleteActivityRelationById(String id);

    int saveActivityRelationBYActivityIdAndClueId(ClueActivityRelation car);

    int getClueRelationByArr(String[] id);

    int deleteClueRelationByClueIdArr(String[] id);

    List<ClueActivityRelation> getActivityIdByClueId(String clueId);
}
