package com.zhaoNode.crm.settings.service;

import com.zhaoNode.crm.settings.domain.DicType;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface DicTypeService {
    PaginationVO pageList(Map<String, Object> map);

    boolean saveDicType(DicType dicType);

    DicType edit(String id);

    boolean updateDicType(Map<String, String> map);

    boolean deleteDicType(String[] arr);

    List<DicType> getAll();
}
