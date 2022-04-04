package com.zhaoNode.crm.settings.service;

import com.zhaoNode.crm.settings.domain.DicValue;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface DicValueService {

    Map<String, List<DicValue>> getAll();

    PaginationVO pageList(Map<String, Object> map);

    boolean saveDicValue(DicValue dicValue);

    DicValue edit(String id);

    boolean updateDicValue(DicValue dicValue);

    boolean deleteDicValue(String[] arr);
}
