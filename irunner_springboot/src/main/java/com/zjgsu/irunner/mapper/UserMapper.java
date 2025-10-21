package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Optional;

@Mapper
public interface UserMapper {

    // 插入用户
    int insert(User user);

    // 根据ID查询
    User selectById(Long id);

    // 根据用户名查询
    User selectByUsername(String username);

    // 根据邮箱查询
    User selectByEmail(String email);

    // 检查用户名是否存在
    boolean existsByUsername(String username);

    // 检查邮箱是否存在
    boolean existsByEmail(String email);

    // 更新用户
    int update(User user);

    // 根据距离排序查询用户（排行榜）
    List<User> selectTopByDistance(@Param("minDistance") Double minDistance);

    // 根据跑步次数排序查询用户（排行榜）
    List<User> selectTopByRuns(@Param("minRuns") Integer minRuns);

    // 查询所有用户
    List<User> selectAll();

    // 更新用户统计信息
    int updateUserStats(@Param("id") Long id,
                        @Param("distance") Double distance,
                        @Param("duration") Integer duration);
}