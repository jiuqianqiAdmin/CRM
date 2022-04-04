package com.zhaoNode.crm.workbench.service;

import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.Contacts;
import com.zhaoNode.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    List<String> getCustomerName(String name);

    boolean save(Customer customer);

    PaginationVO pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndCustomer(String id);

    boolean update(Customer customer);

    boolean delete(String[] arr);

    Customer detail(String id);

    List<Contacts> showContacts(String customerId);

    boolean updateContactsCustomerId(String id);
}
