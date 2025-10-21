package com.zjgsu.irunner.service;

import com.zjgsu.irunner.dto.AchievementResponse;
import com.zjgsu.irunner.entity.*;
import com.zjgsu.irunner.mapper.AchievementMapper;
import com.zjgsu.irunner.mapper.UserAchievementMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class AchievementService {

    @Autowired
    private AchievementMapper achievementMapper;

    @Autowired
    private UserAchievementMapper userAchievementMapper;

    @Autowired
    private UserService userService;

    /**
     * 初始化成就数据
     */
    public void initializeAchievements() {
        // 检查是否已初始化
        if (achievementMapper.count() > 0) {
            return;
        }

        // 创建基础成就
        List<Achievement> achievements = List.of(
                new Achievement("first_run", "初次征程", "完成你的第一次跑步", "TOTAL_RUNS", 1.0),
                new Achievement("one_kilometer", "一公里跑者", "单次跑步距离超过 1 公里", "SINGLE_DISTANCE", 1000.0),
                new Achievement("ten_minutes", "耐力跑者", "单次跑步时长超过 10 分钟", "SINGLE_DURATION", 600.0),
                new Achievement("three_runs", "坚持不懈", "累计跑步次数达到 3 次", "TOTAL_RUNS", 3.0),
                new Achievement("marathon", "马拉松选手", "累计跑步距离达到 42.195 公里", "TOTAL_DISTANCE", 42195.0)
        );

        achievementMapper.insertBatch(achievements);
    }

    /**
     * 检查并更新用户成就
     */
    public List<Achievement> checkAndUpdateAchievements(Long userId, RunSession runSession) {
        User user = userService.getUserById(userId);
        List<Achievement> newlyUnlocked = new java.util.ArrayList<>();

        // 获取所有成就
        List<Achievement> allAchievements = achievementMapper.selectAll();

        for (Achievement achievement : allAchievements) {
            UserAchievement userAchievement = getUserAchievement(user, achievement);
            boolean wasUnlocked = userAchievement.getIsUnlocked();

            // 检查成就条件
            checkAchievementCondition(userAchievement, runSession, user);

            // 如果新解锁了成就
            if (!wasUnlocked && userAchievement.getIsUnlocked()) {
                newlyUnlocked.add(achievement);
            }

            if (userAchievement.getId() == null) {
                userAchievementMapper.insert(userAchievement);
            } else {
                userAchievementMapper.update(userAchievement);
            }
        }

        return newlyUnlocked;
    }

    /**
     * 获取用户成就关联
     */
    private UserAchievement getUserAchievement(User user, Achievement achievement) {
        UserAchievement existing = userAchievementMapper.selectByUserIdAndAchievementId(
                user.getId(), achievement.getId());

        if (existing != null) {
            return existing;
        } else {
            UserAchievement userAchievement = new UserAchievement();
            userAchievement.setUserId(user.getId());
            userAchievement.setAchievementId(achievement.getId());
            userAchievement.setAchievement(achievement);
            userAchievement.setUser(user);
            userAchievement.setIsUnlocked(false);
            userAchievement.setProgress(0.0);
            return userAchievement;
        }
    }

    /**
     * 检查成就条件（保持不变）
     */
    private void checkAchievementCondition(UserAchievement userAchievement,
                                           RunSession runSession, User user) {
        if (userAchievement.getIsUnlocked()) {
            return; // 已解锁的成就不再检查
        }

        Achievement achievement = userAchievement.getAchievement();
        String conditionType = achievement.getConditionType();
        Double conditionValue = achievement.getConditionValue();

        switch (conditionType) {
            case "TOTAL_RUNS":
                userAchievement.setProgress((double) user.getTotalRuns());
                if (user.getTotalRuns() >= conditionValue) {
                    userAchievement.setIsUnlocked(true);
                }
                break;

            case "TOTAL_DISTANCE":
                userAchievement.setProgress(user.getTotalDistance());
                if (user.getTotalDistance() >= conditionValue) {
                    userAchievement.setIsUnlocked(true);
                }
                break;

            case "SINGLE_DISTANCE":
                if (runSession.getDistanceMeters() >= conditionValue) {
                    userAchievement.setProgress(conditionValue);
                    userAchievement.setIsUnlocked(true);
                } else {
                    userAchievement.setProgress(runSession.getDistanceMeters());
                }
                break;

            case "SINGLE_DURATION":
                if (runSession.getDurationSeconds() >= conditionValue) {
                    userAchievement.setProgress(conditionValue.doubleValue());
                    userAchievement.setIsUnlocked(true);
                } else {
                    userAchievement.setProgress((double) runSession.getDurationSeconds());
                }
                break;
        }
    }

    /**
     * 获取用户的所有成就
     */
    public List<UserAchievement> getUserAchievements(Long userId) {
        return userAchievementMapper.selectByUserId(userId);
    }

    /**
     * 获取用户已解锁的成就
     */
    public List<UserAchievement> getUnlockedAchievements(Long userId) {
        return userAchievementMapper.selectUnlockedByUserId(userId);
    }

    /**
     * 获取成就响应对象
     */
    public AchievementResponse getAchievementResponse(UserAchievement userAchievement) {
        Achievement achievement = userAchievement.getAchievement();

        AchievementResponse response = new AchievementResponse();
        response.setId(achievement.getId());
        response.setCode(achievement.getCode());
        response.setName(achievement.getName());
        response.setDescription(achievement.getDescription());
        response.setIconUrl(achievement.getIconUrl());
        response.setConditionType(achievement.getConditionType());
        response.setConditionValue(achievement.getConditionValue());
        response.setIsUnlocked(userAchievement.getIsUnlocked());
        response.setProgress(userAchievement.getProgress());
        response.setUnlockedAt(userAchievement.getUnlockedAt());

        return response;
    }
}