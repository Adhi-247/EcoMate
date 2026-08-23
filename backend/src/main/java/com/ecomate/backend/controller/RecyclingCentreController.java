package com.ecomate.backend.controller;

import com.ecomate.backend.dto.RecyclingCentreRequest;
import com.ecomate.backend.dto.RecyclingCentreResponse;
import com.ecomate.backend.service.RecyclingCentreService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/recycling")
public class RecyclingCentreController {

    private final RecyclingCentreService recyclingCentreService;

    public RecyclingCentreController(RecyclingCentreService recyclingCentreService) {
        this.recyclingCentreService = recyclingCentreService;
    }

    // 1. Get logged-in officer's centre
    @GetMapping("/my-centre")
    public ResponseEntity<RecyclingCentreResponse> getMyCentre(Authentication authentication) {
        String officerEmail = authentication.getName();
        RecyclingCentreResponse centre = recyclingCentreService.getMyCentre(officerEmail);
        if (centre == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(centre);
    }

    // 2. Create or Update logged-in officer's centre
    @PutMapping("/my-centre")
    public ResponseEntity<RecyclingCentreResponse> createOrUpdateMyCentre(
            Authentication authentication,
            @Valid @RequestBody RecyclingCentreRequest request) {
        String officerEmail = authentication.getName();
        RecyclingCentreResponse updated = recyclingCentreService.createOrUpdateMyCentre(officerEmail, request);
        return ResponseEntity.ok(updated);
    }

    // 3. Toggle logged-in officer's centre open/closed status
    @PatchMapping("/my-centre/status")
    public ResponseEntity<RecyclingCentreResponse> toggleStatus(
            Authentication authentication,
            @RequestBody Map<String, Boolean> statusPayload) {
        String officerEmail = authentication.getName();
        boolean isOpen = statusPayload.getOrDefault("isOpen", true);
        RecyclingCentreResponse updated = recyclingCentreService.toggleStatus(officerEmail, isOpen);
        return ResponseEntity.ok(updated);
    }

    // 4. Public endpoint for residents & community users to search nearby centres
    @GetMapping("/public/centres")
    public ResponseEntity<List<RecyclingCentreResponse>> getPublicCentres(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String material) {
        List<RecyclingCentreResponse> centres = recyclingCentreService.getAllCentres(query, material);
        return ResponseEntity.ok(centres);
    }

    // 5. Public endpoint to view a specific centre's details
    @GetMapping("/public/centres/{id}")
    public ResponseEntity<RecyclingCentreResponse> getCentreById(@PathVariable Long id) {
        RecyclingCentreResponse centre = recyclingCentreService.getCentreById(id);
        return ResponseEntity.ok(centre);
    }
}