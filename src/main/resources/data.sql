-- Sample data for Employee Benefits Management System

-- Insert departments
INSERT INTO departments (code, name, description, active) VALUES
('IT', 'Information Technology', 'IT Department handling all technology needs', TRUE),
('HR', 'Human Resources', 'HR Department managing employee relations', TRUE),
('FIN', 'Finance', 'Finance Department managing company finances', TRUE),
('OPS', 'Operations', 'Operations Department managing daily operations', TRUE),
('MKT', 'Marketing', 'Marketing Department handling promotions', TRUE);

-- Insert sample employees
INSERT INTO employees (employee_code, full_name, email, phone, date_of_birth, hire_date, department_id, position, status, gender, address, basic_salary) VALUES
('EMP001', 'Nguyen Van A', 'nguyenvana@company.com', '0901234567', '1990-01-15', '2020-01-10', 1, 'Senior Developer', 'ACTIVE', 'MALE', '123 Tech Street, Hanoi', 25000000),
('EMP002', 'Tran Thi B', 'tranthib@company.com', '0901234568', '1992-03-20', '2020-03-15', 2, 'HR Manager', 'ACTIVE', 'FEMALE', '456 HR Lane, Hanoi', 30000000),
('EMP003', 'Le Van C', 'levanc@company.com', '0901234569', '1988-05-10', '2019-05-20', 3, 'Financial Analyst', 'ACTIVE', 'MALE', '789 Finance Blvd, Hanoi', 22000000),
('EMP004', 'Pham Thi D', 'phamthid@company.com', '0901234570', '1995-07-25', '2021-07-01', 1, 'Junior Developer', 'ACTIVE', 'FEMALE', '321 Code Ave, Hanoi', 15000000),
('EMP005', 'Hoang Van E', 'hoangvane@company.com', '0901234571', '1991-09-30', '2020-09-15', 4, 'Operations Manager', 'ACTIVE', 'MALE', '654 Ops Road, Hanoi', 28000000),
('EMP006', 'Vo Thi F', 'vothif@company.com', '0901234572', '1993-11-12', '2021-11-20', 5, 'Marketing Specialist', 'ACTIVE', 'FEMALE', '987 Brand Way, Hanoi', 18000000),
('EMP007', 'Dang Van G', 'dangvang@company.com', '0901234573', '1989-02-18', '2019-02-25', 1, 'Tech Lead', 'ACTIVE', 'MALE', '147 Server Place, Hanoi', 40000000),
('EMP008', 'Bui Thi H', 'buithih@company.com', '0901234574', '1994-04-22', '2021-04-10', 2, 'HR Specialist', 'ACTIVE', 'FEMALE', '258 People St, Hanoi', 16000000),
('EMP009', 'Ngo Van I', 'ngovani@company.com', '0901234575', '1987-06-08', '2018-06-15', 3, 'Senior Accountant', 'ACTIVE', 'MALE', '369 Money Blvd, Hanoi', 24000000),
('EMP010', 'Truong Thi K', 'truongthik@company.com', '0901234576', '1996-08-14', '2022-08-01', 4, 'Operations Acc', 'ACTIVE', 'FEMALE', '741 Logistics Ln, Hanoi', 14000000);

-- Insert default users (password: 123456 - BCrypt encoded)
-- Note: Moved after employees to satisfy foreign key (employee_id)
INSERT INTO users (username, password, email, role, active, employee_id) VALUES
('admin', '$2a$10$cuGX1rWQllXyR4U7Wgc8uOGUM73r9HJM0dEnbuP5C5Z9e1sgIja16', 'admin@company.com', 'ADMIN', TRUE, NULL),
('hr_manager', '$2a$10$cuGX1rWQllXyR4U7Wgc8uOGUM73r9HJM0dEnbuP5C5Z9e1sgIja16', 'hr@company.com', 'HR_MANAGER', TRUE, 2),
('manager', '$2a$10$cuGX1rWQllXyR4U7Wgc8uOGUM73r9HJM0dEnbuP5C5Z9e1sgIja16', 'manager@company.com', 'MANAGER', TRUE, 7),
('employee', '$2a$10$cuGX1rWQllXyR4U7Wgc8uOGUM73r9HJM0dEnbuP5C5Z9e1sgIja16', 'emp@company.com', 'EMPLOYEE', TRUE, 1);

