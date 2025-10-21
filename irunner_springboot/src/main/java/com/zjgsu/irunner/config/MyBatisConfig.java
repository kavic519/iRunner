package com.zjgsu.irunner.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan("com.zjgsu.irunner.mapper")
public class MyBatisConfig {
    // MyBatis配置将通过application.yml自动配置
}