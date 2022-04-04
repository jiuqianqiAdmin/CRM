package com.zhaoNode.crm.workbench.service.impl;

import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.dao.ContactsDao;
import com.zhaoNode.crm.workbench.dao.CustomerDao;
import com.zhaoNode.crm.workbench.domain.Clue;
import com.zhaoNode.crm.workbench.domain.Contacts;
import com.zhaoNode.crm.workbench.domain.Customer;
import com.zhaoNode.crm.workbench.service.CustomerService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CustomerServiceImp  implements CustomerService {
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private UserDao userDao=SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    public List<String> getCustomerName(String name) {
        List<String> list=customerDao.getCustomerName(name);
        return list;
    }

    public boolean save(Customer customer) {
        boolean flag=true;
        int count=customerDao.save(customer);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO<Customer> vo=new PaginationVO();
        int total=customerDao.getTotalByCondition(map);
        List<Customer> list=customerDao.getCustomerByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public Map<String, Object> getUserListAndCustomer(String id) {
        Map<String, Object> map=new HashMap<String, Object>();
        List<User> list=userDao.getUserList();
        Customer customer=customerDao.getCustomerById(id);
        map.put("list",list);
        map.put("customer",customer);
        return map;
    }

    public boolean update(Customer customer) {
        boolean falg=true;
        int count=customerDao.update(customer);
        if(count!=1){
            falg=false;
        }
        return falg;
    }

    public boolean delete(String[] arr) {
        boolean flag=true;
        int count=customerDao.delete(arr);
        if(count!=arr.length){
            flag=false;
        }
        return flag;
    }

    public Customer detail(String id) {
        Customer customer=customerDao.detail(id);
        return customer;
    }

    public List<Contacts> showContacts(String customerId) {
        List<Contacts> list=contactsDao.showContactsByCustomerId(customerId);
        return list;
    }

    public boolean updateContactsCustomerId(String id) {
        boolean flag=true;
        int count=contactsDao.updateContactsCustomerId(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
