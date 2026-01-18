package com.benefits.module.employee.repository;

import com.benefits.module.employee.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    Optional<Employee> findByEmployeeCode(String employeeCode);

    Optional<Employee> findByEmail(String email);

    List<Employee> findByDepartmentId(Long departmentId);

    List<Employee> findByStatus(String status);

    @Query("SELECT e FROM Employee e WHERE " +
            "(:keyword IS NULL OR LOWER(e.fullName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(e.employeeCode) LIKE LOWER(CONCAT('%', :keyword, '%')) OR LOWER(e.email) LIKE LOWER(CONCAT('%', :keyword, '%'))) AND "
            +
            "(:departmentId IS NULL OR e.department.id = :departmentId) AND " +
            "(:position IS NULL OR e.position = :position) AND " +
            "(:status IS NULL OR e.status = :status)")
    List<Employee> searchEmployees(@Param("keyword") String keyword,
            @Param("departmentId") Long departmentId,
            @Param("position") String position,
            @Param("status") String status);

    Boolean existsByEmployeeCode(String employeeCode);

    Boolean existsByEmail(String email);
}
