package com.benefits.module.employee.controller;

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

    @GetMapping
    public String listEmployees(Model model) {
        List<Employee> employees = employeeService.getAllEmployees();
        model.addAttribute("employees", employees);
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
    public String saveEmployee(@ModelAttribute Employee employee, RedirectAttributes redirectAttributes) {
        try {
            if (employee.getId() == null) {
                employeeService.createEmployee(employee);
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
    public String searchEmployees(@RequestParam String keyword, Model model) {
        List<Employee> employees = employeeService.searchEmployees(keyword);
        model.addAttribute("employees", employees);
        model.addAttribute("keyword", keyword);
        return "employee/employee-list";
    }
}
