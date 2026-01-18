package com.benefits.module.claim.service;

import com.benefits.module.claim.entity.BenefitClaim;
import com.benefits.module.claim.repository.ClaimRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ClaimService {

    private final ClaimRepository claimRepository;

    public List<BenefitClaim> getAllClaims() {
        return claimRepository.findAll();
    }

    public List<BenefitClaim> getPendingClaims() {
        return claimRepository.findByStatus("PENDING");
    }

    @Transactional
    public BenefitClaim submitClaim(BenefitClaim claim) {
        claim.setStatus("PENDING");
        claim.setSubmissionDate(LocalDateTime.now());
        return claimRepository.save(claim);
    }

    @Transactional
    public void approveClaim(Long id, Long approverId) {
        BenefitClaim claim = claimRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Claim not found"));
        claim.setStatus("APPROVED");
        claim.setApprovalDate(LocalDateTime.now());
        // In a real app, you'd set the approver User entity here
        claimRepository.save(claim);
    }
}
