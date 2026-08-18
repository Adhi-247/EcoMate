package com.ecomate.backend.dto;

public record LoginRequest(
        String email,
        String password
) {
}