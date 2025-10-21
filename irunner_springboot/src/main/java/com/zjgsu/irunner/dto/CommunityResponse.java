package com.zjgsu.irunner.dto;

import java.time.LocalDateTime;

public class CommunityResponse {

    private Long id;
    private String name;
    private String description;
    private String imageUrl;
    private Integer memberCount;
    private Long createdBy;
    private LocalDateTime createdAt;
    private Boolean isPublic;
    private Boolean isJoined;

    // 构造函数
    public CommunityResponse() {}

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

    public Boolean getIsJoined() { return isJoined; }
    public void setIsJoined(Boolean isJoined) { this.isJoined = isJoined; }
}
