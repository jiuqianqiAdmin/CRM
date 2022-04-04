package com.zhaoNode.crm.workbench.service.impl;

import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.dao.*;
import com.zhaoNode.crm.workbench.domain.*;
import com.zhaoNode.crm.workbench.service.TranService;
import sun.security.krb5.internal.rcache.DflCache;

import java.util.HashMap;
import java.util.IdentityHashMap;
import java.util.List;
import java.util.Map;

public class TranServiceImp implements TranService {
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ContactsDao contactsDao=SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private TranDao TranDao=SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao=SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    private UserDao UserDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    
    public List<Activity> searchActivityBYName(String name) {
        List<Activity> list=activityDao.searchActivityByName(name);
        return list;
    }

    public List<Contacts> searchContactsBYName(String name) {
        List<Contacts> list=contactsDao.searchContactsBYName(name);
        return list;
    }

    public boolean save(Tran t, String customerName) {
        boolean flag=true;
        //精确查询客户，若不存在则新建
        Customer c=customerDao.searchCustomerByName(customerName);
        if(c==null){
            c=new Customer();
            c.setId(UUIDUtil.getUUID());
            c.setOwner(t.getOwner());
            c.setName(customerName);
            c.setNextContactTime(t.getNextContactTime());
            c.setDescription(t.getDescription());
            c.setCreateBy(t.getCreateBy());
            c.setContactSummary(t.getContactSummary());
            c.setCreateTime(DateTimeUtil.getSysTime());
            customerDao.save(c);
        }
        //创建交易
        t.setCustomerId(c.getId());
        int count=TranDao.save(t);
        if(count!=1){
            flag=false;
        }
        //创建交易历史
        TranHistory th=new TranHistory();
        th.setTranId(t.getId());
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getCreateBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setStage(t.getStage());
        int count1=tranHistoryDao.save(th);
        if(count1!=1){
            flag=false;
        }
        return flag;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO<Tran> vo=new PaginationVO();
        int total=TranDao.getTotalByCondition(map);
        List<Tran> list=TranDao.getCustomerByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public Tran detail(String id) {
       Tran t=TranDao.detail(id);
       return t;
    }

    public List<TranHistory> showTranHistory(String TranId) {
        List<TranHistory> list=tranHistoryDao.showTranHistory(TranId);
        return list;
    }

    public boolean changeStage(Tran tran) {
        boolean flag=true;
        int count=TranDao.changeStage(tran);
        if(count!=1){
            flag=false;
        }
        TranHistory th=new TranHistory();

        th.setTranId(tran.getId());
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(tran.getEditBy());
        th.setCreateTime(tran.getEditTime());
        th.setMoney(tran.getMoney());
        th.setExpectedDate(tran.getExpectedDate());
        th.setStage(tran.getStage());

        int count2=tranHistoryDao.save(th);
        if(count2!=1){
            flag=false;
        }
        return flag;
    }

    public List<Map<String, Object>> showTranChart() {
        List<Map<String,Object>> dataList=TranDao.getChars();
        return dataList;
    }

    public Map<String, Object> getUserListAndTran(String id) {
        Map<String, Object> map=new HashMap<String, Object>();
        List<User> list=UserDao.getUserList();
        Tran t=TranDao.getTran(id);
        map.put("list",list);
        map.put("t",t);
        return map;
    }

    public boolean update(Tran t, String customerName) {
        boolean flag=true;
        //精确查询客户，若不存在则新建
        Customer c=customerDao.searchCustomerByName(customerName);
        if(c==null){
            c=new Customer();
            c.setId(UUIDUtil.getUUID());
            c.setOwner(t.getOwner());
            c.setName(customerName);
            c.setNextContactTime(t.getNextContactTime());
            c.setDescription(t.getDescription());
            c.setCreateBy(t.getCreateBy());
            c.setContactSummary(t.getContactSummary());
            c.setCreateTime(DateTimeUtil.getSysTime());
            customerDao.save(c);
        }
        //修改交易
        t.setCustomerId(c.getId());
        int count=TranDao.update(t);
        if(count!=1){
            flag=false;
        }
        //创建修改交易历史
        TranHistory th=new TranHistory();
        th.setTranId(t.getId());
        th.setId(UUIDUtil.getUUID());
        th.setCreateBy(t.getCreateBy());
        th.setCreateTime(DateTimeUtil.getSysTime());
        th.setMoney(t.getMoney());
        th.setExpectedDate(t.getExpectedDate());
        th.setStage(t.getStage());
        int count1=tranHistoryDao.save(th);
        if(count1!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteTranById(String[] id) {
        boolean flag=true;
        int count=TranDao.deleteTranById(id);
        if(count!=id.length){
            flag=false;
        }
        return flag;
    }

    public List<Tran> getTranRelation(String customerId) {
        List<Tran> list=TranDao.getTranRelation(customerId);
        return list;
    }

    public List<Tran> getTranRelationByContactsId(String contactsId) {
        List<Tran> list=TranDao.getTranRelationByContactsId(contactsId);
        return list;
    }
}
