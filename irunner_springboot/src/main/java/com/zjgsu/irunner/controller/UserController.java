package com.zjgsu.irunner.controller;

import com.zjgsu.irunner.dto.ApiResponse;
import com.zjgsu.irunner.dto.LoginRequest;
import com.zjgsu.irunner.dto.RegisterRequest;
import com.zjgsu.irunner.dto.UserResponse;
import com.zjgsu.irunner.entity.User;
import com.zjgsu.irunner.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/users")
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 用户注册
     */
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserResponse>> register(
            @Valid @RequestBody RegisterRequest request) {
        try {
            User user = userService.register(request);
            UserResponse response = userService.getUserResponse(user);
            return ResponseEntity.ok(ApiResponse.success("注册成功", response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 用户登录
     */
    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserResponse>> login(
            @Valid @RequestBody LoginRequest request) {
        try {
            User user = userService.login(request.getUsername(), request.getPassword());
            UserResponse response = userService.getUserResponse(user);
            return ResponseEntity.ok(ApiResponse.success("登录成功", response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 获取用户信息
     */
    @GetMapping("/{userId}")
    public ResponseEntity<ApiResponse<UserResponse>> getUser(@PathVariable Long userId) {
        try {
            User user = userService.getUserById(userId);
            UserResponse response = userService.getUserResponse(user);
            return ResponseEntity.ok(ApiResponse.success(response));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.error(e.getMessage()));
        }
    }

    /**
     * 获取排行榜
     */
    @GetMapping("/leaderboard")
    public ResponseEntity<ApiResponse<List<UserResponse>>> getLeaderboard(
            @RequestParam(defaultValue = "distance") String type,
            @RequestParam(required = false) Integer limit) {
        try {
            List<UserResponse> leaderboard = userService.getLeaderboard(type, limit);
            return ResponseEntity.ok(ApiResponse.success(leaderboard));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ApiResponse.error("获取排行榜失败"));
        }
    }
}
