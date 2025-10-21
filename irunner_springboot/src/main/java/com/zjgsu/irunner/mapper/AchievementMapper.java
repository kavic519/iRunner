package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.Achievement;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface AchievementMapper {

    /**
     * 插入成就
     */
    int insert(Achievement achievement);

    /**
     * 根据ID查询成就
     */
    Achievement selectById(Long id);

    /**
     * 根据成就代码查询
     */
    Achievement selectByCode(String code);

    /**
     * 查询所有成就
     */
    List<Achievement> selectAll();

    /**
     * 更新成就
     */
    int update(Achievement achievement);

    /**
     * 删除成就
     */
    int deleteById(Long id);

    /**
     * 统计成就数量
     */
    Long count();

    /**
     * 批量插入成就
     */
    int insertBatch(@Param("list") List<Achievement> achievements);
}