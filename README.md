# Employee Benefits Management System

A comprehensive web application for managing employee benefits in small enterprises (≤100 employees) using Java Spring Boot and JSP.

## Project Overview

This system digitizes employee benefits management with centralized data, history tracking, approval workflows, and comprehensive reporting capabilities.

### Key Features

- **Employee Management**: Manage employee master data and organizational structure
- **Department Management**: Organize employees by departments
- **Benefits Management**: Define benefit types and plans with eligibility criteria
- **Enrollment Management**: Assign benefits to employees with history tracking
- **Claims Processing**: Record benefit usage with approval workflow and document attachments
- **Reporting**: Generate statistics and cost analysis reports
- **Search**: Global search functionality across the system
- **Role-Based Access**: ADMIN, MANAGER, and HR roles with different permissions

## Technology Stack

- **Backend**: Java 17, Spring Boot 3.5.7
- **Frontend**: JSP, JSTL, Bootstrap 5.3
- **Database**: MySQL 8.0
- **Build Tool**: Maven
- **Security**: Spring Security with session-based authentication
- **ORM**: Spring Data JPA / Hibernate

## Project Structure

```
benefit-employees/
├── src/main/java/com/benefits/
│   ├── BenefitsApplication.java          # Main application class
│   ├── config/                            # Configuration classes
│   │   └── WebMvcConfig.java             # MVC and view resolver config
│   ├── security/                          # Security configuration
│   │   └── SecurityConfig.java           # Spring Security setup
│   ├── common/                            # Common utilities
│   │   └── Constants.java                # Application constants
│   ├── controller/                        # Main controllers
│   │   └── DashboardController.java      # Dashboard controller
│   └── module/                            # Modular structure
│       ├── auth/                          # Module 1: Authentication
│       │   ├── entity/User.java
│       │   ├── repository/UserRepository.java
│       │   ├── service/AuthService.java
│       │   ├── service/CustomUserDetailsService.java
│       │   └── controller/AuthController.java
│       ├── department/                    # Module 2: Department Management
│       │   ├── entity/Department.java
│       │   ├── repository/DepartmentRepository.java
│       │   ├── service/DepartmentService.java
│       │   └── controller/DepartmentController.java
│       ├── employee/                      # Module 3: Employee Management
│       │   ├── entity/Employee.java
│       │   ├── repository/
│       │   ├── service/
│       │   └── controller/
│       ├── benefit/                       # Module 4: Benefits Management
│       │   ├── entity/BenefitType.java
│       │   ├── entity/BenefitPlan.java
│       │   ├── repository/
│       │   ├── service/
│       │   └── controller/
│       ├── enrollment/                    # Module 5: Enrollment Management
│       │   ├── entity/Enrollment.java
│       │   ├── entity/EnrollmentHistory.java
│       │   ├── repository/
│       │   ├── service/
│       │   └── controller/
│       ├── claim/                         # Module 6: Claims Management
│       │   ├── entity/BenefitClaim.java
│       │   ├── repository/
│       │   ├── service/
│       │   └── controller/
│       ├── report/                        # Module 7: Reporting
│       │   ├── service/
│       │   └── controller/
│       └── search/                        # Module 8: Search
│           ├── service/
│           └── controller/
├── src/main/resources/
│   ├── application.properties             # Application configuration
│   ├── schema.sql                         # Database schema
│   ├── data.sql                           # Sample data
│   └── static/                            # Static resources
│       ├── css/style.css                  # Custom styles
│       ├── js/main.js                     # JavaScript utilities
│       └── images/
├── src/main/webapp/WEB-INF/views/         # JSP views
│   ├── auth/                              # Authentication views
│   │   └── login.jsp
│   ├── common/                            # Shared layouts
│   │   ├── header.jsp
│   │   └── footer.jsp
│   ├── dashboard.jsp                      # Main dashboard
│   ├── department/                        # Department views
│   │   ├── department-list.jsp
│   │   └── department-form.jsp
│   ├── employee/                          # Employee views
│   ├── benefit/                           # Benefit views
│   ├── enrollment/                        # Enrollment views
│   ├── claim/                             # Claim views
│   ├── report/                            # Report views
│   └── search/                            # Search views
└── pom.xml                                # Maven configuration
```

## Module Description

### Module 1: Authentication & Authorization
- User login/logout
- Session management
- Role-based access control (ADMIN, MANAGER, HR)
- Password management

### Module 2: Department Management
- CRUD operations for departments
- Department search and filtering
- Manager assignment

### Module 3: Employee Management
- Employee master data management
- Department assignment
- Employee status tracking
- Search and filtering

### Module 4: Benefits Management
- Benefit type categorization
- Benefit plan/policy management
- Eligibility criteria definition
- Budget tracking
- Contribution levels (company/employee)

