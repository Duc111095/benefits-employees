package com.benefits.module.claim.repository;

import com.benefits.module.claim.entity.ClaimHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClaimHistoryRepository extends JpaRepository<ClaimHistory, Long> {
    List<ClaimHistory> findByClaimIdOrderByChangeDateDesc(Long claimId);
}
