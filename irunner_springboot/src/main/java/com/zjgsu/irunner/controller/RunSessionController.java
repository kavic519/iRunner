package com.zjgsu.irunner.controller;

import com.zjgsu.irunner.dto.ApiResponse;
import com.zjgsu.irunner.dto.RunSessionRequest;
import com.zjgsu.irunner.dto.RunSessionResponse;
import com.zjgsu.irunner.entity.RunSession;
import com.zjgsu.irunner.service.RunSessionService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/runs")
public class RunSessionController {

    private static final Logger logger = LoggerFactory.getLogger(RunSessionController.class);

    @Autowired
    private RunSessionService runSessionService;

    /**
     * 创建跑步记录
     */
    @PostMapping("/users/{userId}")
    public ResponseEntity<ApiResponse<RunSessionResponse>> createRunSession(
            @PathVariable Long userId,
            @Valid @RequestBody RunSessionRequest request) {
        try {
            RunSession runSession = runSessionService.createRunSession(userId, request);
            RunSessionResponse response = runSessionService.getRunSessionResponse(runSession);
            return ResponseEntity.ok(ApiResponse.success("跑步记录创建成功", response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 获取用户的所有跑步记录
     */
    @GetMapping("/users/{userId}")
    public ResponseEntity<ApiResponse<List<RunSessionResponse>>> getUserRunSessions(
            @PathVariable Long userId) {
        try {
            logger.info("开始处理获取用户 {} 跑步记录的请求", userId);
            List<RunSession> runSessions = runSessionService.getUserRunSessions(userId);
            List<RunSessionResponse> responses = runSessions.stream()
                    .map(runSessionService::getRunSessionResponse)
                    .collect(Collectors.toList());

            logger.info("成功返回 {} 条跑步记录", responses.size());
            return ResponseEntity.ok(ApiResponse.success(responses));

        } catch (Exception e) {
            logger.error("获取用户跑步记录失败: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(ApiResponse.error("获取跑步记录失败: " + e.getMessage()));
        }
    }

    /**
     * 获取用户的最近跑步记录
     */
    @GetMapping("/users/{userId}/recent")
    public ResponseEntity<ApiResponse<List<RunSessionResponse>>> getRecentRunSessions(
            @PathVariable Long userId,
            @RequestParam(defaultValue = "5") Integer limit) {
        try {
            logger.info("开始处理获取用户 {} 最近 {} 条跑步记录的请求", userId, limit);
            List<RunSession> runSessions = runSessionService.getRecentRunSessions(userId, limit);
            List<RunSessionResponse> responses = runSessions.stream()
                    .map(runSessionService::getRunSessionResponse)
                    .collect(Collectors.toList());

            logger.info("成功返回 {} 条最近跑步记录", responses.size());
            return ResponseEntity.ok(ApiResponse.success(responses));

        } catch (Exception e) {
            logger.error("获取用户最近跑步记录失败: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(ApiResponse.error("获取最近跑步记录失败: " + e.getMessage()));
        }
    }

    /**
     * 获取跑步记录详情
     */
    @GetMapping("/{runId}")
    public ResponseEntity<ApiResponse<RunSessionResponse>> getRunSession(
            @PathVariable Long runId) {
        try {
            RunSession runSession = runSessionService.getRunSessionById(runId);
            RunSessionResponse response = runSessionService.getRunSessionResponse(runSession);
            return ResponseEntity.ok(ApiResponse.success(response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 删除跑步记录
     */
    @DeleteMapping("/{runId}")
    public ResponseEntity<ApiResponse<Void>> deleteRunSession(@PathVariable Long runId) {
        try {
            runSessionService.deleteRunSession(runId);
            return ResponseEntity.ok(ApiResponse.success("跑步记录删除成功", null));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 获取用户统计信息
     */
    @GetMapping("/users/{userId}/stats")
    public ResponseEntity<ApiResponse<RunSessionService.UserStats>> getUserStats(
            @PathVariable Long userId) {
        try {
            RunSessionService.UserStats stats = runSessionService.getUserStats(userId);
            return ResponseEntity.ok(ApiResponse.success(stats));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取用户统计失败"));
        }
    }
}
