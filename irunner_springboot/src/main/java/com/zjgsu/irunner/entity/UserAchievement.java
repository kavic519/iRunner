package com.zjgsu.irunner.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_achievements")
public class UserAchievement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "unlocked_at")
    private LocalDateTime unlockedAt;   // 解锁时间

    @Column(name = "progress")
    private Double progress = 0.0;      // 当前进度

    @Column(name = "is_unlocked")
    private Boolean isUnlocked = false; // 是否解锁

    // 添加基本类型ID字段用于MyBatis
    @Column(name = "user_id")
    private Long userId;

    @Column(name = "achievement_id")
    private Long achievementId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", insertable = false, updatable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "achievement_id", insertable = false, updatable = false)
    private Achievement achievement;



    // 构造函数
    public UserAchievement() {}

    public UserAchievement(User user, Achievement achievement) {
        this.user = user;
        this.achievement = achievement;
        this.userId = user.getId();
        this.achievementId = achievement.getId();
        this.unlockedAt = LocalDateTime.now();
        this.isUnlocked = true;
    }

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getAchievementId() { return achievementId; }
    public void setAchievementId(Long achievementId) {
        this.achievementId = achievementId;
    }

    public User getUser() { return user; }
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }

    public Achievement getAchievement() { return achievement; }
    public void setAchievement(Achievement achievement) {
        this.achievement = achievement;
        if (achievement != null) {
            this.achievementId = achievement.getId();
        }
    }

    public LocalDateTime getUnlockedAt() { return unlockedAt; }
    public void setUnlockedAt(LocalDateTime unlockedAt) { this.unlockedAt = unlockedAt; }

    public Double getProgress() { return progress; }
    public void setProgress(Double progress) { this.progress = progress; }

    public Boolean getIsUnlocked() { return isUnlocked; }
    public void setIsUnlocked(Boolean isUnlocked) {
        this.isUnlocked = isUnlocked;
        if (isUnlocked && this.unlockedAt == null) {
            this.unlockedAt = LocalDateTime.now();
        }
    }
}