package com.ecomate.backend;

import com.ecomate.backend.entity.Role;
import com.ecomate.backend.entity.User;
import com.ecomate.backend.repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class BackendApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendApplication.class, args);
	}

	@Bean
	public CommandLineRunner seedDatabase(UserRepository userRepository, PasswordEncoder passwordEncoder) {
		return args -> {
			if (!userRepository.existsByEmail("admin@ecomate.com")) {
				User admin = new User(
					"Municipal Admin",
					"admin@ecomate.com",
					passwordEncoder.encode("admin123"),
					Role.COUNCIL_ADMIN
				);
				userRepository.save(admin);
			}
		};
	}
}
