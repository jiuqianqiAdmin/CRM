package com.zhaoNode.crm.settings.dao;

import com.zhaoNode.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DicValueDao {
    List<DicValue> getValueByCode(String code);

    int getTotalByCondition();

    List<DicValue> getDicValueByCondition(Map<String, Object> map);

    int save(DicValue dicValue);

    DicValue edit(String id);

    int update(DicValue dicValue);

    int delete(String[] arr);
}

