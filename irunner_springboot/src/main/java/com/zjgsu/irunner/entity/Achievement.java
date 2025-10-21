package com.zjgsu.irunner.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "achievements")
public class Achievement {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String code;            // 成就代码

    @Column(nullable = false)
    private String name;            // 成就名称

    @Column(length = 500)
    private String description;     // 成就描述

    @Column(name = "icon_url")
    private String iconUrl;         // 成就图标

    @Column(name = "condition_type")
    private String conditionType; // 条件类型 "TOTAL_RUNS", "DISTANCE", "DURATION", etc.

    @Column(name = "condition_value")
    private Double conditionValue;// 条件数值

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // 构造函数
    public Achievement() {
        this.createdAt = LocalDateTime.now();
    }

    public Achievement(String code, String name, String description, String conditionType, Double conditionValue) {
        this();
        this.code = code;
        this.name = name;
        this.description = description;
        this.conditionType = conditionType;
        this.conditionValue = conditionValue;
    }

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

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}