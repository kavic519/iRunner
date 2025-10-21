package com.zjgsu.irunner.entity;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "communities")
public class Community {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;                // 圈子名称

    @Column(length = 500)
    private String description;         // 描述

    @Column(name = "image_url")
    private String imageUrl = "default_community.jpg";  // 封面图

    @Column(name = "member_count")
    private Integer memberCount = 0;    // 成员数

    @Column(name = "created_by")
    private Long createdBy;             // 创建者

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "is_public")
    private Boolean isPublic = true;    // 是否公开

    // 用户-社区关系表（多对多）
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "user_community",
            joinColumns = @JoinColumn(name = "community_id"),
            inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private List<User> members = new ArrayList<>();

    // 构造函数
    public Community() {
        this.createdAt = LocalDateTime.now();
    }

    public Community(String name, String description, Long createdBy) {
        this();
        this.name = name;
        this.description = description;
        this.createdBy = createdBy;
    }

    // Getter 和 Setter 方法
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Integer getMemberCount() { return memberCount; }
    public void setMemberCount(Integer memberCount) { this.memberCount = memberCount; }

    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public Boolean getIsPublic() { return isPublic; }
    public void setIsPublic(Boolean isPublic) { this.isPublic = isPublic; }

    public List<User> getMembers() { return members; }
    public void setMembers(List<User> members) { this.members = members; }

    // 增加成员计数
    public void incrementMemberCount() {
        this.memberCount++;
    }

    // 减少成员计数
    public void decrementMemberCount() {
        if (this.memberCount > 0) {
            this.memberCount--;
        }
    }
}