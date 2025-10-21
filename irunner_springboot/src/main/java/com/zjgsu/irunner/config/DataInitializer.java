package com.zjgsu.irunner.config;

import com.zjgsu.irunner.service.AchievementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private AchievementService achievementService;

    @Override
    public void run(String... args) throws Exception {
        // 初始化成就数据
        achievementService.initializeAchievements();
        System.out.println("成就数据初始化完成");
    }
}
