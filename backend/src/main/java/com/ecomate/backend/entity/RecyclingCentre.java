package com.ecomate.backend.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "recycling_centres")
public class RecyclingCentre {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "officer_id")
    private User officer;

    @Column(name = "officer_email", nullable = false)
    private String officerEmail;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private String address;

    @Column(nullable = false)
    private String city;

    @Column(name = "latitude")
    private Double latitude = 6.9271;

    @Column(name = "longitude")
    private Double longitude = 79.8612;

    @Column(name = "distance_km")
    private Double distanceKm = 1.2;

    @Column(name = "contact_number", nullable = false)
    private String contactNumber;

    @Column(nullable = false)
    private String email;

    @Column(name = "operating_hours", nullable = false)
    private String operatingHours = "Mon - Sat: 8:00 AM - 5:30 PM";

    @Column(name = "is_open", nullable = false)
    private Boolean isOpen = true;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "recycling_centre_accepted_materials", joinColumns = @JoinColumn(name = "centre_id"))
    @Column(name = "material")
    private List<String> acceptedMaterials = new ArrayList<>();

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "recycling_centre_unsupported_materials", joinColumns = @JoinColumn(name = "centre_id"))
    @Column(name = "material")
    private List<String> unsupportedMaterials = new ArrayList<>();

    @Column(length = 1000)
    private String notes = "";

    public RecyclingCentre() {
    }

    public RecyclingCentre(User officer, String officerEmail, String name, String address, String city,
                           String contactNumber, String email, String operatingHours, Boolean isOpen,
                           List<String> acceptedMaterials, List<String> unsupportedMaterials, String notes) {
        this.officer = officer;
        this.officerEmail = officerEmail;
        this.name = name;
        this.address = address;
        this.city = city;
        this.contactNumber = contactNumber;
        this.email = email;
        this.operatingHours = operatingHours;
        this.isOpen = isOpen;
        this.acceptedMaterials = acceptedMaterials != null ? acceptedMaterials : new ArrayList<>();
        this.unsupportedMaterials = unsupportedMaterials != null ? unsupportedMaterials : new ArrayList<>();
        this.notes = notes;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getOfficer() {
        return officer;
    }

    public void setOfficer(User officer) {
        this.officer = officer;
    }

    public String getOfficerEmail() {
        return officerEmail;
    }

    public void setOfficerEmail(String officerEmail) {
        this.officerEmail = officerEmail;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(Double distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOperatingHours() {
        return operatingHours;
    }

    public void setOperatingHours(String operatingHours) {
        this.operatingHours = operatingHours;
    }

    public Boolean getIsOpen() {
        return isOpen;
    }

    public void setIsOpen(Boolean isOpen) {
        this.isOpen = isOpen;
    }

    public List<String> getAcceptedMaterials() {
        return acceptedMaterials;
    }

    public void setAcceptedMaterials(List<String> acceptedMaterials) {
        this.acceptedMaterials = acceptedMaterials;
    }

    public List<String> getUnsupportedMaterials() {
        return unsupportedMaterials;
    }

    public void setUnsupportedMaterials(List<String> unsupportedMaterials) {
        this.unsupportedMaterials = unsupportedMaterials;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}