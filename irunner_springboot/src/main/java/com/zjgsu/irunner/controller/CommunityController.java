package com.zjgsu.irunner.controller;

import com.zjgsu.irunner.dto.ApiResponse;
import com.zjgsu.irunner.dto.CommunityRequest;
import com.zjgsu.irunner.dto.CommunityResponse;
import com.zjgsu.irunner.entity.Community;
import com.zjgsu.irunner.service.CommunityService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/communities")
public class CommunityController {

    private static final Logger logger = LoggerFactory.getLogger(CommunityController.class);

    @Autowired
    private CommunityService communityService;

    /**
     * 创建社区圈子
     */
    @PostMapping
    public ResponseEntity<ApiResponse<CommunityResponse>> createCommunity(
            @Valid @RequestBody CommunityRequest request,
            @RequestParam Long creatorId) {
        try {
            logger.info("收到创建社区请求: {}, 创建者ID: {}", request.getName(), creatorId);

            Community community = communityService.createCommunity(request, creatorId);
            CommunityResponse response = communityService.getCommunityResponse(community, creatorId);

            logger.info("社区创建成功: {}", community.getId());
            return ResponseEntity.ok(ApiResponse.success("圈子创建成功", response));

        } catch (RuntimeException e) {
            logger.error("创建社区失败: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        } catch (Exception e) {
            logger.error("创建社区时发生未知错误: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().body(ApiResponse.error("服务器内部错误"));
        }
    }

    /**
     * 获取所有公开圈子
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> getPublicCommunities(
            @RequestParam(required = false) Long userId) {
        try {
            List<Community> communities = communityService.getPublicCommunities();
            List<CommunityResponse> responses = communities.stream()
                    .map(community -> communityService.getCommunityResponse(community, userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取圈子列表失败"));
        }
    }

    /**
     * 搜索圈子
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> searchCommunities(
            @RequestParam String keyword,
            @RequestParam(required = false) Long userId) {
        try {
            List<Community> communities = communityService.searchCommunities(keyword);
            List<CommunityResponse> responses = communities.stream()
                    .map(community -> communityService.getCommunityResponse(community, userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("搜索圈子失败"));
        }
    }

    /**
     * 获取圈子详情
     */
    @GetMapping("/{communityId}")
    public ResponseEntity<ApiResponse<CommunityResponse>> getCommunity(
            @PathVariable Long communityId,
            @RequestParam(required = false) Long userId) {
        try {
            Community community = communityService.getCommunityById(communityId);
            CommunityResponse response = communityService.getCommunityResponse(community, userId);
            return ResponseEntity.ok(ApiResponse.success(response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 用户加入圈子
     */
    @PostMapping("/{communityId}/join")
    public ResponseEntity<ApiResponse<Void>> joinCommunity(
            @PathVariable Long communityId,
            @RequestParam Long userId) {
        try {
            communityService.joinCommunity(userId, communityId);
            return ResponseEntity.ok(ApiResponse.success("加入圈子成功", null));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 用户退出圈子
     */
    @PostMapping("/{communityId}/leave")
    public ResponseEntity<ApiResponse<Void>> leaveCommunity(
            @PathVariable Long communityId,
            @RequestParam Long userId) {
        try {
            communityService.leaveCommunity(userId, communityId);
            return ResponseEntity.ok(ApiResponse.success("退出圈子成功", null));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 获取用户加入的圈子
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<ApiResponse<List<CommunityResponse>>> getUserCommunities(
            @PathVariable Long userId) {
        try {
            List<Community> communities = communityService.getUserCommunities(userId);
            List<CommunityResponse> responses = communities.stream()
                    .map(community -> communityService.getCommunityResponse(community, userId))
                    .collect(Collectors.toList());
            return ResponseEntity.ok(ApiResponse.success(responses));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取用户圈子失败"));
        }
    }
}
