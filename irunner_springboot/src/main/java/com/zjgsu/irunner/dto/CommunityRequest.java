package com.zjgsu.irunner.dto;

import javax.validation.constraints.NotBlank;

public class CommunityRequest {

    @NotBlank(message = "圈子名称不能为空")
    private String name;

    private String description;
    private String imageUrl;
    private Boolean isPublic = true;

    // 构造函数
    public CommunityRequest() {}

    public CommunityRequest(String name, String description) {
        this.name = name;
        this.description = description;
    }

    // Getter 和 Setter 方法
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Boolean getIsPublic() { return isPublic; }
    public void setIsPublic(Boolean isPublic) { this.isPublic = isPublic; }
}
