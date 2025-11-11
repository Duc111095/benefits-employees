package com.soict.benefit_employees.service;

import com.soict.benefit_employees.dto.benefit.CreateBenefitPackageRequest;
import com.soict.benefit_employees.entity.BenefitPackage;
import com.soict.benefit_employees.entity.BenefitType;
import com.soict.benefit_employees.repository.BenefitPackageRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ActiveProfiles("test")
class BenefitPackageServiceTest {

    @Autowired
    private BenefitPackageService benefitPackageService;

    @MockBean
    private BenefitPackageRepository benefitPackageRepository;

    private CreateBenefitPackageRequest createRequest;
    private BenefitPackage testBenefitPackage;

    @BeforeEach
    void setUp() {
        // Create test benefit package
        testBenefitPackage = BenefitPackage.builder()
                .id("1")
                .name("Health Insurance")
                .type(BenefitType.HEALTH_INSURANCE)
                .description("Basic health insurance coverage")
                .maxAmount(BigDecimal.valueOf(1000))
                .isActive(true)
                .build();

        // Create benefit package request
        createRequest = new CreateBenefitPackageRequest();
        createRequest.setName("Health Insurance");
        createRequest.setType(BenefitType.HEALTH_INSURANCE);
        createRequest.setDescription("Basic health insurance coverage");
        createRequest.setMaxAmount(BigDecimal.valueOf(1000));
    }

    @Test
    void whenCreateValidBenefitPackage_thenSuccess() {
        // Mock repository
        when(benefitPackageRepository.save(any())).thenReturn(testBenefitPackage);

        // Create benefit package
        var result = benefitPackageService.createBenefitPackage(createRequest);

        // Verify result
        assertNotNull(result);
        assertEquals(testBenefitPackage.getId(), result.getId());
        assertEquals(testBenefitPackage.getName(), result.getName());
        assertEquals(testBenefitPackage.getType(), result.getType());
        assertEquals(testBenefitPackage.getDescription(), result.getDescription());
        assertEquals(testBenefitPackage.getMaxAmount(), result.getMaxAmount());
        assertTrue(result.isActive());
    }

    @Test
    void whenGetExistingBenefitPackage_thenSuccess() {
        // Mock repository
        when(benefitPackageRepository.findById(testBenefitPackage.getId()))
                .thenReturn(Optional.of(testBenefitPackage));

        // Get benefit package
        var result = benefitPackageService.getBenefitPackage(testBenefitPackage.getId());

        // Verify result
        assertNotNull(result);
        assertEquals(testBenefitPackage.getId(), result.getId());
        assertEquals(testBenefitPackage.getName(), result.getName());
    }

    @Test
    void whenGetNonExistingBenefitPackage_thenThrowException() {
        // Mock repository
        when(benefitPackageRepository.findById(any())).thenReturn(Optional.empty());

        // Verify that exception is thrown
        assertThrows(RuntimeException.class, 
                    () -> benefitPackageService.getBenefitPackage("non-existing-id"));
    }

    @Test
    void whenToggleBenefitPackageStatus_thenSuccess() {
        // Mock repository
        when(benefitPackageRepository.findById(testBenefitPackage.getId()))
                .thenReturn(Optional.of(testBenefitPackage));
        when(benefitPackageRepository.save(any())).thenReturn(testBenefitPackage);

        // Toggle status
        var result = benefitPackageService.toggleBenefitPackageStatus(testBenefitPackage.getId());

        // Verify result
        assertNotNull(result);
        assertFalse(result.isActive());
    }

    @Test
    void whenUpdateBenefitPackage_thenSuccess() {
        // Mock repository
        when(benefitPackageRepository.findById(testBenefitPackage.getId()))
                .thenReturn(Optional.of(testBenefitPackage));
        when(benefitPackageRepository.save(any())).thenReturn(testBenefitPackage);

        // Update request
        createRequest.setName("Updated Health Insurance");
        createRequest.setMaxAmount(BigDecimal.valueOf(2000));

        // Update benefit package
        var result = benefitPackageService.updateBenefitPackage(testBenefitPackage.getId(), createRequest);

        // Verify result
        assertNotNull(result);
        assertEquals("Updated Health Insurance", result.getName());
        assertEquals(BigDecimal.valueOf(2000), result.getMaxAmount());
    }
}