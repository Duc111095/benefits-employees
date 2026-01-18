package com.benefits.module.department.controller;

import com.benefits.module.department.entity.Department;
import com.benefits.module.department.service.DepartmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/department")
@RequiredArgsConstructor
public class DepartmentController {

    private final DepartmentService departmentService;

    @GetMapping
    public String listDepartments(Model model) {
        List<Department> departments = departmentService.getAllDepartments();
        model.addAttribute("departments", departments);
        return "department/department-list";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("department", new Department());
        model.addAttribute("isEdit", false);
        return "department/department-form";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        return departmentService.getDepartmentById(id)
                .map(department -> {
                    model.addAttribute("department", department);
                    model.addAttribute("isEdit", true);
                    return "department/department-form";
                })
                .orElseGet(() -> {
                    redirectAttributes.addFlashAttribute("error", "Department not found");
                    return "redirect:/department";
                });
    }

    @PostMapping("/save")
    public String saveDepartment(@ModelAttribute Department department, RedirectAttributes redirectAttributes) {
        try {
            if (department.getId() == null) {
                departmentService.createDepartment(department);
                redirectAttributes.addFlashAttribute("success", "Department created successfully");
            } else {
                departmentService.updateDepartment(department.getId(), department);
                redirectAttributes.addFlashAttribute("success", "Department updated successfully");
            }
            return "redirect:/department";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/department/new";
        }
    }

    @GetMapping("/delete/{id}")
    public String deleteDepartment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            departmentService.deleteDepartment(id);
            redirectAttributes.addFlashAttribute("success", "Department deleted successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Cannot delete department: " + e.getMessage());
        }
        return "redirect:/department";
    }

    @GetMapping("/search")
    public String searchDepartments(@RequestParam String keyword, Model model) {
        List<Department> departments = departmentService.searchDepartments(keyword);
        model.addAttribute("departments", departments);
        model.addAttribute("keyword", keyword);
        return "department/department-list";
    }
}
