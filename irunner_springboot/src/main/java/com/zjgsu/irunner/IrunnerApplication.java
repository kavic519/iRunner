package com.zjgsu.irunner;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

// 显式指定扫描所有包
@SpringBootApplication(scanBasePackages = "com.zjgsu.irunner")
@ComponentScan(basePackages = "com.zjgsu.irunner")
public class IrunnerApplication {

	public static void main(String[] args) {
		SpringApplication.run(IrunnerApplication.class, args);
	}

	// 在主类中直接定义端点
	@GetMapping("/")
	public String root() {
		return "iRunner API Root - " + System.currentTimeMillis();
	}

	@GetMapping("/api")
	public String apiRoot() {
		return "iRunner API Base - " + System.currentTimeMillis();
	}

	@GetMapping("/api/test")
	public String test() {
		return "Direct Test Endpoint - " + System.currentTimeMillis();
	}

	@GetMapping("/api/debug")
	public String debug() {
		return "Debug Endpoint - Application is running";
	}
}