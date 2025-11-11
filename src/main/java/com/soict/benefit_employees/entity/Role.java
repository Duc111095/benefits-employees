package com.soict.benefit_employees.entity;

public enum Role {
    ROLE_ADMIN("admin"),
    ROLE_HR("hr"),
    ROLE_EMPLOYEE("employee");

    private final String roleName;
    private Role(String roleName) {
        this.roleName = roleName;
    }

    public String getRoleName() {
        return roleName;
    }
}