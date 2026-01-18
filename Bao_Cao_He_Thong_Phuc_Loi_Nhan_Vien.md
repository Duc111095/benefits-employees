# BÁO CÁO CHI TIẾT HỆ THỐNG QUẢN LÝ PHÚC LỢI NHÂN VIÊN (EMPLOYEE BENEFITS MANAGEMENT SYSTEM)

**Phiên bản:** 1.0  
**Tác giả:** Antigravity AI Assistant  
**Ngày lập:** 18/01/2026  
**Dự án:** Số hóa và Tự động hóa Quản lý Phúc lợi Doanh nghiệp nhỏ

---

## MỤC LỤC

1. [Chương 1: Tổng quan dự án](#chương-1-tổng-quan-dự-án)
2. [Chương 2: Phân tích yêu cầu và Nghiệp vụ](#chương-2-phân-tích-yêu-cầu-và-nghiệp-vụ)
3. [Chương 3: Kiến trúc hệ thống và Công nghệ](#chương-3-kiến-trúc-hệ-thống-và-công-nghệ)
4. [Chương 4: Thiết kế cơ sở dữ liệu chi tiết](#chương-4-thiết-kế-cơ-sở-dữ-liệu-chi-tiết)
5. [Chương 5: Phân hệ Quản lý Nhân sự và Tổ chức](#chương-5-phân-hệ-quản-lý-nhân-sự-và-tổ-chức)
6. [Chương 6: Phân hệ Danh mục và Chính sách Phúc lợi](#chương-6-phân-hệ-danh-mục-và-chính-sách-phúc-lợi)
7. [Chương 7: Phân hệ Gán phúc lợi và Lịch sử (Enrollment)](#chương-7-phân-hệ-gán-phúc-lợi-và-lịch-sử-enrollment)
8. [Chương 8: Phân hệ Yêu cầu và Phê duyệt chi phí (Claims)](#chương-8-phân-hệ-yêu-cầu-và-phê-duyệt-chi-phí-claims)
9. [Chương 9: Bảo mật, Phân quyền và Tìm kiếm](#chương-9-bảo-mật-phân-quền-và-tìm-kiếm)
10. [Chương 10: Báo cáo Thống kê và Hướng phát triển](#chương-10-báo-cáo-thống-kê-và-hướng-phát-triển)

---

## CHƯƠNG 1: TỔNG QUAN DỰ ÁN

### 1.1. Bối cảnh
Trong các doanh nghiệp quy mô vừa và nhỏ (SME), việc quản lý phúc lợi thường bị xem nhẹ hoặc thực hiện một cách rời rạc qua bảng tính Excel. Khi số lượng nhân sự đạt ngưỡng 100, các vấn đề về sai sót dữ liệu, chậm trễ trong phê duyệt và khó khăn trong việc tổng hợp chi phí thực tế trở thành rào cản lớn cho bộ phận HR và ban lãnh đạo.

### 1.2. Mục tiêu hệ thống
Dự án được xây dựng nhằm:
- **Tập trung hóa dữ liệu**: Mọi gói bảo hiểm, hỗ trợ đào tạo, khám sức khỏe được quản lý tại một nơi.
- **Minh bạch hóa chi phí**: Theo dõi chính xác mức đóng góp của công ty và nhân viên.
- **Tối ưu hóa quy trình**: Chuyển đổi từ phê duyệt giấy sang quy trình số hóa hoàn toàn.
- **Hỗ trợ ra quyết định**: Báo cáo đa chiều về mức độ sử dụng ngân sách phúc lợi.

---

## CHƯƠNG 2: PHÂN TÍCH YÊU CẦU VÀ NGHIỆP VỤ

### 2.1. Đối tượng sử dụng (Actors)
1. **ADMIN**: Quản trị toàn bộ hệ thống, thiết lập danh mục nền tảng.
2. **MANAGER (Giám đốc bộ phận)**: Phê duyệt các yêu cầu sử dụng phúc lợi của nhân viên cấp dưới, xem báo cáo chi phí bộ phận.
3. **HR (Nhân sự)**: Cập nhật thông tin nhân viên, gán gói phúc lợi, nhập dữ liệu giao dịch và theo dõi lịch sử.

### 2.2. Quy trình nghiệp vụ cốt lõi (Core Workflows)

#### 2.2.1. Quy trình Thiết lập Chính sách
Phòng HR định nghĩa các "Gói phúc lợi" (Benefit Plans) dựa trên "Loại phúc lợi" (Benefit Types). Mỗi gói có ngân sách (budget), mức đóng và điều kiện áp dụng riêng.

#### 2.2.2. Quy trình Gán Phúc lợi (Enrollment)
Nhân viên sau khi ký hợp đồng chính thức sẽ được HR gán vào các gói phúc lợi tương ứng (ví dụ: Bảo hiểm sức khỏe Basic cho nhân viên mới, Premium cho quản lý). Hệ thống lưu lại lịch sử thay đổi để phục vụ kiểm toán.

#### 2.2.3. Quy trình Khiếu nại và Phê duyệt (Claims/Usage)
Khi nhân viên sử dụng phúc lợi (đi khám bệnh, đi học), họ (hoặc HR thay mặt) gửi yêu cầu thanh toán kèm theo chứng từ. Manager sẽ duyệt dựa trên số dư ngân sách còn lại của gói.

---

## CHƯƠNG 3: KIẾN TRÚC HỆ THỐNG VÀ CÔNG NGHỆ

### 3.1. Mô hình kiến trúc
Hệ thống sử dụng kiến trúc **Monolithic Layered Architecture** (Kiến trúc phân lớp nguyên khối) nhưng được module hóa rõ rệt để dễ dàng mở rộng thành Microservices trong tương lai.

- **Web Layer**: Sử dụng JavaServer Pages (JSP) để render giao diện phía server, kết hợp với Bootstrap 5 cho tính phản hồi (Responsive).
- **Controller Layer**: Spring MVC xử lý các request HTTP, điều hướng và quản lý dữ liệu model.
- **Service Layer**: Chứa toàn bộ logic nghiệp vụ (Business Rules). Đây là tầng quan trọng nhất của hệ thống.
- **Data Access Layer**: Spring Data JPA kết hợp Hibernate để tương tác với cơ sở dữ liệu MySQL một cách trừu tượng.

### 3.2. Ngôn ngữ và Framework
- **Java 17 (LTS)**: Đảm bảo tính ổn định và tận dụng các tính năng mới như Records, Sealed Classes (mặc dù project này dùng Class truyền thống cho JPA).
- **Spring Boot 3.5.7**: Framework lõi giúp auto-configuration và nhúng server Tomcat.
- **Spring Security**: Bảo mật đa tầng, quản lý session và phân quyền dựa trên Role.
- **Lombok**: Giảm thiểu code boilerplate (getter/setter/constructor).

---

## CHƯƠNG 4: THIẾT KẾ CƠ SỞ DỮ LIỆU CHI TIẾT

Cơ sở dữ liệu được thiết kế theo chuẩn 3NF để tránh dư thừa dữ liệu.

### 4.1. Thực thể Người dùng (`users`)
Lưu trữ định danh người dùng hệ thống.
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL, -- ADMIN, MANAGER, HR
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 4.2. Thực thể Gói phúc lợi (`benefit_plans`)
Định nghĩa các chính sách phúc lợi.
- **company_contribution**: Số tiền công ty chi trả.
- **employee_contribution**: Số tiền nhân viên đóng góp.
- **budget**: Ngân sách tối đa cho gói.

### 4.3. Quan hệ Gán phúc lợi (`enrollments`)
Mối quan hệ n-n giữa Nhân viên (`employees`) và Gói phúc lợi (`benefit_plans`).

---

## CHƯƠNG 5: PHÂN HỆ QUẢN LÝ NHÂN SỰ VÀ TỔ CHỨC

### 5.1. Quản lý Phòng ban (`com.benefits.module.department`)
Hệ thống cho phép cấu trúc công ty theo sơ đồ phòng ban. Mỗi phòng ban có một người quản lý (`manager_employee_id`) chịu trách nhiệm duyệt chi phí.
- Thao tác: Thêm mới, Sửa thông tin, Tìm kiếm theo tên/mã.

### 5.2. Quản lý Nhân viên (`com.benefits.module.employee`)
Hồ sơ nhân viên bao gồm thông tin cá nhân và thông tin công việc. 
- **Employee Code**: Định danh nghiệp vụ duy nhất.
- **Trạng thái**: ACTIVE, INACTIVE, TERMINATED.

---

## CHƯƠNG 6: PHÂN HỆ DANH MỤC VÀ CHÍNH SÁCH PHÚC LỢI

Đây là "Trái tim" của hệ thống, quản lý những gì nhân viên sẽ nhận được.

### 6.1. Loại phúc lợi (Benefit Types)
Phân loại các hình thức hỗ trợ: Health, Education, Wellness, v.v.

### 6.2. Cấu trúc Gói phúc lợi (Benefit Plans)
Mỗi gói có mã (`plan_code`) và tên (`plan_name`). Quan trọng nhất là `eligibility_criteria` (điều kiện tham gia) giúp HR quyết định gán gói cho nhân viên nào.

---

## CHƯƠNG 7: PHÂN HỆ GÁN PHÚC LỢI VÀ LỊCH SỬ (ENROLLMENT)

### 7.1. Ghi nhận đăng ký
Hệ thống ghi lại mức đóng góp tại thời điểm đăng ký, đề phòng trường hợp gói phúc lợi thay đổi đơn giá trong tương lai.

### 7.2. Lịch sử Audit
Bảng `enrollment_history` ghi lại mọi biến động: "Nâng cấp gói", "Gia hạn gói", "Hủy gói".

---

## CHƯƠNG 8: PHÂN HỆ YÊU CẦU VÀ PHÊ DUYỆT CHI PHÍ (CLAIMS)

### 8.1. Workflow Claims
1. Nhân viên nộp yêu cầu (`BenefitClaim`).
2. Hệ thống tải tài liệu lên thư mục tập trung.
3. Người phê duyệt (Manager/Admin) kiểm tra và cập nhật trạng thái.

---

## CHƯƠNG 9: BẢO MẬT, PHÂN QUYỀN VÀ TÌM KIẾM

### 9.1. Quản lý Quyền hạn
- **ADMIN**: Có quyền truy cập `Dashboard`, cấu trúc hệ thống, logs.
- **HR**: Thao tác nghiệp vụ nhân sự và gán gói.
- **MANAGER**: Phê duyệt claims của bộ phận mình.

---

## CHƯƠNG 10: BÁO CÁO THỐNG KÊ VÀ HƯỚNG PHÁT TRIỂN

### 10.1. Dashboard Quản trị
Hiển thị:
- Tổng số nhân viên.
- Số lượng đăng ký mới trong tháng.
- Số lượng Claims đang chờ duyệt.

### 10.2. Kết luận
Hệ thống đáp ứng đầy đủ yêu cầu quản lý phúc lợi cho các doanh nghiệp nhỏ, đảm bảo tính chính xác, bảo mật và khả năng tra soát cao.

---
**HẾT BÁO CÁO**
