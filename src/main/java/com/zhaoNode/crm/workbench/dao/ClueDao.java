package com.zhaoNode.crm.workbench.dao;

import com.zhaoNode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {


    int save(Clue clue);

    int getTotalByCondition(Map<String, Object> map);

    List<Clue> getClueByCondition(Map<String, Object> map);

    Clue detail(String id);

    Clue getClueById(String id);

    int updateClue(Clue clue);

    int deleteClueById(String[] id);

    Clue getClue(String clueId);

    List<Map<String, Object>> getChart();
}
