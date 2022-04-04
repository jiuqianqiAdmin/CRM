package com.zhaoNode.crm.workbench.service;

import com.zhaoNode.crm.settings.domain.User;
import com.zhaoNode.crm.vo.PaginationVO;
import com.zhaoNode.crm.workbench.domain.Activity;
import com.zhaoNode.crm.workbench.domain.Clue;
import com.zhaoNode.crm.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    PaginationVO pageList(Map<String, Object> map);

    Clue detail(String id);

    List<Activity> showActivityList(String id);

    boolean deleteActivityRelationById(String id);

    List<Activity> searchActivityBYNameAndClueId(Map<String, String> map);


    boolean saveActivityRelationBYActivityIdAndClueId(String clueId, String[] activityId);

    List<Activity> searchActivityByName(String name);

    Map<String,Object> getUserListAndClue(String id);

    boolean updateClue(Clue clue);

    boolean deleteClueById(String[] id);

    boolean convert(String clueId, Tran t, String createBy);

    List<Map<String, Object>> showClueChart();
}
