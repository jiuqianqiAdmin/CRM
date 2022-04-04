package com.zhaoNode.crm.settings.service;

import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface DeptService {
    List<Dept> getAll();

    PaginationVO pageList(Map<String, Object> map);

    boolean saveDept(Dept dept);

    Dept editDept(String id);

    boolean updateDept(Dept dept);

    boolean deleteDept(String[] arr);
}