-- Update department managers
UPDATE departments SET manager_employee_id = 7 WHERE code = 'IT';
UPDATE departments SET manager_employee_id = 2 WHERE code = 'HR';
UPDATE departments SET manager_employee_id = 9 WHERE code = 'FIN';
UPDATE departments SET manager_employee_id = 5 WHERE code = 'OPS';
UPDATE departments SET manager_employee_id = 6 WHERE code = 'MKT';

-- Insert benefit types
INSERT INTO benefit_types (code, name, description, active) VALUES
('HEALTH', 'Health Insurance', 'Medical and health coverage for employees', TRUE),
('DENTAL', 'Dental Insurance', 'Dental care coverage', TRUE),
('LIFE', 'Life Insurance', 'Life insurance coverage', TRUE),
('TRAINING', 'Training & Development', 'Professional development and training programs', TRUE),
('WELLNESS', 'Wellness Program', 'Annual health checkups and wellness activities', TRUE),
('PENSION', 'Pension Plan', 'Retirement pension plan', TRUE);

-- Insert benefit plans
INSERT INTO benefit_plans (plan_code, plan_name, benefit_type_id, description, eligibility_criteria, 
    company_contribution, employee_contribution, budget, effective_date, expiry_date, active, limit_value, limit_type, processing_workflow, important_notes) VALUES
('HEALTH-BASIC', 'Basic Health Insurance', 1, 'Basic health coverage for all employees', 
    'All full-time employees', 500000, 100000, 60000000, '2024-01-01', '2024-12-31', TRUE, 5000000, 'AMOUNT', 'Standard Claim Process', 'Covers basic hospitalization'),
('HEALTH-PREMIUM', 'Premium Health Insurance', 1, 'Premium health coverage with extended benefits', 
    'Employees with 2+ years service', 800000, 200000, 40000000, '2024-01-01', '2024-12-31', TRUE, 10000000, 'AMOUNT', 'Priority Claim Process', 'Includes dental and optical'),
('DENTAL-STD', 'Standard Dental Plan', 2, 'Standard dental coverage', 
    'All full-time employees', 200000, 50000, 15000000, '2024-01-01', '2024-12-31', TRUE, 2000000, 'AMOUNT', 'Direct Billing', 'Orthodontics not included'),
('LIFE-STD', 'Standard Life Insurance', 3, 'Life insurance coverage', 
    'All full-time employees', 300000, 0, 30000000, '2024-01-01', '2024-12-31', TRUE, 100000000, 'AMOUNT', 'Beneficiary Payout', 'Coverage up to 100M VND'),
('TRAINING-TECH', 'Technical Training Program', 4, 'Technical skills development', 
    'IT Department employees', 5000000, 0, 50000000, '2024-01-01', '2024-12-31', TRUE, 10000000, 'AMOUNT', 'Manager Approval Required', 'Must be relevant to job role'),
('WELLNESS-2024', 'Annual Wellness Program', 5, 'Annual health checkup and wellness activities', 
    'All employees', 2000000, 0, 200000000, '2024-01-01', '2024-12-31', TRUE, 2000000, 'AMOUNT', 'Direct Billing', 'Partner clinics only'),
('PENSION-STD', 'Standard Pension Plan', 6, 'Company pension contribution', 
    'Employees with 1+ year service', 1000000, 500000, 150000000, '2024-01-01', NULL, TRUE, 5, 'PERCENTAGE', 'Automatic Monthly', 'Based on basic salary');

-- Insert sample enrollments
INSERT INTO enrollments (employee_id, benefit_plan_id, enrollment_date, effective_date, status, 
    company_contribution, employee_contribution, notes, created_by) VALUES
