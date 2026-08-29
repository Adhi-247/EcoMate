package com.ecomate.backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(properties = {
    "spring.datasource.url=jdbc:postgresql://aws-0-ap-southeast-1.pooler.supabase.com:6543/postgres?sslmode=require",
    "spring.datasource.username=postgres.eninnexoalqfipwilynv",
    "spring.datasource.password=EcoMate#123",
    "spring.datasource.hikari.maximum-pool-size=2",
    "app.jwt.secret=9a3f2c4d5e6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c"
})
class BackendApplicationTests {

    @Test
    void contextLoads() {
    }
}