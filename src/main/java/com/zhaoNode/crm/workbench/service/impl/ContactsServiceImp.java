package com.zhaoNode.crm.workbench.service.impl;

import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.dao.*;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.Contacts;
import com.zhaoNode.crm.workbench.domain.ContactsActivityRelation;
import com.zhaoNode.crm.workbench.domain.Customer;
import com.zhaoNode.crm.workbench.service.ContactsService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContactsServiceImp implements ContactsService {
    private ContactsActivityRelationDao contactsActivityRelationDao= SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private CustomerDao customerDao=SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private TranDao TranDao=SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    public PaginationVO pageList(Map<String,Object> map) {
        PaginationVO<Contacts> vo=new PaginationVO();
        int total=contactsDao.getTotalByCondition(map);
        List<Contacts> list=contactsDao.pageList(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public boolean save(Contacts contacts, String customerName) {
        boolean flag=true;
        //精确查询客户，若不存在则新建
        Customer c=customerDao.searchCustomerByName(customerName);
        if(c==null){
            c=new Customer();
            c.setId(UUIDUtil.getUUID());
            c.setOwner(contacts.getOwner());
            c.setName(customerName);
            c.setNextContactTime(contacts.getNextContactTime());
            c.setDescription(contacts.getDescription());
            c.setCreateBy(contacts.getCreateBy());
            c.setContactSummary(contacts.getContactSummary());
            c.setCreateTime(DateTimeUtil.getSysTime());
            customerDao.save(c);
        }
        contacts.setCustomerId(c.getId());
        int count=contactsDao.save(contacts);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public Map<String, Object> getUserListAndContacts(String id) {
        Map<String, Object> map=new HashMap<String, Object>();
        List<User> list=userDao.getUserList();
        Contacts contacts=contactsDao.searchContactsBYId(id);
        map.put("contacts",contacts);
        map.put("list",list);
        return map;
    }

    public boolean updateContacts(Contacts contacts, String customerName) {
        boolean flag=true;
        Customer c=customerDao.searchCustomerByName(customerName);
        if(c==null){
            c=new Customer();
            c.setId(UUIDUtil.getUUID());
            c.setOwner(contacts.getOwner());
            c.setName(customerName);
            c.setNextContactTime(contacts.getNextContactTime());
            c.setDescription(contacts.getDescription());
            c.setCreateBy(contacts.getCreateBy());
            c.setContactSummary(contacts.getContactSummary());
            c.setCreateTime(DateTimeUtil.getSysTime());
            customerDao.save(c);
        }
        contacts.setCustomerId(c.getId());
        int count=contactsDao.update(contacts);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public Contacts detail(String id) {
        Contacts contacts=contactsDao.detail(id);
        return contacts;
    }

    public List<Activity> searchActivityBYName(Map<String,String> map) {
        List<Activity> list=activityDao.searchActivityByNameAndContactsId(map);
        return list;
    }

    public boolean activityRelationContacts(String contactsId, String[] activityId) {
        boolean flag=true;
        for (int i=0;i<activityId.length;i++){
            ContactsActivityRelation car=new ContactsActivityRelation();
            car.setId(UUIDUtil.getUUID());
            car.setContactsId(contactsId);
            car.setActivityId(activityId[i]);
            int count=contactsActivityRelationDao.save(car);
            if(count!=1){
                flag=false;
            }
        }
        return flag;
    }

    public List<Activity> showActivityList(String contactsId) {
        List<Activity> list=activityDao.showActivityListByContactsId(contactsId);
        return list;
    }

    public boolean deleteActivityRelationContacts(String activityId) {
        boolean flag=true;
        int count=contactsActivityRelationDao.deleteByActivityId(activityId);
        if(count!=1){
            flag=false;
        }

        return flag;
    }

    public boolean deleteTranRelationContacts(String id) {
        boolean flag=true;
        int count=TranDao.updateContacts(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean delete(String[] id) {
        boolean flag=true;
        int count=contactsDao.delete(id);
        if(count!=id.length){
            flag=false;
        }
        return flag;
    }
}