(1, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1),
(1, 3, '2024-01-15', '2024-02-01', 'ACTIVE', 200000, 50000, 'Initial enrollment', 1),
(1, 4, '2024-01-15', '2024-02-01', 'ACTIVE', 300000, 0, 'Initial enrollment', 1),
(1, 5, '2024-01-20', '2024-02-01', 'ACTIVE', 5000000, 0, 'Technical training approved', 1),
(2, 2, '2024-01-15', '2024-02-01', 'ACTIVE', 800000, 200000, 'Premium plan for senior staff', 1),
(2, 3, '2024-01-15', '2024-02-01', 'ACTIVE', 200000, 50000, 'Initial enrollment', 1),
(2, 4, '2024-01-15', '2024-02-01', 'ACTIVE', 300000, 0, 'Initial enrollment', 1),
(3, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1),
(3, 7, '2024-01-15', '2024-02-01', 'ACTIVE', 1000000, 500000, 'Pension enrollment', 1),
(4, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1),
(5, 2, '2024-01-15', '2024-02-01', 'ACTIVE', 800000, 200000, 'Premium plan for manager', 1),
(6, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1),
(7, 2, '2024-01-15', '2024-02-01', 'ACTIVE', 800000, 200000, 'Premium plan for senior staff', 1),
(7, 5, '2024-01-20', '2024-02-01', 'ACTIVE', 5000000, 0, 'Technical training approved', 1),
(8, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1),
(9, 2, '2024-01-15', '2024-02-01', 'ACTIVE', 800000, 200000, 'Premium plan for senior staff', 1),
(10, 1, '2024-01-15', '2024-02-01', 'ACTIVE', 500000, 100000, 'Initial enrollment', 1);

-- Insert sample benefit balances
-- Example for Employee 1 (Health, Life, Training)
INSERT INTO benefit_balances (employee_id, benefit_type_id, `year`, total_limit, used_amount, remaining_amount) VALUES
(1, 1, 2024, 5000000, 1500000, 3500000), -- Health (Used 1.5M)
(1, 2, 2024, 2000000, 500000, 1500000), -- Dental (Used 500k)
(1, 3, 2024, 100000000, 0, 100000000), -- Life
(1, 4, 2024, 10000000, 0, 10000000);   -- Training

-- Example for Employee 2 (Health Premium, Dental, Life)
INSERT INTO benefit_balances (employee_id, benefit_type_id, `year`, total_limit, used_amount, remaining_amount) VALUES
(2, 1, 2024, 10000000, 2000000, 8000000), -- Health Premium (Used 2M)
(2, 2, 2024, 2000000, 0, 2000000),       -- Dental
(2, 3, 2024, 100000000, 0, 100000000);   -- Life

-- Insert sample enrollment history
INSERT INTO enrollment_history (enrollment_id, change_type, changed_by, old_value, new_value, notes) VALUES
(1, 'CREATED', 1, NULL, 'Status: ACTIVE', 'Initial enrollment created'),
(2, 'CREATED', 1, NULL, 'Status: ACTIVE', 'Initial enrollment created'),
(5, 'CREATED', 1, NULL, 'Status: ACTIVE', 'Premium plan enrollment');

-- Insert sample benefit claims
INSERT INTO benefit_claims (enrollment_id, employee_id, claim_date, claim_amount, description, 
    status, submitted_by, approval_date, approved_by) VALUES
(1, 1, '2024-03-15', 1500000, 'Medical checkup and treatment', 'APPROVED', 1, '2024-03-16 10:30:00', 3),
(2, 1, '2024-04-10', 500000, 'Dental cleaning and filling', 'APPROVED', 1, '2024-04-11 14:20:00', 3),
(5, 2, '2024-03-20', 2000000, 'Hospital admission for surgery', 'APPROVED', 2, '2024-03-21 09:15:00', 3),
(8, 3, '2024-05-05', 800000, 'Outpatient treatment', 'APPROVED', 2, '2024-05-06 11:00:00', 3),
(10, 4, '2024-06-01', 600000, 'Medical consultation', 'PENDING', 1, NULL, NULL),
(14, 7, '2024-02-15', 3000000, 'AWS Certification training', 'APPROVED', 1, '2024-02-16 15:30:00', 3);

-- Insert sample notifications
INSERT INTO notifications (recipient_id, title, message, type, category, is_read, created_at) VALUES
(1, 'Welcome', 'Welcome to the Benefit System', 'INFO', 'SYSTEM', FALSE, NOW()),
(2, 'Claim Approved', 'Your claim #1001 has been approved', 'SUCCESS', 'CLAIM', FALSE, NOW()),
(4, 'Benefit Enrollment', 'New benefit plans are available for 2024', 'INFO', 'ENROLLMENT', TRUE, NOW()),
(3, 'Action Required', 'Please review pending claim approvals', 'WARNING', 'CLAIM', FALSE, NOW());
