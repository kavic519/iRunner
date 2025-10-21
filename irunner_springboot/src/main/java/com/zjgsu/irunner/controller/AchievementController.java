package com.zjgsu.irunner.controller;

import com.zjgsu.irunner.dto.ApiResponse;
import com.zjgsu.irunner.dto.AchievementResponse;
import com.zjgsu.irunner.entity.UserAchievement;
import com.zjgsu.irunner.service.AchievementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/achievements")
public class AchievementController {

    @Autowired
    private AchievementService achievementService;

    /**
     * 获取用户的所有成就
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<ApiResponse<List<AchievementResponse>>> getUserAchievements(
            @PathVariable Long userId) {
        try {
            List<UserAchievement> userAchievements = achievementService.getUserAchievements(userId);
            List<AchievementResponse> responses = userAchievements.stream()
                    .map(achievementService::getAchievementResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取用户成就失败"));
        }
    }

    /**
     * 获取用户已解锁的成就
     */
    @GetMapping("/users/{userId}/unlocked")
    public ResponseEntity<ApiResponse<List<AchievementResponse>>> getUnlockedAchievements(
            @PathVariable Long userId) {
        try {
            List<UserAchievement> userAchievements = achievementService.getUnlockedAchievements(userId);
            List<AchievementResponse> responses = userAchievements.stream()
                    .map(achievementService::getAchievementResponse)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取已解锁成就失败"));
        }
    }
}
