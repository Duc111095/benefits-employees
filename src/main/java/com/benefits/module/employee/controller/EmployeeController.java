package com.benefits.module.employee.controller;

import com.benefits.common.Constants;
import com.benefits.module.auth.entity.User;
import com.benefits.module.auth.service.AuthService;
import com.benefits.module.department.service.DepartmentService;
import com.benefits.module.employee.entity.Employee;
import com.benefits.module.employee.service.EmployeeService;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/employee")
@RequiredArgsConstructor
public class EmployeeController {

    private final EmployeeService employeeService;
    private final DepartmentService departmentService;
    private final AuthService authService;

    @GetMapping
    public String listEmployees(Model model,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) String status) {
        List<Employee> employees = employeeService.searchEmployees(keyword, departmentId, position, status);
        model.addAttribute("employees", employees);
        model.addAttribute("departments", departmentService.getAllDepartments());
        model.addAttribute("keyword", keyword);
        model.addAttribute("selectedDept", departmentId);
        model.addAttribute("selectedPos", position);
        model.addAttribute("selectedStatus", status);
        return "employee/employee-list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("employee", new Employee());
        model.addAttribute("departments", departmentService.getActiveDepartments());
        model.addAttribute("isEdit", false);
        return "employee/employee-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        return employeeService.getEmployeeById(id)
                .map(employee -> {
                    model.addAttribute("employee", employee);
                    model.addAttribute("departments", departmentService.getActiveDepartments());
                    model.addAttribute("isEdit", true);
                    return "employee/employee-form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "Employee not found");
                    return "redirect:/employee";
                });
    }

    @PostMapping("/save")
    public String saveEmployee(@ModelAttribute Employee employee,
            @RequestParam(required = false) Boolean createAccount,
            RedirectAttributes redirectAttributes) {
        try {
            if (employee.getId() == null) {
                Employee saved = employeeService.createEmployee(employee);
                if (Boolean.TRUE.equals(createAccount)) {
                    String tempPassword = "123456";
                    User user = new User();
                    user.setUsername("employee" + saved.getId());
                    user.setPassword(tempPassword);
                    user.setEmail(saved.getEmail());
                    user.setRole(Constants.ROLE_EMPLOYEE);
                    user.setEmployee(saved);
                    user.setActive(true);
                    authService.createUser(user);
                    employeeService.updateEmployee(saved.getId(), saved);
                }
                redirectAttributes.addFlashAttribute("success", "Employee created successfully");
            } else {
                employeeService.updateEmployee(employee.getId(), employee);
                redirectAttributes.addFlashAttribute("success", "Employee updated successfully");
            }
            return "redirect:/employee";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/employee/new";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteEmployee(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            employeeService.deleteEmployee(id);
            redirectAttributes.addFlashAttribute("success", "Employee deleted successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Cannot delete employee: " + e.getMessage());
        }
        return "redirect:/employee";
    }

    @GetMapping("/{id}")
    public String viewEmployee(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        return employeeService.getEmployeeById(id)
                .map(employee -> {
                    model.addAttribute("employee", employee);
                    return "employee/employee-detail";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "Employee not found");
                    return "redirect:/employee";
                });
    }

    @GetMapping("/search")
    public String searchEmployeesRedirect(@RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long departmentId,
            @RequestParam(required = false) String position,
            @RequestParam(required = false) String status) {
        // Redirect to main list with query params for consistent handling
        StringBuilder url = new StringBuilder("redirect:/employee?");
        if (keyword != null)
            url.append("keyword=").append(keyword).append("&");
        if (departmentId != null)
            url.append("departmentId=").append(departmentId).append("&");
        if (status != null)
            url.append("status=").append(status);
        return url.toString();
    }
}
