package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.UserAchievement;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserAchievementMapper {

    /**
     * 插入用户成就关联
     */
    int insert(UserAchievement userAchievement);

    /**
     * 根据ID查询用户成就关联
     */
    UserAchievement selectById(Long id);

    /**
     * 根据用户ID和成就ID查询
     */
    UserAchievement selectByUserIdAndAchievementId(@Param("userId") Long userId,
                                                   @Param("achievementId") Long achievementId);

    /**
     * 查询用户的所有成就关联
     */
    List<UserAchievement> selectByUserId(Long userId);

    /**
     * 查询用户已解锁的成就
     */
    List<UserAchievement> selectUnlockedByUserId(Long userId);

    /**
     * 更新用户成就关联
     */
    int update(UserAchievement userAchievement);

    /**
     * 删除用户成就关联
     */
    int deleteById(Long id);

    /**
     * 统计用户已解锁成就数量
     */
    Integer countUnlockedByUserId(Long userId);

    /**
     * 批量插入用户成就关联
     */
    int insertBatch(@Param("list") List<UserAchievement> userAchievements);

    /**
     * 批量更新用户成就关联
     */
    int updateBatch(@Param("list") List<UserAchievement> userAchievements);
}