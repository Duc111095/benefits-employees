package com.benefits.module.department.service;

import com.benefits.module.department.entity.Department;
import com.benefits.module.department.repository.DepartmentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DepartmentService {

    private final DepartmentRepository departmentRepository;

    public List<Department> getAllDepartments() {
        return departmentRepository.findAllOrderByName();
    }

    public List<Department> getActiveDepartments() {
        return departmentRepository.findByActiveTrue();
    }

    public Optional<Department> getDepartmentById(Long id) {
        return departmentRepository.findById(id);
    }

    public Optional<Department> getDepartmentByCode(String code) {
        return departmentRepository.findByCode(code);
    }

    public List<Department> searchDepartments(String keyword) {
        return departmentRepository.findByNameContainingIgnoreCase(keyword);
    }

    @Transactional
    public Department createDepartment(Department department) {
        if (departmentRepository.existsByCode(department.getCode())) {
            throw new IllegalArgumentException("Department code already exists: " + department.getCode());
        }
        return departmentRepository.save(department);
    }

    @Transactional
    public Department updateDepartment(Long id, Department department) {
        Department existing = departmentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Department not found: " + id));

        // Check if code is being changed and if new code already exists
        if (!existing.getCode().equals(department.getCode()) &&
                departmentRepository.existsByCode(department.getCode())) {
            throw new IllegalArgumentException("Department code already exists: " + department.getCode());
        }

        existing.setCode(department.getCode());
        existing.setName(department.getName());
        existing.setDescription(department.getDescription());
        existing.setManagerEmployeeId(department.getManagerEmployeeId());
        existing.setActive(department.getActive());

        return departmentRepository.save(existing);
    }

    @Transactional
    public void deleteDepartment(Long id) {
        if (!departmentRepository.existsById(id)) {
            throw new IllegalArgumentException("Department not found: " + id);
        }
        departmentRepository.deleteById(id);
    }

    @Transactional
    public void deactivateDepartment(Long id) {
        Department department = departmentRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Department not found: " + id));
        department.setActive(false);
        departmentRepository.save(department);
    }
}
