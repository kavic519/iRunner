package com.zjgsu.irunner.service;

import com.zjgsu.irunner.dto.RegisterRequest;
import com.zjgsu.irunner.dto.UserResponse;
import com.zjgsu.irunner.entity.User;
import com.zjgsu.irunner.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserMapper userMapper;

    /**
     * 用户注册
     */
    public User register(RegisterRequest request) {
        // 检查用户名是否已存在
        if (userMapper.existsByUsername(request.getUsername())) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (userMapper.existsByEmail(request.getEmail())) {
            throw new RuntimeException("邮箱已被注册");
        }

        // 创建新用户
        User user = new User(
                request.getUsername(),
                request.getPassword(),
                request.getEmail()
        );

        if (request.getNickName() != null) {
            user.setNickName(request.getNickName());
        }

        userMapper.insert(user);
        return user;
    }

    /**
     * 用户登录
     */
    public User login(String username, String password) {
        User user = userMapper.selectByUsername(username);

        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        if (!user.getPassword().equals(password)) {
            throw new RuntimeException("密码错误");
        }

        return user;
    }

    /**
     * 根据ID获取用户
     */
    public User getUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        return user;
    }

    /**
     * 更新用户统计信息
     */
    public void updateUserStats(Long userId, Double distance, Integer duration) {
        // 使用优化的SQL更新，避免先查询再更新
        int updated = userMapper.updateUserStats(userId, distance, duration);
        if (updated == 0) {
            throw new RuntimeException("用户不存在");
        }
    }

    /**
     * 获取用户响应对象
     */
    public UserResponse getUserResponse(User user) {
        UserResponse response = new UserResponse();
        response.setId(user.getId());
        response.setUsername(user.getUsername());
        response.setEmail(user.getEmail());
        response.setNickName(user.getNickName());
        response.setAvatarUrl(user.getAvatarUrl());
        response.setTotalRuns(user.getTotalRuns());
        response.setTotalDistance(user.getTotalDistance());
        response.setTotalDuration(user.getTotalDuration());
        response.setCreatedAt(user.getCreatedAt());

        return response;
    }

    /**
     * 获取排行榜用户
     */
    public List<UserResponse> getLeaderboard(String type, Integer limit) {
        List<User> users;

        if ("distance".equals(type)) {
            users = userMapper.selectTopByDistance(0.0);
        } else if ("runs".equals(type)) {
            users = userMapper.selectTopByRuns(0);
        } else {
            users = userMapper.selectAll();
        }

        // 限制结果数量
        if (limit != null && limit > 0) {
            users = users.stream().limit(limit).collect(Collectors.toList());
        }

        return users.stream()
                .map(this::getUserResponse)
                .collect(Collectors.toList());
    }
}