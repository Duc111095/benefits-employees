package com.benefits.module.benefit.entity;

import com.benefits.module.employee.entity.Employee;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.UpdateTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "benefit_balances")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class BenefitBalance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "benefit_type_id", nullable = false)
    private BenefitType benefitType;

    @Column(nullable = false)
    private Integer year;

    @Column(name = "total_limit", precision = 15, scale = 2, nullable = false)
    private BigDecimal totalLimit = BigDecimal.ZERO;

    @Column(name = "used_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal usedAmount = BigDecimal.ZERO;

    @Column(name = "remaining_amount", precision = 15, scale = 2, nullable = false)
    private BigDecimal remainingAmount = BigDecimal.ZERO;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
