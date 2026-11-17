# LAB 2 – Mã hóa đối xứng hiện đại

| | |
|---|---|
| Họ và tên | Hà Chí Hân |
| MSSV | 1150080014 |
| Lớp | 11_ĐH_CNPM1 |
| Học phần | An toàn và bảo mật hệ thống thông tin |
| Kênh YouTube | https://www.youtube.com/@chihan0403 |

## Nội dung đã làm

Chương trình mã hóa / giải mã bằng các thuật toán đối xứng hiện đại, giao diện Java Swing (NetBeans GUI Builder),
lưu tài khoản và lịch sử thao tác vào Microsoft SQL Server, cộng thêm một bài AES-CBC viết bằng Python (Tkinter).

| Bài | Form / tệp | Thuật toán – điểm chính |
|---|---|---|
| 2.1 | `frm_DES` + `DESCipher` | DES/CBC/PKCS5, khóa đúng 8 byte, IV ngẫu nhiên 8 byte ghép đầu bản mã (Base64) |
| 2.2 | `frm_TripleDES` + `TripleDESCipher` | DESede/CBC/PKCS5, khóa đúng 24 byte (K1‖K2‖K3) |
| 2.3 | `frm_AES` + `AESCipher`, `UserDao` | AES-256-GCM, khóa = PBKDF2-HMAC-SHA256(mật khẩu, salt, 120 000 vòng); Register/Login lưu salt + hash PBKDF2 vào `dbo.app_users`, cấp Ticket 128 bit |
| 2.4 | `frm_RC4` + `RC4Cipher` | RC4 tự cài đặt (KSA + PRGA), bản mã HEX |
| 2.5 | `frm_Twofish` + `TwofishCipher` | Twofish/CBC/PKCS7 (BouncyCastle), khóa = SHA-256(Key), IV 16 byte HEX, tệp lưu `IV=...` + bản mã |
| 2.6 (01) | `frm_AES_CTR` + `AESCTRCipher` | AES-256-CTR, khóa 32 byte + nonce 12 byte ngẫu nhiên, không đệm, tệp lưu `NONCE=...` + bản mã |
| 2.6 (02) | `LAB2_Python/aes_cbc_gui.py` | AES-256-CBC + PKCS7 bằng thư viện `cryptography`, giao diện Tkinter, có `--self-test` |
| Chung | `frm_Menu`, `frm_KetNoiSQL`, `frm_LichSu` | Menu chính; kết nối SQL Server (mật khẩu chỉ giữ trong bộ nhớ); xem 50 dòng mới nhất của `dbo.crypto_history` |

## Cấu trúc thư mục

```
LAB2/
├── README.md
├── images/                      # ảnh minh chứng kết quả
├── LAB2_MaHoaHienDai/           # project Maven (NetBeans)
│   ├── pom.xml                  # JDK 17, mssql-jdbc 12.8.1, bcprov-jdk18on 1.78.1
│   ├── sql/                     # 01_Tao_CSDL.sql, 02_Tao_Tai_Khoan_SQL.sql, 03_Kiem_Tra_Du_Lieu.sql
│   └── src/main/java/week_02/   # lớp xử lý + 9 JFrame Form (.java + .form)
└── LAB2_Python/
    └── aes_cbc_gui.py
```

## Hướng dẫn chạy

**Yêu cầu:** JDK 17+, Apache NetBeans 20+ (hoặc Maven 3.9), SQL Server Express + SSMS, Python 3.10+.

1. **SQL Server** (SQLEXPRESS): bật TCP/IP, IPAll → TCP Port `14333`, bật *SQL Server and Windows Authentication mode*, restart dịch vụ.
2. Trong SSMS chạy `sql/01_Tao_CSDL.sql`; mở `sql/02_Tao_Tai_Khoan_SQL.sql`, thay `<DAT_MAT_KHAU_SQL_CUA_BAN>` bằng mật khẩu bạn chọn rồi chạy.
3. **Java:** NetBeans → File → Open Project → chọn `LAB2_MaHoaHienDai` → Clean and Build (Shift+F11) → Run (F6), cửa sổ chính là `frm_Menu`.
   Dòng lệnh: `mvn compile exec:java` (trong thư mục `LAB2_MaHoaHienDai`).
4. Trong menu bấm **Kết nối SQL Server**: Server `127.0.0.1`, Port `14333`, Database `LAB2_MaHoaHienDai`, User `lab2_user`, nhập mật khẩu đã đặt → Test Connection. Sau đó mỗi thao tác Encrypt/Decrypt/Register/Login được ghi vào `dbo.crypto_history`.
5. **Python:**
   ```
   py -m pip install cryptography
   cd LAB2_Python
   py aes_cbc_gui.py --self-test
   py aes_cbc_gui.py
   ```

## Kết quả kiểm thử (Bảng 2.1)

| Bài | Dữ liệu thử | Kết quả |
|---|---|---|
| 2.1 DES | "Xin chào Lab 2 - Mã hóa hiện đại!", Key `12345678` | Giải mã đúng; 2 lần Encrypt cho 2 bản mã khác nhau; Key `1234` báo lỗi 8 byte; Key sai báo lỗi padding |
| 2.2 TripleDES | Key `123456789012345678901234` | Giải mã đúng; Key 23 ký tự báo "Khóa DESede phải đúng 24 byte" |
| 2.3 AES-GCM | Key AES `MatKhauAES@2026` | Giải mã đúng; sửa 1 ký tự bản mã hoặc sai khóa → `AEADBadTagException` |
| 2.4 RC4 | Plaintext `Plaintext`, Key `Key` | `BBF316E8D940AF0AD3` (khớp vector chuẩn) |
| 2.5 Twofish | Key `Twofish@Lab2`, IV sinh ngẫu nhiên | Giải mã đúng; đổi IV → sai; Save/Open khôi phục được IV |
| 2.6 AES-CTR | Key + nonce ngẫu nhiên, văn bản > 1000 ký tự | Giải mã đúng; độ dài bản mã = độ dài bản rõ |
| 2.6 AES-CBC Python | 4 thông điệp (có văn bản dài) | `SELF-TEST OK: 4 thông điệp mã hóa/giải mã đúng, sai khóa bị phát hiện.` |

Ảnh minh chứng nằm trong thư mục `images/`.

## Lưu ý bảo mật

- Không lưu mật khẩu trong mã nguồn hay tệp: mật khẩu SQL Server chỉ nằm trong bộ nhớ khi chương trình chạy; script `02` trên GitHub để chỗ trống `<DAT_MAT_KHAU_SQL_CUA_BAN>`.
- Bảng `app_users` chỉ lưu salt + PBKDF2 hash, không lưu mật khẩu gốc; `crypto_history` chỉ lưu độ dài dữ liệu, không lưu bản rõ hay khóa.
- Tệp bản mã chỉ chứa IV/nonce + bản mã, không bao giờ chứa Key.
- DES, 3DES và RC4 đã lỗi thời (khóa ngắn / điểm yếu thống kê) – chỉ dùng để học; ứng dụng thật nên dùng AES-GCM.
