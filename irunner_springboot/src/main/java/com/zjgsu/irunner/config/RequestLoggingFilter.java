package com.zjgsu.irunner.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class RequestLoggingFilter extends OncePerRequestFilter {

    private static final Logger logger = LoggerFactory.getLogger(RequestLoggingFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        long startTime = System.currentTimeMillis();

        try {
            logger.info("=== 收到请求 ===");
            logger.info("方法: {} {}", request.getMethod(), request.getRequestURI());
            logger.info("查询参数: {}", request.getQueryString());
            logger.info("Content-Type: {}", request.getContentType());

            filterChain.doFilter(request, response);

        } finally {
            long duration = System.currentTimeMillis() - startTime;
            logger.info("请求处理完成，耗时: {}ms, 状态: {}", duration, response.getStatus());
            logger.info("=== 请求结束 ===");
        }
    }
}