package com.zjgsu.irunner.mapper;

import com.zjgsu.irunner.entity.RunSession;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface RunSessionMapper {

    int insert(RunSession runSession);

    RunSession selectById(Long id);

    List<RunSession> selectByUserId(@Param("userId") Long userId);

    List<RunSession> selectRecentByUserId(@Param("userId") Long userId,
                                          @Param("limit") Integer limit);

    int deleteById(Long id);

    // 统计方法
    Double selectTotalDistanceByUserId(Long userId);

    Integer selectTotalDurationByUserId(Long userId);

    Integer selectTotalRunsByUserId(Long userId);

    // 带路由坐标的查询
    RunSession selectByIdWithRoute(Long id);

    List<RunSession> selectByUserIdWithRoute(Long userId);
}