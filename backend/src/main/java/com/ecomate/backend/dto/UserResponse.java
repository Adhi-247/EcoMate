package com.ecomate.backend.dto;

import com.ecomate.backend.entity.Role;

public record UserResponse(
        Long id,
        String name,
        String email,
        Role role
) {
}