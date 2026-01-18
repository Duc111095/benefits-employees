-- Employee Benefits Management System Database Schema (H2 Dedicated)
SET FOREIGN_KEY_CHECKS = 0;
DROP ALL OBJECTS;

-- 1. Create tables without constraints first to handle circular dependencies

-- Users table
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role VARCHAR(20) NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    employee_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE departments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    manager_employee_id BIGINT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Employees table
CREATE TABLE employees (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    hire_date DATE NOT NULL,
    department_id BIGINT,
    position VARCHAR(100),
    gender VARCHAR(10),
    address TEXT,
    basic_salary DOUBLE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Benefit Types table
CREATE TABLE benefit_types (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Benefit Plans table
CREATE TABLE benefit_plans (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    plan_code VARCHAR(20) NOT NULL UNIQUE,
    plan_name VARCHAR(100) NOT NULL,
    benefit_type_id BIGINT NOT NULL,
    description TEXT,
    eligibility_criteria TEXT,
    company_contribution DECIMAL(15,2) DEFAULT 0,
    employee_contribution DECIMAL(15,2) DEFAULT 0,
    budget DECIMAL(15,2),
    effective_date DATE NOT NULL,
    expiry_date DATE,
    limit_value DECIMAL(15,2),
    limit_type VARCHAR(20),
    processing_workflow TEXT,
    important_notes TEXT,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Benefit Balances table
CREATE TABLE benefit_balances (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    benefit_type_id BIGINT NOT NULL,
    `year` INT NOT NULL,
    total_limit DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    used_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    remaining_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Enrollments table
CREATE TABLE enrollments (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    employee_id BIGINT NOT NULL,
    benefit_plan_id BIGINT NOT NULL,
    enrollment_date DATE NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'ACTIVE',
    company_contribution DECIMAL(15,2) DEFAULT 0,
    employee_contribution DECIMAL(15,2) DEFAULT 0,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by BIGINT
);

-- Enrollment History table
CREATE TABLE enrollment_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id BIGINT NOT NULL,
    change_type VARCHAR(50) NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by BIGINT,
    old_value TEXT,
    new_value TEXT,
    notes TEXT
);

-- Benefit Claims table
CREATE TABLE benefit_claims (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    claim_date DATE NOT NULL,
    claim_amount DECIMAL(15,2) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    attachment_path VARCHAR(500),
    submitted_by BIGINT,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_by BIGINT,
    approval_date TIMESTAMP,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE notifications (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    recipient_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(20) NOT NULL,
    category VARCHAR(20) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Claim History table
CREATE TABLE claim_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    claim_id BIGINT NOT NULL,
    change_type VARCHAR(50) NOT NULL,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by BIGINT,
    old_value TEXT,
    new_value TEXT,
    notes TEXT
);

-- 2. Add Constraints and Indexes

-- Users
ALTER TABLE users ADD CONSTRAINT fk_user_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE SET NULL;

-- Departments
ALTER TABLE departments ADD CONSTRAINT fk_dept_manager FOREIGN KEY (manager_employee_id) REFERENCES employees(id) ON DELETE SET NULL;
CREATE INDEX idx_dept_name ON departments(name);

-- Employees
ALTER TABLE employees ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL;
CREATE INDEX idx_emp_full_name ON employees(full_name);
CREATE INDEX idx_emp_department ON employees(department_id);
CREATE INDEX idx_emp_status ON employees(status);

-- Benefit Types
CREATE INDEX idx_bt_name ON benefit_types(name);

-- Benefit Plans
ALTER TABLE benefit_plans ADD CONSTRAINT fk_plan_type FOREIGN KEY (benefit_type_id) REFERENCES benefit_types(id);
CREATE INDEX idx_plan_name ON benefit_plans(plan_name);
CREATE INDEX idx_plan_type ON benefit_plans(benefit_type_id);
CREATE INDEX idx_plan_effective ON benefit_plans(effective_date);
CREATE INDEX idx_plan_active ON benefit_plans(active);

-- Benefit Balances
ALTER TABLE benefit_balances ADD CONSTRAINT fk_bal_emp FOREIGN KEY (employee_id) REFERENCES employees(id);
ALTER TABLE benefit_balances ADD CONSTRAINT fk_bal_type FOREIGN KEY (benefit_type_id) REFERENCES benefit_types(id);
ALTER TABLE benefit_balances ADD CONSTRAINT unq_bal_emp_type_year UNIQUE (employee_id, benefit_type_id, `year`);

-- Enrollments
ALTER TABLE enrollments ADD CONSTRAINT fk_enr_emp FOREIGN KEY (employee_id) REFERENCES employees(id);
ALTER TABLE enrollments ADD CONSTRAINT fk_enr_plan FOREIGN KEY (benefit_plan_id) REFERENCES benefit_plans(id);
CREATE INDEX idx_enr_employee ON enrollments(employee_id);
CREATE INDEX idx_enr_plan ON enrollments(benefit_plan_id);
CREATE INDEX idx_enr_status ON enrollments(status);
CREATE INDEX idx_enr_effective ON enrollments(effective_date);

-- Enrollment History
ALTER TABLE enrollment_history ADD CONSTRAINT fk_enr_hist_enr FOREIGN KEY (enrollment_id) REFERENCES enrollments(id);
CREATE INDEX idx_enr_hist_enr ON enrollment_history(enrollment_id);
CREATE INDEX idx_enr_hist_date ON enrollment_history(change_date);

-- Benefit Claims
ALTER TABLE benefit_claims ADD CONSTRAINT fk_claim_enr FOREIGN KEY (enrollment_id) REFERENCES enrollments(id);
ALTER TABLE benefit_claims ADD CONSTRAINT fk_claim_emp FOREIGN KEY (employee_id) REFERENCES employees(id);
CREATE INDEX idx_claim_enr ON benefit_claims(enrollment_id);
CREATE INDEX idx_claim_emp ON benefit_claims(employee_id);
CREATE INDEX idx_claim_status ON benefit_claims(status);
CREATE INDEX idx_claim_date ON benefit_claims(claim_date);

-- Claim History
ALTER TABLE claim_history ADD CONSTRAINT fk_claim_hist_claim FOREIGN KEY (claim_id) REFERENCES benefit_claims(id);
CREATE INDEX idx_claim_hist_claim ON claim_history(claim_id);
CREATE INDEX idx_claim_hist_date ON claim_history(change_date);

-- Notifications
ALTER TABLE notifications ADD CONSTRAINT fk_notif_recipient FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE;
CREATE INDEX idx_notif_recipient ON notifications(recipient_id);
CREATE INDEX idx_notif_read ON notifications(is_read);

SET FOREIGN_KEY_CHECKS = 1;
