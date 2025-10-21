package com.zjgsu.irunner.service;

import com.zjgsu.irunner.dto.CommunityRequest;
import com.zjgsu.irunner.dto.CommunityResponse;
import com.zjgsu.irunner.entity.Community;
import com.zjgsu.irunner.entity.User;
import com.zjgsu.irunner.mapper.CommunityMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class CommunityService {

    private static final Logger logger = LoggerFactory.getLogger(CommunityService.class);

    @Autowired
    private CommunityMapper communityMapper;

    @Autowired
    private UserService userService;

    /**
     * 创建社区圈子
     */
    public Community createCommunity(CommunityRequest request, Long creatorId) {
        try {
            // 检查圈子名称是否已存在
            if (communityMapper.selectByName(request.getName()) != null) {
                logger.warn("圈子名称已存在: {}", request.getName());
                throw new RuntimeException("圈子名称已存在");
            }
            // 检查创建者是否存在
            User creator = userService.getUserById(creatorId);
            if (creator == null) {
                logger.error("创建者不存在: {}", creatorId);
                throw new RuntimeException("创建者不存在");
            }
            // 创建社区
            Community community = new Community(
                    request.getName(),
                    request.getDescription(),
                    creatorId
            );
            // 设置图片URL
            if (request.getImageUrl() != null) {
                community.setImageUrl(request.getImageUrl());
            }
            // 设置是否公开
            if (request.getIsPublic() != null) {
                community.setIsPublic(request.getIsPublic());
            }
            // 保存圈子到数据库
            communityMapper.insert(community);
            return community;

        } catch (Exception e) {
            logger.error("创建社区圈子失败: {}", e.getMessage(), e);
            throw new RuntimeException("创建社区圈子失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有公开圈子
     */
    public List<Community> getPublicCommunities() {
        return communityMapper.selectPublicCommunities();
    }

    /**
     * 搜索圈子
     */
    public List<Community> searchCommunities(String keyword) {
        return communityMapper.selectByKeyword(keyword);
    }

    /**
     * 根据ID获取圈子
     */
    public Community getCommunityById(Long id) {
        Community community = communityMapper.selectById(id);
        if (community == null) {
            throw new RuntimeException("圈子不存在");
        }
        return community;
    }

    /**
     * 用户加入圈子
     */
    public void joinCommunity(Long userId, Long communityId) {

        // 检查用户是否已加入该圈子
        if (communityMapper.existsUserCommunity(userId, communityId)) {
            throw new RuntimeException("用户已加入该圈子");
        }

        // 添加用户-社区关联
        communityMapper.insertUserCommunity(userId, communityId);

        // 更新成员计数
        communityMapper.incrementMemberCount(communityId);
    }

    /**
     * 用户退出圈子
     */
    public void leaveCommunity(Long userId, Long communityId) {

        // 检查用户是否已加入该圈子
        if (!communityMapper.existsUserCommunity(userId, communityId)) {
            throw new RuntimeException("用户未加入该圈子");
        }

        // 移除用户-社区关联
        communityMapper.deleteUserCommunity(userId, communityId);

        // 更新成员计数
        communityMapper.decrementMemberCount(communityId);
    }

    /**
     * 获取用户加入的圈子
     */
    public List<Community> getUserCommunities(Long userId) {
        return communityMapper.selectByUserId(userId);
    }

    /**
     * 获取圈子响应对象
     */
    public CommunityResponse getCommunityResponse(Community community, Long userId) {
        CommunityResponse response = new CommunityResponse();
        response.setId(community.getId());
        response.setName(community.getName());
        response.setDescription(community.getDescription());
        response.setImageUrl(community.getImageUrl());
        response.setMemberCount(community.getMemberCount());
        response.setCreatedBy(community.getCreatedBy());
        response.setCreatedAt(community.getCreatedAt());
        response.setIsPublic(community.getIsPublic());

        // 检查用户是否已加入该圈子
        if (userId != null) {
            boolean isJoined = communityMapper.existsUserCommunity(userId, community.getId());
            response.setIsJoined(isJoined);
        } else {
            response.setIsJoined(false);
        }

        return response;
    }
}