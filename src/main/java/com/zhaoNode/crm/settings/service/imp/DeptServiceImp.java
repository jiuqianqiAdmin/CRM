package com.zhaoNode.crm.settings.service.imp;

import com.zhaoNode.crm.settings.dao.DeptDao;
import com.zhaoNode.crm.settings.dao.DicValueDao;
import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.service.DeptService;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public class DeptServiceImp implements DeptService {
    private DeptDao deptDao=  SqlSessionUtil.getSqlSession().getMapper(DeptDao.class);

    public List<Dept> getAll() {
        List<Dept> list=deptDao.getAll();
        return list;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO vo=new PaginationVO();
        int total=deptDao.getTotalByCondition();
        List<Dept> list=deptDao.getDeptByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public boolean saveDept(Dept dept) {
        boolean flag=true;
        int count=deptDao.save(dept);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public Dept editDept(String id) {
      Dept dept=deptDao.editDept(id);
      return dept;
    }

    public boolean updateDept(Dept dept) {
        boolean flag=true;
        int count=deptDao.update(dept);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteDept(String[] arr) {
        boolean flag=true;
        int count=deptDao.delete(arr);
        if(count!=arr.length){
            flag=false;
        }
        return flag;
    }
}
