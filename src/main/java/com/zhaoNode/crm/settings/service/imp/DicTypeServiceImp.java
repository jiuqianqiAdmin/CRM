package com.zhaoNode.crm.settings.service.imp;

import com.zhaoNode.crm.settings.dao.DicTypeDao;
import com.zhaoNode.crm.settings.domain.Dept;
import com.zhaoNode.crm.settings.domain.DicType;
import com.zhaoNode.crm.settings.service.DicTypeService;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public class DicTypeServiceImp implements DicTypeService {
    private DicTypeDao dicTypeDao=  SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO vo=new PaginationVO();
        int total=dicTypeDao.getTotalByCondition();
        List<DicType> list=dicTypeDao.getDicTypeByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;

    }

    public boolean saveDicType(DicType dicType) {
        boolean flag=true;
        int count=dicTypeDao.save(dicType);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public DicType edit(String id) {
        DicType dicType=dicTypeDao.edit(id);
        return dicType;
    }

    public boolean updateDicType(Map<String, String> map) {
        boolean flag=true;
        int count=dicTypeDao.update(map);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteDicType(String[] arr) {
        boolean flag=true;
        int count=dicTypeDao.delete(arr);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public List<DicType> getAll() {
        List<DicType> list=dicTypeDao.getTypeList();
        return list;
    }
}
