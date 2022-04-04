package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.Customer;
import java.util.List;
import java.util.Map;

public interface CustomerDao {

    Customer getCustomerByCompany(String company);

    int save(Customer customer);

    List<String> getCustomerName(String name);

    int getTotalByCondition(Map<String, Object> map);

    List<Customer> getCustomerByCondition(Map<String, Object> map);

    Customer getCustomerById(String id);

    int update(Customer customer);

    int delete(String[] arr);

    Customer detail(String id);

    Customer searchCustomerByName(String customerName);
}
