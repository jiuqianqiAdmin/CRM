package com.zhaoNode.crm.settings.dao;

import com.zhaoNode.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String, String> map);

    List<User> getUserList();

    String searchPwd(Map<String, String> map);

    int updatePwd(Map<String, String> map);

    int getTotalByCondition(Map<String, Object> map);

    List<User> getUserByCondition(Map<String, Object> map);

    int save(User user);

    int delete(String[] arr);

    User detail(String id);

    int update(User user);
}
