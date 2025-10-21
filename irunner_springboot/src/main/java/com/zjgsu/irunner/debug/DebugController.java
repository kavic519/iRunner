package com.zjgsu.irunner.debug;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;

@RestController
@RequestMapping("/debug")
public class DebugController {

    @Autowired
    private ApplicationContext applicationContext;

    @GetMapping("/beans")
    public String listBeans() {
        String[] beanNames = applicationContext.getBeanDefinitionNames();
        Arrays.sort(beanNames);
        StringBuilder sb = new StringBuilder();
        sb.append("Total Beans: ").append(beanNames.length).append("\n\n");

        for (String beanName : beanNames) {
            if (beanName.contains("controller") || beanName.contains("Controller")) {
                sb.append("CONTROLLER: ").append(beanName).append("\n");
            }
        }
        return sb.toString();
    }

    @GetMapping("/health")
    public String health() {
        return "Debug Health: OK - " + System.currentTimeMillis();
    }
}