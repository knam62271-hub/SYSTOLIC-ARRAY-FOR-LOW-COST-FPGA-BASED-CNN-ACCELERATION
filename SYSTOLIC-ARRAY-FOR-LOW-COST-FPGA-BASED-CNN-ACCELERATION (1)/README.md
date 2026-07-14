# SYSTOLIC-ARRAY-FOR-LOW-COST-FPGA-BASED-CNN-ACCELERATION
**- Tổng hợp kiến trúc Systolic Array và các kỹ thuật tối ưu triển khai trên FPGA**

**Danh sách các chủ đề kỹ thuật**

## Mục lục
- [tong_quan_kien_truc](#tong_quan_kien_truc)
- [thiet_ke_processing_element](#thiet_ke_processing_element)
- [toi_uu_tan_so_layout](#toi_uu_tan_so_layout)
- [cong_cu_uoc_luong_dse](#cong_cu_uoc_luong_dse)
- [tinh_linh_hoat_mo_rong](#tinh_linh_hoat_mo_rong)
- [hieu_suat_he_thong](#hieu_suat_he_thong)
- [ket_luan](#ket_luan)

---

## tong_quan_kien_truc

Mô tả: Kiến trúc lưới các Processing Element (PE) kết nối cục bộ, dữ liệu di chuyển nhịp nhàng theo từng chu kỳ xung nhịp.

| Thuộc tính | Giá trị | Ghi chú |
|---|---|---|
| Cấu trúc | Lưới 2D đều đặn | Kết nối cục bộ giữa các PE |
| Tái sử dụng dữ liệu | Rất cao | Giảm băng thông bộ nhớ |
| Song song hóa | Cao | Tăng thông lượng xử lý |
| Ứng dụng tiêu biểu | Google TPU | Kiến trúc cốt lõi |
| Hiệu năng so với CPU/GPU | Nhanh hơn 15X–30X | Cùng thời điểm so sánh |
| Hiệu quả năng lượng | Gấp 30X–80X | So với CPU/GPU |

---

## thiet_ke_processing_element

File tham chiếu: `PE core / MAC unit`

| Kỹ thuật | Hướng tiếp cận | Hiệu quả |
|---|---|---|
| bit_level_mac | Dùng cổng AND, counter, shifter thay bộ nhân truyền thống | Giảm năng lượng 99 lần, giảm tài nguyên DSP, tăng hiệu suất PE 15 lần |
| lut_based_arch | Dùng LUT để bỏ qua bước tính trung gian, tra cứu trực tiếp từ ma trận mức bit | Giảm đáng kể độ trễ (latency) |
| dsp_dynamic_config | Tích hợp hàm kích hoạt ReLU trực tiếp vào lát cắt DSP | Tiết kiệm tài nguyên LUT (Transformer accelerator) |

---

## toi_uu_tan_so_layout

Thách thức: Công cụ CAD thường làm biến dạng cấu trúc mảng đều đặn → tần số hoạt động thấp.

| Giải pháp | Mô tả | Kết quả |
|---|---|---|
| front_end_segmentation | Chia nhỏ chuỗi tích lũy DSP quá dài | Rút ngắn đường dẫn dữ liệu tổ hợp |
| back_end_floorplanning | Đặt chỗ thủ công + tệp ràng buộc XDC để cố định vị trí PE | Tăng tần số 1.29 lần, đạt 588 MHz |
| dsp_direct_instantiation | Khởi tạo trực tiếp macro DSP thay vì để công cụ tự tổng hợp | Kiểm soát chính xác đường dẫn, tối đa hiệu suất |

---

## cong_cu_uoc_luong_dse

| Công cụ | Chức năng | Hiệu quả |
|---|---|---|
| AFHRE | Dự báo tài nguyên phần cứng (DSP, BRAM, LUT, FF) | Nhanh hơn 40X–610X so với Vivado HLS |
| Systimator | Phân tích cho FPGA giá rẻ (Artix 7), hỗ trợ Feature Map reuse & Filter reuse | Tìm cấu hình mảng phù hợp giới hạn bộ nhớ |

---

## tinh_linh_hoat_mo_rong

| Kiến trúc | Đặc điểm | Ứng dụng |
|---|---|---|
| Systolic-CNN | OpenCL, 1-D Systolic Array, tái cấu hình run-time, chia sẻ thời gian | AlexNet, ResNet, YOLO (không cần biên dịch lại kernel) |
| Transformer Accelerator | Thực hiện đồng thời nhân/cộng ma trận, chuyển vị, ReLU | Xử lý khối MHA (Multi-Head Attention) và FFN |

---

## hieu_suat_he_thong

| Chỉ số | Mô tả | Kết quả |
|---|---|---|
| TPU_latency_priority | Ưu tiên độ trễ hơn thông lượng trung bình | Đáp ứng yêu cầu người dùng cuối |
| int8_vs_float | Dùng số nguyên 8-bit thay vì dấu phẩy động | Tiết kiệm năng lượng 6 lần, diện tích 6 lần |
| memory_bound | Hiệu năng CNN thường giới hạn bởi băng thông bộ nhớ ngoài | Hơn là khả năng tính toán của mảng |

---

## ket_luan

Sự kết hợp giữa kiến trúc PE sáng tạo, phương pháp đặt chỗ vật lý thông minh và công cụ ước lượng nhanh đang biến Systolic Array thành giải pháp tiêu chuẩn để triển khai AI trên cả thiết bị biên (Edge) hạn chế tài nguyên lẫn trung tâm dữ liệu quy mô lớn.

**Tài liệu tham khảo:**
- Frequency Improvement of Systolic Array-Based CNNs on FPGAs
- High-Frequency Systolic Array-Based Transformer Accelerator
- Systolic_CNN: An OpenCL-defined Scalable Run-time-flexible Architecture
