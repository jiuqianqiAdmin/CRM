package com.zhaoNode.crm.settings.service.imp;

import com.zhaoNode.crm.settings.dao.DicTypeDao;
import com.zhaoNode.crm.settings.dao.DicValueDao;
import com.zhaoNode.crm.settings.domain.DicType;
import com.zhaoNode.crm.settings.domain.DicValue;
import com.zhaoNode.crm.settings.service.DicValueService;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DicValueServiceImp implements DicValueService {
    private DicTypeDao dicTypeDao=  SqlSessionUtil.getSqlSession().getMapper(DicTypeDao.class);
    private DicValueDao dicValueDao=  SqlSessionUtil.getSqlSession().getMapper(DicValueDao.class);

    public Map<String, List<DicValue>> getAll() {
        Map<String, List<DicValue>> map=new HashMap<String, List<DicValue>>();
        List<DicType> list=dicTypeDao.getTypeList();
        for (DicType D:list){
            String code =D.getCode();
            List<DicValue> dlist=dicValueDao.getValueByCode(code);
            map.put(code,dlist);
        }
        return map;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO vo=new PaginationVO();
        int total=dicValueDao.getTotalByCondition();
        List<DicValue> list=dicValueDao.getDicValueByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;

    }

    public boolean saveDicValue(DicValue dicValue) {
        boolean flag=true;
        int count=dicValueDao.save(dicValue);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public DicValue edit(String id) {
        DicValue dicValue=dicValueDao.edit(id);
        return dicValue;
    }

    public boolean updateDicValue(DicValue dicValue) {
        boolean flag=true;
        int count=dicValueDao.update(dicValue);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteDicValue(String[] arr) {
        boolean flag=true;
        int count=dicValueDao.delete(arr);
        if(count!=arr.length){
            flag=false;
        }
        return flag;
    }
}
