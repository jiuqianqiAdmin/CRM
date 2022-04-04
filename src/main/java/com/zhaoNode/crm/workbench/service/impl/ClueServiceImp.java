package com.zhaoNode.crm.workbench.service.impl;

import com.zhaoNode.crm.settings.dao.UserDao;
import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.utils.DateTimeUtil;
import com.zhaoNode.crm.utils.SqlSessionUtil;
import com.zhaoNode.crm.utils.UUIDUtil;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.dao.*;
import com.zhaoNode.crm.workbench.domain.*;
import com.zhaoNode.crm.workbench.service.ClueService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ClueServiceImp implements ClueService {
    //线索相关的表
    private ClueDao clueDao= SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
    private ClueActivityRelationDao clueActivityRelationDao= SqlSessionUtil.getSqlSession().getMapper(ClueActivityRelationDao.class);
    private ClueRemarkDao clueRemarkDao= SqlSessionUtil.getSqlSession().getMapper(ClueRemarkDao.class);
    //客户相关的表
    private CustomerDao customerDao= SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private CustomerRemarkDao customerRemarkDao= SqlSessionUtil.getSqlSession().getMapper(CustomerRemarkDao.class);
    //交易相关的表
    private TranDao TranDao= SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private TranHistoryDao tranHistoryDao= SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);
    //联系人相关的表
    private ContactsDao contactsDao= SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private ContactsRemarkDao contactsRemarkDao= SqlSessionUtil.getSqlSession().getMapper(ContactsRemarkDao.class);
    private ContactsActivityRelationDao contactsActivityRelationDao= SqlSessionUtil.getSqlSession().getMapper(ContactsActivityRelationDao.class);
    //活动和用户表
    private ActivityDao activityDao= SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private UserDao userDao= SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    public boolean save(Clue clue) {
        boolean flag=true;
        int count=clueDao.save(clue);
        if (count!=1){
            flag=false;
        }
        return flag;
    }

    public PaginationVO pageList(Map<String, Object> map) {
        PaginationVO<Clue> vo=new PaginationVO();
        int total=clueDao.getTotalByCondition(map);
        List<Clue> list=clueDao.getClueByCondition(map);
        vo.setTotal(total);
        vo.setDataList(list);
        return vo;
    }

    public Clue detail(String id) {
        Clue clue=clueDao.detail(id);
        return clue;
    }

    public List<Activity> showActivityList(String clueId) {
        List<Activity> list=activityDao.showActivityList(clueId);
        return list;
    }

    public boolean deleteActivityRelationById(String id) {
        boolean flag=true;
        int count=clueActivityRelationDao.deleteActivityRelationById(id);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public List<Activity> searchActivityBYNameAndClueId(Map<String, String> map) {
        List<Activity> list=activityDao.searchActivityBYNameAndClueId(map);
        return list;
    }

    public boolean saveActivityRelationBYActivityIdAndClueId(String clueId, String[] activityId) {
        boolean flag=true;
        for (String s:activityId){
            ClueActivityRelation car=new ClueActivityRelation();
            String id= UUIDUtil.getUUID();
            car.setId(id);
            car.setActivityId(s);
            car.setClueId(clueId);
            int count=clueActivityRelationDao.saveActivityRelationBYActivityIdAndClueId(car);
            if (count!=1){
                flag=false;
            }
        }
        return flag;
    }

    public List<Activity> searchActivityByName(String name) {
        List<Activity> list=activityDao.searchActivityByName(name);
        return list;
    }

    public Map<String,Object> getUserListAndClue(String id) {
        Map<String,Object> map=new HashMap<String,Object>();
        List<User> list=userDao.getUserList();
        Clue clue=clueDao.getClueById(id);
        map.put("list",list);
        map.put("clue",clue);
        return map;
    }

    public boolean updateClue(Clue clue) {
        boolean flag=true;
        int count=clueDao.updateClue(clue);
        if(count!=1){
            flag=false;
        }
        return flag;
    }

    public boolean deleteClueById(String[] id) {
        boolean flag=true;
        //删除与线索关联活动关系记录
        int count1=clueActivityRelationDao.getClueRelationByArr(id);
        int count2=clueActivityRelationDao.deleteClueRelationByClueIdArr(id);
        if(count1!=count2){
            flag=false;
        }
        int count3=clueDao.deleteClueById(id);
        if(count3!=id.length){
            flag=false;
        }
        return flag;
    }

    public boolean convert(String clueId, Tran t, String createBy) {
        boolean flag=true;
        String createTime= DateTimeUtil.getSysTime();
      //分析：转换的实现步骤？
      //(1) 获取到线索id，通过线索id获取线索对象（线索对象当中封装了线索的信息）
        Clue clue=clueDao.getClue(clueId);
        String company=clue.getCompany();
      //(2) 通过线索对象提取客户信息，当该客户不存在的时候，新建客户（根据公司的名称精确匹配，判断该客户是否存在！）

        Customer customer=customerDao.getCustomerByCompany(company);
        if(customer==null){
            customer=new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setWebsite(clue.getWebsite());
            customer.setPhone(clue.getPhone());
            customer.setOwner(clue.getOwner());
            customer.setNextContactTime(clue.getNextContactTime());
            customer.setName(company);
            customer.setDescription(clue.getDescription());
            customer.setCreateTime(createTime);
            customer.setCreateBy(createBy);
            customer.setContactSummary(clue.getContactSummary());
            customer.setAddress(clue.getAddress());
            int count=customerDao.save(customer);
            if(count!=1){
                flag=false;
            }
        }
      //(3) 通过线索对象提取联系人信息，保存联系人
        Contacts contacts=new Contacts();
        contacts.setSource(clue.getSource());
        contacts.setOwner(clue.getOwner());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setId(UUIDUtil.getUUID());
        contacts.setFullname(clue.getFullname());
        contacts.setEmail(clue.getEmail());
        contacts.setDescription(clue.getDescription());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(createTime);
        contacts.setCreateBy(createBy);
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setAppellation(clue.getAppellation());
        contacts.setAddress(clue.getAddress());
        int count2=contactsDao.save(contacts);
        if(count2!=1){
            flag=false;
        }
      //(4) 线索备注转换到客户备注以及联系人备注
        List<ClueRemark> clueRemarkList=clueRemarkDao.getRemarkByCoulId(clueId);
        for (ClueRemark c:clueRemarkList){
            //添加客户备注
            String noteContent=c.getNoteContent();
            CustomerRemark customerRemark=new CustomerRemark();
            customerRemark.setId(UUIDUtil.getUUID());
            customerRemark.setNoteContent(noteContent);
            customerRemark.setEditFlag("0");
            customerRemark.setCustomerId(customer.getId());
            customerRemark.setCreateTime(createTime);
            customerRemark.setCreateBy(createBy);
            int count3=customerRemarkDao.save(customerRemark);
            if(count3!=1){
                flag=false;
            }
            //添加联系人备注
            ContactsRemark contactsRemark=new ContactsRemark();
            contactsRemark.setId(UUIDUtil.getUUID());
            contactsRemark.setNoteContent(noteContent);
            contactsRemark.setEditFlag("0");
            contactsRemark.setContactsId(contacts.getId());
            contactsRemark.setCreateTime(createTime);
            contactsRemark.setCreateBy(createBy);
            int count4=contactsRemarkDao.save(contactsRemark);
            if(count4!=1){
                flag=false;
            }
        }
      //(5) “线索和市场活动”的关系转换到“联系人和市场活动”的关系
        List<ClueActivityRelation> clueActivityRelationList=clueActivityRelationDao.getActivityIdByClueId(clueId);
        for (ClueActivityRelation c:clueActivityRelationList){
            String activityId=c.getActivityId();
            ContactsActivityRelation contactsActivityRelation=new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtil.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contacts.getId());
            int count5=contactsActivityRelationDao.save(contactsActivityRelation);
            if(count5!=1){
                flag=false;
            }
        }
      //(6) 如果有创建交易需求，创建一条交易
        if(t!=null){
            t.setSource(clue.getSource());
            t.setOwner(clue.getOwner());
            t.setNextContactTime(clue.getNextContactTime());
            t.setDescription(clue.getDescription());
            t.setCustomerId(customer.getId());
            t.setContactSummary(clue.getContactSummary());
            t.setContactsId(contacts.getId());
            int count6=TranDao.save(t);
            if(count6!=1){
                flag=false;
            }
       //(7) 如果创建了交易，则创建一条该交易下的交易历史
            TranHistory tranHistory=new TranHistory();
            tranHistory.setTranId(t.getId());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(createBy);
            tranHistory.setCreateTime(createTime);
            tranHistory.setMoney(t.getMoney());
            tranHistory.setExpectedDate(t.getExpectedDate());
            tranHistory.setStage(t.getStage());
            int count7=tranHistoryDao.save(tranHistory);
            if(count7!=1){
                flag=false;
            }
        }

      //(8) 删除线索备注
      int count8=clueRemarkDao.deleteByClueId(clueId);
        if(count8!=clueRemarkList.size()){
            flag=false;
        }
      //(9) 删除线索和市场活动的关系
        String arr[]={clueId};
        int count9=clueActivityRelationDao.getClueRelationByArr(arr);
        int count10=clueActivityRelationDao.deleteClueRelationByClueIdArr(arr);
        if(count9!=count10){
            flag=false;
        }
        //(10) 删除线索
        int count3=clueDao.deleteClueById(arr);
        if(count3!=1){
            flag=false;
        }

        return flag;
    }

    public List<Map<String, Object>> showClueChart() {
        List<Map<String, Object>> list=clueDao.getChart();
        return list;
    }


}
