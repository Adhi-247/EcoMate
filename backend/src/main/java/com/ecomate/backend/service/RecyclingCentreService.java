package com.ecomate.backend.service;

import com.ecomate.backend.dto.RecyclingCentreRequest;
import com.ecomate.backend.dto.RecyclingCentreResponse;
import com.ecomate.backend.entity.RecyclingCentre;
import com.ecomate.backend.entity.User;
import com.ecomate.backend.repository.RecyclingCentreRepository;
import com.ecomate.backend.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RecyclingCentreService {

    private final RecyclingCentreRepository recyclingCentreRepository;
    private final UserRepository userRepository;

    public RecyclingCentreService(RecyclingCentreRepository recyclingCentreRepository,
                                  UserRepository userRepository) {
        this.recyclingCentreRepository = recyclingCentreRepository;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public RecyclingCentreResponse getMyCentre(String officerEmail) {
        return recyclingCentreRepository.findByOfficerEmailIgnoreCase(officerEmail)
                .map(RecyclingCentreResponse::fromEntity)
                .orElse(null);
    }

    @Transactional
    public RecyclingCentreResponse createOrUpdateMyCentre(String officerEmail, RecyclingCentreRequest request) {
        Optional<RecyclingCentre> existingOpt = recyclingCentreRepository.findByOfficerEmailIgnoreCase(officerEmail);
        RecyclingCentre centre;

        if (existingOpt.isPresent()) {
            centre = existingOpt.get();
        } else {
            centre = new RecyclingCentre();
            centre.setOfficerEmail(officerEmail);
            userRepository.findByEmail(officerEmail).ifPresent(centre::setOfficer);
        }

        centre.setName(request.getName());
        centre.setAddress(request.getAddress());
        centre.setCity(request.getCity());
        centre.setContactNumber(request.getContactNumber());
        centre.setEmail(request.getEmail());

        if (request.getOperatingHours() != null) {
            centre.setOperatingHours(request.getOperatingHours());
        }
        if (request.getIsOpen() != null) {
            centre.setIsOpen(request.getIsOpen());
        }
        if (request.getAcceptedMaterials() != null) {
            centre.setAcceptedMaterials(request.getAcceptedMaterials());
        }
        if (request.getUnsupportedMaterials() != null) {
            centre.setUnsupportedMaterials(request.getUnsupportedMaterials());
        }
        if (request.getNotes() != null) {
            centre.setNotes(request.getNotes());
        }

        RecyclingCentre saved = recyclingCentreRepository.save(centre);
        return RecyclingCentreResponse.fromEntity(saved);
    }

    @Transactional
    public RecyclingCentreResponse toggleStatus(String officerEmail, boolean isOpen) {
        RecyclingCentre centre = recyclingCentreRepository.findByOfficerEmailIgnoreCase(officerEmail)
                .orElseThrow(() -> new RuntimeException("No recycling centre found for officer: " + officerEmail));

        centre.setIsOpen(isOpen);
        RecyclingCentre saved = recyclingCentreRepository.save(centre);
        return RecyclingCentreResponse.fromEntity(saved);
    }

    @Transactional(readOnly = true)
    public List<RecyclingCentreResponse> getAllCentres(String query, String materialFilter) {
        List<RecyclingCentre> list = recyclingCentreRepository.findAll();

        return list.stream()
                .filter(c -> {
                    if (query == null || query.isBlank()) return true;
                    String q = query.trim().toLowerCase();
                    return c.getName().toLowerCase().contains(q)
                            || c.getCity().toLowerCase().contains(q)
                            || c.getAddress().toLowerCase().contains(q);
                })
                .filter(c -> {
                    if (materialFilter == null || materialFilter.isBlank() || materialFilter.equalsIgnoreCase("All")) return true;
                    String m = materialFilter.trim().toLowerCase();
                    return c.getAcceptedMaterials().stream()
                            .anyMatch(mat -> mat.toLowerCase().contains(m));
                })
                .map(RecyclingCentreResponse::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public RecyclingCentreResponse getCentreById(Long id) {
        return recyclingCentreRepository.findById(id)
                .map(RecyclingCentreResponse::fromEntity)
                .orElseThrow(() -> new RuntimeException("Recycling centre not found with id: " + id));
    }
}