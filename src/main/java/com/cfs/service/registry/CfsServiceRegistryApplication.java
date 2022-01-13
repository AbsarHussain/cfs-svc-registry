package com.cfs.service.registry;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

@SpringBootApplication
@EnableEurekaServer
public class CfsServiceRegistryApplication {

	public static void main(String[] args) {
		SpringApplication.run(CfsServiceRegistryApplication.class, args);
	}

}