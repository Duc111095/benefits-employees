package com.benefits.common;

public class Constants {

    // User Roles
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_HR_MANAGER = "HR_MANAGER";
    public static final String ROLE_MANAGER = "MANAGER";
    public static final String ROLE_EMPLOYEE = "EMPLOYEE";

    // Employee Status
    public static final String EMPLOYEE_STATUS_ACTIVE = "ACTIVE";
    public static final String EMPLOYEE_STATUS_INACTIVE = "INACTIVE";
    public static final String EMPLOYEE_STATUS_TERMINATED = "TERMINATED";

    // Enrollment Status
    public static final String ENROLLMENT_STATUS_ACTIVE = "ACTIVE";
    public static final String ENROLLMENT_STATUS_PENDING = "PENDING";
    public static final String ENROLLMENT_STATUS_REJECTED = "REJECTED";
    public static final String ENROLLMENT_STATUS_TERMINATED = "TERMINATED";
    public static final String ENROLLMENT_STATUS_EXPIRED = "EXPIRED";

    // Claim Status
    public static final String CLAIM_STATUS_PENDING = "PENDING";
    public static final String CLAIM_STATUS_APPROVED = "APPROVED";
    public static final String CLAIM_STATUS_REJECTED = "REJECTED";
    public static final String CLAIM_STATUS_CANCELLED = "CANCELLED";

    // Enrollment History Change Types
    public static final String CHANGE_TYPE_CREATED = "CREATED";
    public static final String CHANGE_TYPE_UPDATED = "UPDATED";
    public static final String CHANGE_TYPE_TERMINATED = "TERMINATED";
    public static final String CHANGE_TYPE_STATUS_CHANGED = "STATUS_CHANGED";
    public static final String CHANGE_TYPE_CLAIM_SUBMITTED = "CLAIM_SUBMITTED";
    public static final String CHANGE_TYPE_CLAIM_STATUS_CHANGED = "CLAIM_STATUS_CHANGED";

    // Pagination
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;

    // Date Formats
    public static final String DATE_FORMAT = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

    // File Upload
    public static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    public static final String[] ALLOWED_FILE_EXTENSIONS = { ".pdf", ".jpg", ".jpeg", ".png", ".doc", ".docx" };

    // Notification Types
    public static final String NOTIFICATION_TYPE_INFO = "INFO";
    public static final String NOTIFICATION_TYPE_SUCCESS = "SUCCESS";
    public static final String NOTIFICATION_TYPE_WARNING = "WARNING";
    public static final String NOTIFICATION_TYPE_DANGER = "DANGER";

    // Notification Categories
    public static final String NOTIFICATION_CAT_ENROLLMENT = "ENROLLMENT";
    public static final String NOTIFICATION_CAT_CLAIM = "CLAIM";
    public static final String NOTIFICATION_CAT_SYSTEM = "SYSTEM";
    public static final String NOTIFICATION_CAT_POLICY = "POLICY";

    private Constants() {
        // Private constructor to prevent instantiation
    }
}
