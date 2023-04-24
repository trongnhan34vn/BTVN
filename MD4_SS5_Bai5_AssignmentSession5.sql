CREATE DATABASE TicketFilm;
USE TicketFilm;

CREATE TABLE tblPhim
(
	PhimID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_Phim VARCHAR(30),
    Loai_Phim VARCHAR(25),
    Thoi_gian INT
);

INSERT INTO tblPhim (Ten_Phim, Loai_Phim, Thoi_gian) VALUES
("Em bé Hà Nội", "Tâm Lý", 90),
("Nhiệm vụ bất khả thi", "Hành động", 100),
("Dị nhân", "Viễn tưởng", 90),
("Cuốn theo chiều gió", "Tình cảm", 120);

CREATE TABLE tblPhong
(
	PhongID INT PRIMARY KEY AUTO_INCREMENT,
    Ten_Phong VARCHAR(20),
	Trang_thai TINYINT
);

INSERT INTO tblPhong (Ten_Phong, Trang_thai) VALUES
("Phòng chiếu 1", 1),
("Phòng chiếu 2", 1),
("Phòng chiếu 3", 0);

CREATE TABLE tblGhe 
(
	GheID INT PRIMARY KEY AUTO_INCREMENT,
    PhongID INT,
    FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID),
    So_ghe VARCHAR(10)
);

INSERT INTO tblGhe (PhongID, So_ghe) VALUES
(1, "A3"),
(1, "B5"),
(2, "A7"),
(2, "D1"),
(3, "T2");

CREATE TABLE tblVe 
(
	PhongID INT,
	FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID),
    GheID INT,
    FOREIGN KEY (GheID) REFERENCES tblGhe(GheID),
    Ngay_chieu DATETIME,
    Trang_thai VARCHAR(20)
);

INSERT INTO tblVe VALUES 
(1, 1, "2008-10-20", "Đã bán"),
(1, 3, "2008-11-20", "Đã bán"),
(1, 4, "2008-12-23", "Đã bán"),
(2, 1, "2009-02-14", "Đã bán"),
(3, 1, "2009-02-14", "Đã bán"),
(2, 5, "2009-08-03", "Đã bán"),
(2, 3, "2009-08-03", "Đã bán");

-- 2.	Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)				
SELECT * FROM tblPhim ORDER BY Thoi_gian;

-- 3.	Hiển thị Ten_phim có thời gian chiếu dài nhất
SELECT Ten_Phim, Thoi_gian FROM tblPhim WHERE Thoi_gian = (SELECT MAX(Thoi_gian) FROM tblPhim);

-- 4.	Hiển thị Ten_Phim có thời gian chiếu ngắn nhất
SELECT Ten_Phim, Thoi_gian FROM tblPhim WHERE Thoi_gian = (SELECT MIN(Thoi_gian) FROM tblPhim);

-- 5.	Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’
SELECT So_Ghe FROM tblGhe WHERE So_Ghe LIKE "A%";

-- 6.	Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)			
ALTER TABLE tblPhong
MODIFY Trang_thai VARCHAR(25);

-- 7.	Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:			
-- Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’
-- Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’
-- Nếu Trang_thai=null thì gán Trang_thai=’Unknow’
-- Sau đó hiển thị bảng tblPhong 

UPDATE tblPhong
SET Trang_thai = CASE 
	WHEN Trang_thai = 0 THEN "Đang sửa"
    WHEN Trang_thai = 1 THEN "Đang sử dụng"
    WHEN Trang_thai = null THEN "Unknow"
END;

SELECT * FROM tblPhong;

-- 8.	Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự 	
SELECT Ten_Phim FROM tblPhim WHERE LENGTH(Ten_Phim) > 15 AND LENGTH(Ten_Phim) < 25;

-- 9.	Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’
SELECT concat(Ten_Phong," ", Trang_thai) AS "Trạng thái phòng chiếu" FROM tblPhong;

-- 10.	Tạo bảng mới có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian
CREATE TABLE tblRank
(
	STT INT,
    Ten_Phim VARCHAR(30),
    Thoi_gian INT
);

-- 11.	Trong bảng tblPhim :
-- a.	Thêm trường Mo_ta kiểu nvarchar(max)						
-- b.	Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại  ” + nội dung trường LoaiPhim										
-- c.	Hiển thị bảng tblPhim sau khi cập nhật				
-- d.	Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film”
-- e.	Hiển thị bảng tblPhim sau khi cập nhật	

-- a
ALTER TABLE tblPhim 
ADD COLUMN Mo_ta VARCHAR(255);

-- b
UPDATE tblPhim
SET Mo_ta = CONCAT("Đây là bộ phim thể loại ", Loai_Phim);

-- c
SELECT * FROM tblPhim;

-- d

UPDATE tblPhim 
SET Mo_ta = REPLACE (Mo_ta, "bộ phim", "film");

-- e
SELECT * FROM tblPhim;

-- 14.	Hiển thị ngày giờ hiện tại và ngày giờ hiện tại cộng thêm 5000 phút
SELECT current_time() as CurrentTime, date_add(current_time(), interval 5 minute) as "Hiện tại thêm 5p"; 
