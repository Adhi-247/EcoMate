package com.ecomate.backend.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/api/resident/test")
    public String residentTest() {
        return "Resident access granted";
    }

    @GetMapping("/api/collector/test")
    public String collectorTest() {
        return "Collector access granted";
    }

    @GetMapping("/api/recycling/test")
    public String recyclingTest() {
        return "Recycling Officer access granted";
    }

    @GetMapping("/api/council/test")
    public String councilTest() {
        return "Council Admin access granted";
    }
}