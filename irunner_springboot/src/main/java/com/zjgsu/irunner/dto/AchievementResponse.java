package com.zjgsu.irunner.dto;

import java.time.LocalDateTime;

public class AchievementResponse {

    private Long id;
    private String code;
    private String name;
    private String description;
    private String iconUrl;
    private String conditionType;
    private Double conditionValue;
    private Boolean isUnlocked;
    private Double progress;
    private LocalDateTime unlockedAt;

    // 构造函数
    public AchievementResponse() {}

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getIconUrl() { return iconUrl; }
    public void setIconUrl(String iconUrl) { this.iconUrl = iconUrl; }

    public String getConditionType() { return conditionType; }
    public void setConditionType(String conditionType) { this.conditionType = conditionType; }

    public Double getConditionValue() { return conditionValue; }
    public void setConditionValue(Double conditionValue) { this.conditionValue = conditionValue; }

    public Boolean getIsUnlocked() { return isUnlocked; }
    public void setIsUnlocked(Boolean isUnlocked) { this.isUnlocked = isUnlocked; }

    public Double getProgress() { return progress; }
    public void setProgress(Double progress) { this.progress = progress; }

    public LocalDateTime getUnlockedAt() { return unlockedAt; }
    public void setUnlockedAt(LocalDateTime unlockedAt) { this.unlockedAt = unlockedAt; }
}
