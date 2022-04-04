package com.zhaoNode.crm.settings.service;

import com.zhaoNode.crm.exception.LoginException;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.vo.PaginationVO;

import java.util.List;
import java.util.Map;

public interface UserService {
    User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();

    boolean updatePwd(Map<String, String> map);

    PaginationVO pageList(Map<String, Object> map);

    boolean saveUser(User user);

    boolean deleteUserById(String[] arr);

    User detail(String id);

    boolean updateUser(User user);
}
