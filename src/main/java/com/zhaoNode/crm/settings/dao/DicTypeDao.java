package com.zhaoNode.crm.settings.dao;

import com.zhaoNode.crm.settings.domain.DicType;

import java.util.List;
import java.util.Map;

public interface DicTypeDao {
    List<DicType> getTypeList();

    int getTotalByCondition();

    List<DicType> getDicTypeByCondition(Map<String, Object> map);

    int save(DicType dicType);

    DicType edit(String id);

    int update(Map<String, String> map);

    int delete(String[] arr);
}
