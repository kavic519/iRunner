package com.zjgsu.irunner.service;

import com.zjgsu.irunner.dto.RunSessionRequest;
import com.zjgsu.irunner.dto.RunSessionResponse;
import com.zjgsu.irunner.dto.CoordinateResponse;
import com.zjgsu.irunner.entity.Coordinate;
import com.zjgsu.irunner.entity.RunSession;
import com.zjgsu.irunner.entity.User;
import com.zjgsu.irunner.mapper.RunSessionMapper;
import com.zjgsu.irunner.mapper.CoordinateMapper; // 新增导入
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.ArrayList; // 新增导入
import java.util.stream.Collectors;

@Service
@Transactional
public class RunSessionService {

    private static final Logger logger = LoggerFactory.getLogger(RunSessionService.class);

    @Autowired
    private RunSessionMapper runSessionMapper;

    @Autowired
    private UserService userService;

    @Autowired // 新增：注入CoordinateMapper
    private CoordinateMapper coordinateMapper;

    /**
     * 根据ID获取跑步记录
     */
    public RunSession getRunSessionById(Long id) {
        try {
            logger.info("根据ID获取跑步记录: {}", id);

            RunSession runSession = runSessionMapper.selectByIdWithRoute(id);
            if (runSession == null) {
                throw new RuntimeException("跑步记录不存在");
            }

            logger.info("成功获取跑步记录 ID: {}", id);
            return runSession;

        } catch (RuntimeException e) {
            logger.error("获取跑步记录失败 ID {}: {}", id, e.getMessage());
            throw e;
        } catch (Exception e) {
            logger.error("获取跑步记录时发生错误 ID {}: {}", id, e.getMessage(), e);
            throw new RuntimeException("获取跑步记录失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户的所有跑步记录
     */
    public List<RunSession> getUserRunSessions(Long userId) {
        try {
            logger.info("获取用户 {} 的所有跑步记录", userId);
            List<RunSession> sessions = runSessionMapper.selectByUserIdWithRoute(userId);
            logger.info("成功获取到 {} 条跑步记录", sessions.size());
            return sessions;
        } catch (Exception e) {
            logger.error("获取用户 {} 的所有跑步记录时发生错误: {}", userId, e.getMessage(), e);
            throw new RuntimeException("获取跑步记录失败: " + e.getMessage());
        }
    }

    /**
     * 获取用户的最近跑步记录
     */
    public List<RunSession> getRecentRunSessions(Long userId, Integer limit) {
        try {
            logger.info("获取用户 {} 的最近 {} 条跑步记录", userId, limit);
            List<RunSession> sessions = runSessionMapper.selectRecentByUserId(userId, limit);
            logger.info("成功获取到 {} 条最近跑步记录", sessions.size());
            return sessions;
        } catch (Exception e) {
            logger.error("获取用户 {} 的最近跑步记录时发生错误: {}", userId, e.getMessage(), e);
            throw new RuntimeException("获取最近跑步记录失败: " + e.getMessage());
        }
    }

    /**
     * 创建跑步记录
     */
    public RunSession createRunSession(Long userId, RunSessionRequest request) {
        try {
            User user = userService.getUserById(userId);
            // 创建跑步记录
            RunSession runSession = new RunSession(
                    user,
                    request.getStartTime(),
                    request.getDistanceMeters(),
                    request.getDurationSeconds()
            );
            runSession.setEndTime(request.getEndTime());
            runSession.setCaloriesBurned(request.getCaloriesBurned());
            runSession.setWeatherCondition(request.getWeatherCondition());
            // 保存跑步记录
            runSessionMapper.insert(runSession);
            // 添加轨迹坐标点
            if (request.getRoute() != null && !request.getRoute().isEmpty()) {
                List<Coordinate> coordinates = new ArrayList<>(); // 修复：添加ArrayList导入
                for (int i = 0; i < request.getRoute().size(); i++) {
                    var coordRequest = request.getRoute().get(i);
                    Coordinate coordinate = new Coordinate(
                            coordRequest.getLatitude(),
                            coordRequest.getLongitude(),
                            coordRequest.getOrder() != null ? coordRequest.getOrder() : i,
                            runSession.getId()  // 设置runSessionId
                    );
                    coordinates.add(coordinate);
                }
                // 批量插入坐标点
                coordinateMapper.insertBatch(coordinates); // 修复：注入CoordinateMapper
            }
            // 更新用户统计信息
            userService.updateUserStats(
                    userId,
                    request.getDistanceMeters(),
                    request.getDurationSeconds()
            );
            logger.info("成功创建跑步记录 ID: {}", runSession.getId());
            return runSession;

        } catch (Exception e) {
            logger.error("创建跑步记录失败: {}", e.getMessage(), e);
            throw new RuntimeException("创建跑步记录失败: " + e.getMessage());
        }
    }

    /**
     * 删除跑步记录
     */
    public void deleteRunSession(Long id) {
        try {
            RunSession runSession = getRunSessionById(id);

            // 先删除关联的坐标点
            coordinateMapper.deleteByRunSessionId(id);

            // 再删除跑步记录
            runSessionMapper.deleteById(id);
            logger.info("成功删除跑步记录 ID: {}", id);
        } catch (Exception e) {
            logger.error("删除跑步记录失败 ID {}: {}", id, e.getMessage(), e);
            throw new RuntimeException("删除跑步记录失败: " + e.getMessage());
        }
    }

    /**
     * 获取跑步记录响应对象
     */
    public RunSessionResponse getRunSessionResponse(RunSession runSession) {
        try {
            RunSessionResponse response = new RunSessionResponse();
            response.setId(runSession.getId());
            response.setUserId(runSession.getUser().getId());
            response.setStartTime(runSession.getStartTime());
            response.setEndTime(runSession.getEndTime());
            response.setDistanceMeters(runSession.getDistanceMeters());
            response.setDurationSeconds(runSession.getDurationSeconds());
            response.setAvgPace(runSession.getAvgPace());
            response.setCaloriesBurned(runSession.getCaloriesBurned());
            response.setWeatherCondition(runSession.getWeatherCondition());
            response.setCreatedAt(runSession.getCreatedAt());

            // 转换轨迹坐标
            if (runSession.getRoute() != null && !runSession.getRoute().isEmpty()) {
                List<CoordinateResponse> route = runSession.getRoute().stream()
                        .map(coord -> new CoordinateResponse(
                                coord.getLatitude(),
                                coord.getLongitude(),
                                coord.getOrder()
                        ))
                        .collect(Collectors.toList());
                response.setRoute(route);
                logger.debug("转换了 {} 个坐标点", route.size());
            } else {
                response.setRoute(java.util.Collections.emptyList());
                logger.debug("跑步记录没有坐标点");
            }

            return response;

        } catch (Exception e) {
            logger.error("转换跑步记录响应对象失败: {}", e.getMessage(), e);
            throw new RuntimeException("转换跑步记录响应失败");
        }
    }

    /**
     * 获取用户统计信息
     */
    public UserStats getUserStats(Long userId) {
        try {
            Double totalDistance = runSessionMapper.selectTotalDistanceByUserId(userId);
            Integer totalDuration = runSessionMapper.selectTotalDurationByUserId(userId);
            Integer totalRuns = runSessionMapper.selectTotalRunsByUserId(userId);

            if (totalDistance == null) totalDistance = 0.0;
            if (totalDuration == null) totalDuration = 0;
            if (totalRuns == null) totalRuns = 0;

            logger.info("用户 {} 统计: {} 次跑步, {} 米, {} 秒", userId, totalRuns, totalDistance, totalDuration);
            return new UserStats(totalRuns, totalDistance, totalDuration);

        } catch (Exception e) {
            logger.error("获取用户统计失败 ID {}: {}", userId, e.getMessage(), e);
            throw new RuntimeException("获取用户统计失败");
        }
    }

    // 用户统计内部类
    public static class UserStats {
        private final Integer totalRuns;
        private final Double totalDistance;
        private final Integer totalDuration;

        public UserStats(Integer totalRuns, Double totalDistance, Integer totalDuration) {
            this.totalRuns = totalRuns;
            this.totalDistance = totalDistance;
            this.totalDuration = totalDuration;
        }

        public Integer getTotalRuns() { return totalRuns; }
        public Double getTotalDistance() { return totalDistance; }
        public Integer getTotalDuration() { return totalDuration; }
    }
}