# Python Version Checker

## Giới thiệu

Dự án mô phỏng quy trình phát triển một tiện ích userspace cho hệ thống Linux nhúng, cụ thể là theo hướng làm việc với OpenWRT trên Raspberry Pi 4B. Code viết bằng C, build và test trong Docker, dùng Git để quản lý version và Makefile để tự động hóa các bước build/run/clean/package.

Mục tiêu chính là làm quen với quy trình phát triển trong môi trường cô lập, cách tổ chức project, quản lý branch/tag trên Git, và đóng gói ứng dụng dạng `.ipk` để mô phỏng deploy lên OpenWRT.

## Mô tả bài toán

`check_python.c` kiểm tra xem `python3.9` có được cài đặt trên hệ thống không.

- Nếu có: chạy `python3.9 --version`, in phiên bản ra terminal và ghi vào `/tmp/python_ver.log`
- Nếu không có: in `Error: Python 3.9 not found` và thoát với exit code khác 0

Dự án không cần deploy thực tế lên phần cứng, nhưng mô phỏng đúng flow phát triển ứng dụng userspace cho embedded Linux.

## Chức năng chính

1. Kiểm tra sự tồn tại của `python3.9` qua `which python3.9` hoặc kiểm tra return code của lệnh hệ thống
2. Nếu tìm thấy: chạy `python3.9 --version`, in kết quả dạng `Detected Python Version: 3.9.x`, ghi vào `/tmp/python_ver.log`
3. Nếu không tìm thấy: in `Error: Python 3.9 not found`, thoát với mã lỗi khác 0

## Cấu trúc thư mục

```text
python-check-project/
├── src/
│   └── check_python.c
├── Makefile
├── Dockerfile
├── README.md
└── package/
    └── python-check/
        └── usr/
            └── bin/
```

- `src/` — chứa mã nguồn C
- `Makefile` — tự động hóa build, run, clean, package
- `Dockerfile` — tạo môi trường build cô lập
- `package/` — mô phỏng cấu trúc package OpenWRT để tạo file `.ipk`

## Yêu cầu kỹ thuật

**Docker:** Build từ image tối giản, Dockerfile phải cài `gcc`, `make` và các dependency cần thiết. Toàn bộ quá trình build/run/package chạy trong container.

**Code C:** Dùng `system()` hoặc `popen()` để gọi lệnh kiểm tra Python. Output phải in ra màn hình và ghi vào `/tmp/python_ver.log`. Nếu không tìm thấy Python 3.9 thì báo lỗi rõ và exit với trạng thái thất bại.

**Git:** Tạo branch `feature/python-version-check`, commit đủ source/Dockerfile/Makefile, gắn tag `v1.0-python-check`.

**Makefile:** Phải có đủ 4 target: `make`, `make run`, `make clean`, `make package`.

## Dockerfile

```dockerfile
FROM ubuntu:20.04

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    make \
    python3.9 \
    git

WORKDIR /app

COPY . .

RUN make

RUN make package

CMD ["make", "run"]
```

- Base image `ubuntu:20.04` — môi trường ổn định, gần với embedded Linux
- `DEBIAN_FRONTEND=noninteractive` — tắt prompt trong quá trình `apt install` để build không bị treo
- `gcc-aarch64-linux-gnu` — cross-compiler để build binary cho kiến trúc ARM64 (Raspberry Pi 4B)
- `python3.9` — cài sẵn trong container để chương trình có thể detect được
- `RUN make` và `RUN make package` — build và đóng gói ngay lúc tạo image
- `CMD ["make", "run"]` — chạy chương trình mặc định khi container khởi động

## Hướng dẫn Docker

Build image:

```bash
docker build -t python-check .
```

Chạy container:

```bash
docker run -it python-check
```

Trong container, dùng các lệnh Makefile để build và test chương trình.

## Hướng dẫn Makefile

```bash
make          # biên dịch chương trình
make run      # chạy chương trình
make clean    # xóa file build
make package  # tạo file python-check.ipk
```

## Đóng gói `.ipk` (mô phỏng OpenWRT)

Sau khi build xong, binary được đặt vào `package/python-check/usr/bin/`. Toàn bộ thư mục sau đó được nén thành `python-check.ipk`.

Phần này giúp hiểu cách OpenWRT tổ chức package và quy trình đóng gói ứng dụng userspace để deploy lên thiết bị nhúng.

## Quy trình Git

```bash
# Tạo branch
git checkout -b feature/python-version-check

# Commit
git add .
git commit -m "Add Python version check app with Docker and Makefile"

# Push
git push origin feature/python-version-check

# Gắn tag release
git tag v1.0-python-check
git push origin v1.0-python-check
```

## Kết quả mong đợi

Chạy thành công:

```
Detected Python Version: 3.9.x
```

Kết quả đồng thời được ghi vào `/tmp/python_ver.log`.

Không tìm thấy Python 3.9:

```
Error: Python 3.9 not found
```

Thoát với exit code khác 0.

## Mục tiêu học tập

- Dùng Docker để tạo môi trường build sạch, tách biệt với máy host
- Quản lý mã nguồn bằng Git theo branch và tag
- Viết Makefile để tự động hóa build/run/package
- Hiểu cách đóng gói ứng dụng theo chuẩn OpenWRT

## Kết luận

Dự án bao quát các bước cốt lõi của một chu trình phát triển embedded Linux: biên dịch, kiểm thử, quản lý version và đóng gói. Có thể mở rộng thêm sang cross-compiling, build `.ipk` thực tế và deploy lên thiết bị OpenWRT thật.
