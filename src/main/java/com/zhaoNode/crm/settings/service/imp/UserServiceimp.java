package com.zhaoNode.crm.settings.service.imp;

import com.zhaoNode.crm.exception.LoginException;
import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.settings.service.UserService;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.MD5Util;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.vo.PaginationVO;

import javax.management.MBeanAttributeInfo;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceimp implements UserService {
    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map=new HashMap();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user=userDao.login(map);
        if(user==null){
            throw new LoginException("账号密码错误");
        }
        if("0".equals(user.getLockState())){
            throw new LoginException("账号已被锁定");
        }
        String time= DateTimeUtil.getSysTime();
        if(time.compareTo(user.getExpireTime())>0){
            throw new LoginException("账号已失效");
        }
        if(user.getAllowIps()!=null&&user.getAllowIps()!="") {
            if (!user.getAllowIps().contains(ip)) {
                throw new LoginException("ip地址受限，请联系管理员");
            }
        }
        return user;
    }

    public List<User> getUserList() {
        List<User> list=userDao.getUserList();
        return list;
    }

    public boolean updatePwd(Map<String, String> map) {
        boolean flag=true;
        String password=userDao.searchPwd(map);
        String oldPwd=map.get("oldPwd");
       if(!password.equals(oldPwd)){
           flag=false;
           return flag;
       }
        int count1=userDao.updatePwd(map);
        if(count1!=1){
            flag=false;
        }
        return flag;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO vo=new PaginationVO();
        int total=userDao.getTotalByCondition(map);
        List<User> list=userDao.getUserByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public boolean saveUser(User user) {
        boolean flag=true;
        int count=userDao.save(user);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteUserById(String[] arr) {
        boolean flag=true;
        int count=userDao.delete(arr);
        if(count!=arr.length){
            flag=false;
        }
        return flag;
    }

    public User detail(String id) {
        User user=userDao.detail(id);
        return user;
    }

    public boolean updateUser(User user) {
        boolean flag=true;
        int count=userDao.update(user);
        if(count!=1){
            flag=false;
        }
        return flag;
    }
}
