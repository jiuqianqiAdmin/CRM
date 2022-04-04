package com.zhaoNode.crm.settings.dao;

import com.zhaoNode.crm.settings.domain.Dept;

import java.util.List;
import java.util.Map;

public interface DeptDao {
    List<Dept> getAll();

    int getTotalByCondition();

    List<Dept> getDeptByCondition(Map map);

    int save(Dept dept);

    Dept editDept(String id);

    int update(Dept dept);

    int delete(String[] arr);
}
