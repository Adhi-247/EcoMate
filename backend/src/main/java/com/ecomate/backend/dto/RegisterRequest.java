package com.ecomate.backend.dto;

import com.ecomate.backend.entity.Role;

public record RegisterRequest(
        String name,
        String email,
        String password,
        Role role
) {
}