package com.zjgsu.irunner.controller;

import com.zjgsu.irunner.dto.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

@RestController
public class HealthController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/health")
    public ResponseEntity<ApiResponse<HealthStatus>> healthCheck() {
        HealthStatus status = new HealthStatus();

        // 检查数据库连接
        try (Connection conn = dataSource.getConnection()) {
            status.database = "连接正常";
            status.databaseDetails = conn.getMetaData().getDatabaseProductName() + " " +
                    conn.getMetaData().getDatabaseProductVersion();
        } catch (SQLException e) {
            status.database = "连接失败: " + e.getMessage();
        }

        status.application = "运行正常";
        status.timestamp = System.currentTimeMillis();

        return ResponseEntity.ok(ApiResponse.success(status));
    }

    public static class HealthStatus {
        public String application;
        public String database;
        public String databaseDetails;
        public long timestamp;
    }
}