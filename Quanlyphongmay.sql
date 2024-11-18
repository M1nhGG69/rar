-- Câu 1: Tạo các bảng
CREATE TABLE Khuvuc (
    IP CHAR(10) PRIMARY KEY,
    tenKhuvuc VARCHAR(50) NOT NULL,
    tang TINYINT
);

CREATE TABLE Phong (
    MP VARCHAR(10) PRIMARY KEY,
    tenphong VARCHAR(50) NOT NULL,
    somay INT NOT NULL,
    IP CHAR(10),
    FOREIGN KEY (IP) REFERENCES Khuvuc(IP)
);

CREATE TABLE Loai (
    idLoai VARCHAR(5) PRIMARY KEY,
    tenloai VARCHAR(50) NOT NULL
);

CREATE TABLE May (
    idMay VARCHAR(5) PRIMARY KEY,
    tenmay VARCHAR(50) NOT NULL,
    IP CHAR(10),
    ad TINYINT CHECK (ad >= 0 AND ad <= 255),
    idLoai VARCHAR(5),
    MP VARCHAR(10),
    FOREIGN KEY (IP) REFERENCES Khuvuc(IP),
    FOREIGN KEY (idLoai) REFERENCES Loai(idLoai),
    FOREIGN KEY (MP) REFERENCES Phong(MP)
);

CREATE TABLE Phanmem (
    idPM VARCHAR(10) PRIMARY KEY,
    tenPM VARCHAR(50) NOT NULL,
    ngaymua DATE,
    version VARCHAR(10),
    idLoai VARCHAR(5),
    gia INT CHECK (gia >= 0),
    FOREIGN KEY (idLoai) REFERENCES Loai(idLoai)
);

CREATE TABLE Caidat (
    id VARCHAR(10) PRIMARY KEY,
    idMay VARCHAR(5),
    idPM VARCHAR(10),
    ngaycai DATE DEFAULT GETDATE(),
    FOREIGN KEY (idMay) REFERENCES May(idMay),
    FOREIGN KEY (idPM) REFERENCES Phanmem(idPM)
);

-- Câu 2: Thêm dữ liệu vào các bảng
INSERT INTO Khuvuc (IP, tenKhuvuc) VALUES 
('130.120.80', 'Brin RDC'),
('130.120.81', 'Brin tầng 1'),
('130.120.82', 'Brin tầng 2');

INSERT INTO Phong (MP, tenphong, somay, IP) VALUES
('s01', 'Salle 1', 3, '130.120.80'),
('s02', 'Salle 2', 2, '130.120.80'),
('s03', 'Salle 3', 2, '130.120.80'),
('s11', 'Salle 11', 2, '130.120.81'),
('s12', 'Salle 12', 1, '130.120.81'),
('s21', 'Salle 21', 2, '130.120.82');

INSERT INTO Loai (idLoai, tenloai) VALUES
('TX', 'Terminal X-Window'),
('UNIX', 'Systeme Unix'),
('PCNT', 'PC Windows NT');

INSERT INTO May (idMay, tenmay, IP, ad, idLoai, MP) VALUES
('p1', 'Poste 1', '130.120.80', 1, 'TX', 's01'),
('p2', 'Poste 2', '130.120.80', 2, 'UNIX', 's01'),
('p3', 'Poste 3', '130.120.80', 3, 'TX', 's01');

INSERT INTO Phanmem (idPM, tenPM, ngaymua, version, idLoai, gia) VALUES
('log1', 'Oracle 6', '1995-05-13', '6.2', 'UNIX', 3000),
('log2', 'Oracle 8', '1995-09-15', '8i', 'UNIX', 5600);

-- Câu 3: Cập nhật tầng đúng cho bảng Khuvuc
UPDATE Khuvuc SET tang = 0 WHERE IP = '130.120.80';
UPDATE Khuvuc SET tang = 1 WHERE IP = '130.120.81';
UPDATE Khuvuc SET tang = 2 WHERE IP = '130.120.82';

-- Câu 4: Giảm 10% giá các phần mềm loại 'PCNT'
UPDATE Phanmem SET gia = gia * 0.9 WHERE idLoai = 'PCNT';

-- Câu 5: Thêm và cập nhật cột nbLog, nbInstall
ALTER TABLE May ADD nbLog SMALLINT;
ALTER TABLE Phanmem ADD nbInstall SMALLINT;

UPDATE May SET nbLog = 0 WHERE idMay = 'p1';
UPDATE May SET nbLog = 2 WHERE idMay = 'p2';

UPDATE Phanmem SET nbInstall = 2 WHERE idPM = 'log1';
UPDATE Phanmem SET nbInstall = 1 WHERE idPM = 'log2';

-- Câu 6: Tạo bảng PhanmemUNIX
CREATE TABLE PhanmemUNIX (
    idPM VARCHAR(10),
    tenPM VARCHAR(50) NOT NULL,
    ngaymua DATE,
    version VARCHAR(10)
);

-- Câu 7: Thêm khóa chính vào bảng PhanmemUNIX
ALTER TABLE PhanmemUNIX ADD PRIMARY KEY (idPM);

-- Câu 8: Thêm cột giá cho bảng PhanmemUNIX
ALTER TABLE PhanmemUNIX ADD gia INT CHECK (gia > 0);

-- Câu 9: Thay đổi kiểu cho cột version
ALTER TABLE PhanmemUNIX ALTER COLUMN version VARCHAR(15);

-- Câu 10: Thêm ràng buộc duy nhất cho cột tenPM
ALTER TABLE PhanmemUNIX ADD CONSTRAINT UQ_tenPM UNIQUE (tenPM);

-- Câu 11: Thêm dữ liệu vào bảng PhanmemUNIX từ Phanmem
INSERT INTO PhanmemUNIX (idPM, tenPM, ngaymua, version, gia)
SELECT idPM, tenPM, ngaymua, version, gia FROM Phanmem;

-- Câu 12: Xóa cột version khỏi bảng PhanmemUNIX
ALTER TABLE PhanmemUNIX DROP COLUMN version;

-- Câu 13: Xóa các phần mềm có giá lớn hơn 5000
DELETE FROM Phanmem WHERE gia > 5000; -- Không xóa được vì có ràng buộc với bảng Caidat

-- Câu 14: Xóa các phần mềm trong PhanmemUNIX có giá lớn hơn 5000
DELETE FROM PhanmemUNIX WHERE gia > 5000; -- Xóa được vì không có ràng buộc nào

-- Câu 15: Xóa bảng Phanmem
DROP TABLE Phanmem; -- Không xóa được vì có ràng buộc với bảng Caidat

-- Câu 16: Xóa bảng PhanmemUNIX
DROP TABLE PhanmemUNIX; -- Xóa được vì không có ràng buộc

-- Câu 17: Xóa các cột nbLog và nbInstall
ALTER TABLE May DROP COLUMN nbLog;
ALTER TABLE Phanmem DROP COLUMN nbInstall;

-- Kết thúc script
