package com.benefits.module.search.service;

import com.benefits.module.employee.entity.Employee;
import com.benefits.module.employee.repository.EmployeeRepository;
import com.benefits.module.benefit.entity.BenefitPlan;
import com.benefits.module.benefit.repository.BenefitPlanRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class SearchService {

    private final EmployeeRepository employeeRepository;
    private final BenefitPlanRepository benefitPlanRepository;

    public Map<String, Object> globalSearch(String keyword) {
        Map<String, Object> results = new HashMap<>();

        List<Employee> employees = employeeRepository.searchByKeyword(keyword);
        results.put("employees", employees);

        // Simple search for benefit plans by name
        List<BenefitPlan> plans = benefitPlanRepository.findAll().stream()
                .filter(p -> p.getPlanName().toLowerCase().contains(keyword.toLowerCase()))
                .toList();
        results.put("plans", plans);

        return results;
    }
}