### Module 5: Enrollment Management
- Assign benefits to employees
- Track enrollment history
- Manage enrollment lifecycle
- Audit trail for changes

### Module 6: Claims/Usage Management
- Submit benefit claims
- Document attachment support
- Approval workflow (PENDING → APPROVED/REJECTED)
- Claim history tracking

### Module 7: Reporting Module
- Cost analysis by department
- Cost analysis by benefit type
- Time-based reports
- Enrollment statistics
- Export to Excel/PDF

### Module 8: Search Module
- Global search across employees, benefits, enrollments, claims
- Advanced filtering

## Database Schema

### Core Tables
1. **users** - System users with authentication
2. **departments** - Organizational structure
3. **employees** - Employee master data
4. **benefit_types** - Benefit categories
5. **benefit_plans** - Benefit policies/plans
6. **enrollments** - Employee benefit assignments
7. **enrollment_history** - Audit trail
8. **benefit_claims** - Usage transactions

## Setup Instructions

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0+
- IDE (IntelliJ IDEA, Eclipse, or VS Code)

### Database Setup

1. Create MySQL database:
```sql
CREATE DATABASE benefits_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Update database credentials in `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/benefits_db
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. Run the schema and data scripts:
```bash
mysql -u your_username -p benefits_db < src/main/resources/schema.sql
mysql -u your_username -p benefits_db < src/main/resources/data.sql
```

### Build and Run

1. Clone the repository:
```bash
cd /home/ducnh/java-dev/benefit-employees
```

2. Build the project:
```bash
./mvnw clean install
```

3. Run the application:
```bash
./mvnw spring-boot:run
```

4. Access the application:
```
http://localhost:8080/benefits
```

### Default Credentials

- **Admin**: username: `admin`, password: `admin123`
- **HR User**: username: `hr_user`, password: `hr123`
- **Manager**: username: `manager`, password: `manager123`

## Usage Guide

### Login
1. Navigate to `http://localhost:8080/benefits`
2. Enter credentials
3. Click "Login"

### Managing Departments
1. Click "Departments" in navigation
2. Click "Add Department" to create new
3. Fill in department details
4. Click "Save"

### Managing Employees
1. Click "Employees" in navigation
2. Click "Add Employee" to create new
3. Select department and fill details
4. Click "Save"

### Managing Benefits
1. Navigate to "Benefits" → "Benefit Types" or "Benefit Plans"
2. Create benefit types first (e.g., Health, Dental)
3. Create benefit plans with eligibility criteria and contributions
4. Set effective dates and budget

### Enrolling Employees
1. Click "Enrollments"
2. Click "New Enrollment"
3. Select employee and benefit plan
4. Set effective dates and contributions
5. Click "Save"

### Processing Claims
1. Click "Claims"
2. Click "New Claim"
3. Select enrollment and enter claim details
4. Upload supporting documents
5. Submit for approval
6. Managers/Admins can approve/reject claims

### Generating Reports
1. Click "Reports"
2. Select report type (by department, benefit type, time period)
3. Set filters and date ranges
4. Click "Generate"
5. Export to Excel or PDF

## API Endpoints

### Authentication
- `GET /auth/login` - Login page
- `POST /auth/login` - Process login
- `POST /auth/logout` - Logout

### Departments
- `GET /department` - List all departments
- `GET /department/new` - New department form
- `GET /department/edit/{id}` - Edit department form
- `POST /department/save` - Save department
- `GET /department/delete/{id}` - Delete department
- `GET /department/search` - Search departments

### Similar patterns for other modules...

## Development Notes

### Adding New Modules
1. Create package under `com.benefits.module/`
2. Create entity, repository, service, controller
3. Create JSP views under `webapp/WEB-INF/views/`
4. Add navigation links in `header.jsp`
5. Configure security rules in `SecurityConfig.java`

### Customization
- Modify `application.properties` for configuration
- Update `style.css` for custom styling
- Extend `main.js` for additional JavaScript functionality

## Troubleshooting

### JSP pages not rendering
- Ensure `tomcat-embed-jasper` dependency is included
- Check view resolver configuration in `WebMvcConfig.java`
- Verify JSP files are in `/WEB-INF/views/` directory

### Database connection errors
- Verify MySQL is running
- Check credentials in `application.properties`
- Ensure database exists and schema is loaded

### Authentication issues
- Clear browser cookies
- Check user exists in database
- Verify password encoding matches

## Future Enhancements

- Integration with BHXH (Social Insurance) electronic system
- Integration with insurance providers
- Email notifications for claim approvals
- Mobile application
- Advanced analytics and dashboards
- Bulk import/export functionality
- Document management system
- Workflow customization

## License

This project is developed for educational and business purposes.

## Contact

For questions or support, please contact the development team.
