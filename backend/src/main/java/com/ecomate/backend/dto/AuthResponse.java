package com.ecomate.backend.dto;

public record AuthResponse(
        String token,
        String role,
        String name,
        String email
) {
}