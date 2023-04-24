CREATE DATABASE Nhan_Mac;
USE Nhan_Mac;
SET SQL_SAFE_UPDATES = 0;
CREATE TABLE Class 
(
	ClassID INT PRIMARY KEY AUTO_INCREMENT,
    ClassName VARCHAR(255) NOT NULL,
    StartDate DATETIME NOT NULL,
    `Status` BIT
);

CREATE TABLE Student
(
	StudentID INT PRIMARY KEY AUTO_INCREMENT,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    `Status` BIT,
    ClassID INT NOT NULL
);

CREATE TABLE `Subject`
(
	SubID INT PRIMARY KEY AUTO_INCREMENT,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT(1) CHECK(Credit >= 1),
    `Status` BIT DEFAULT(1)
);

CREATE TABLE Mark
(
	MarkID INT PRIMARY KEY AUTO_INCREMENT,
    SubID INT NOT NULL,
    StudentID INT NOT NULL,
    Mark FLOAT DEFAULT(0) CHECK(Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT(1)
);

-- 3
-- a. Thêm ràng buộc khóa ngoại trên cột ClassID của  bảng Student, tham chiếu đến cột ClassID trên bảng Class.
ALTER TABLE Student
ADD FOREIGN KEY(ClassID) REFERENCES Class(ClassID);

-- b. Thêm ràng buộc cho cột StartDate của  bảng Class là ngày hiện hành.
ALTER TABLE Class
MODIFY StartDate DATETIME DEFAULT(current_date());

-- c. Thêm ràng buộc mặc định cho cột Status của bảng Student là 1.
ALTER TABLE Student
MODIFY `Status` BIT DEFAULT(1);

-- d. Thêm ràng buộc khóa ngoại cho bảng Mark trên cột:
-- SubID trên bảng Mark tham chiếu đến cột SubID trên bảng Subject
-- StudentID tren bảng Mark tham chiếu đến cột StudentID của bảng Student.

ALTER TABLE Mark
ADD FOREIGN KEY (SubID) REFERENCES `Subject`(SubID),
ADD FOREIGN KEY (StudentID) REFERENCES Student(StudentID);

-- 4. Thêm dữ liệu vào các bảng.

INSERT INTO Class (ClassName, StartDate, `Status`) VALUES
("A1", "2008-12-20", 1),
("A2", "2008-12-22", 1),
("B3", current_date(), 1);

INSERT INTO Student (StudentName, Address, Phone, `Status`, ClassID) VALUES
("Hung", "HN", "0912113113", 1, 1),
("Hoa", "HaiPhong", null, 1, 1),
("Manh", "HCM", "0912113113", 0, 2);

INSERT INTO `Subject` (SubName, Credit, `Status`) VALUES
("CF", 5, 1),
("C", 6, 1),
("HDJ", 5, 1),
("RDBMS", 10, 1);

INSERT INTO Mark(SubID, StudentID, Mark, ExamTimes) VALUES
(1,1,8,1),
(1,2,10,2),
(2,1,12,1);

-- 5. Cập nhật dữ liệu.
-- a. Thay đổi mã lớp(ClassID) của sinh viên có tên ‘Hung’ là 2.
UPDATE Student
SET ClassID = 2 WHERE StudentName like "Hung";

-- b. Cập nhật cột phone trên bảng sinh viên là ‘No phone’ cho những sinh viên chưa có số điện thoại.
UPDATE Student
SET Phone = "No Phone" WHERE Phone = null;

-- c. Nếu trạng thái của lớp (Stutas) là 0 thì thêm từ ‘New’ vào trước tên lớp.
UPDATE Class
SET ClassName = CONCAT("New ", ClassName) WHERE `Status` = 0;

-- d. Nếu trạng thái của status trên bảng Class là 1 và tên lớp bắt đầu là ‘New’ thì thay thế ‘New’ bằng ‘old’.
UPDATE Class 
SET ClassName = REPLACE(ClassName, "New", "Old") WHERE `Status` = 1 AND ClassName like "New%";

-- e. Nếu lớp học chưa có sinh viên thì thay thế trạng thái là 0 (status=0).
UPDATE Class 
SET `Status` = 0 WHERE ClassName NOT IN (
	SELECT ClassName FROM (
		SELECT s.StudentName, c.ClassName FROM Student s 
		JOIN Class c ON s.ClassID = c.ClassID
	) AS a
);

SELECT * FROM Class;

-- 6. Hiện thị thông tin.
--  Hiển thị tất cả các sinh viên có tên bắt đầu bảng ký tự ‘h’.
SELECT StudentName FROM Student WHERE StudentName LIKE "h%";

-- a.	Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12.
SELECT * FROM Class WHERE MONTH(StartDate) = 12;

-- b. Hiển thị giá trị lớn nhất của credit trong bảng subject.
SELECT MAX(credit) FROM `Subject`;

-- c. Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
SELECT * FROM `Subject` WHERE Credit = (
	SELECT MAX(credit) FROM `Subject`
);

-- d. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3-5.
SELECT * FROM `Subject` WHERE Credit BETWEEN 3 AND 5;

-- e. Hiển thị các thông tin bao gồm: classid, className, studentname, Address từ hai bảng Class, student
SELECT c.ClassID, c.ClassName, s.StudentName, s.Address FROM Class c
JOIN Student s ON s.ClassID = c.ClassID;

-- f. Hiển thị các thông tin môn học chưa có sinh viên dự thi.
SELECT * FROM `Subject` WHERE SubName NOT IN (
	SELECT SubName FROM (
		SELECT sub.SubName, m.Mark FROM Mark m
		JOIN `Subject` sub ON sub.SubID = m.StudentID
	) AS sub
);

-- g. Hiển thị các thông tin môn học có điểm thi lớn nhất.
SELECT sub.SubName, Mark FROM Mark m 
JOIN `Subject` sub ON m.subID = sub.subID
WHERE Mark = ( 
	SELECT MAX(Mark) FROM Mark
);

-- h. Hiển thị các thông tin sinh viên và điểm trung bình tương ứng.
SELECT s.StudentName, AVG(Mark) FROM Mark m
JOIN Student s ON s.StudentID = m.StudentID
GROUP BY s.StudentName;

-- i. Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần (gợi ý: sử dụng hàm rank)
SELECT s.StudentName, AVG(Mark), RANK() OVER(ORDER BY AVG(Mark)) AS `Rank` FROM Mark m
JOIN Student s ON s.StudentID = m.StudentID
GROUP BY s.StudentName;

-- j.	Hiển thị các thông tin sinh viên và điểm trung bình, chỉ đưa ra các sinh viên có điểm trung bình lớn hơn 10.
SELECT s.StudentName, AVG(Mark) FROM Mark m
JOIN Student s ON s.StudentID = m.StudentID
GROUP BY s.StudentName 
HAVING AVG(Mark) > 10;

-- k.	Hiển thị các thông tin: StudentName, SubName, Mark. Dữ liệu sắp xếp theo điểm thi (mark) giảm dần. nếu trùng sắp theo tên tăng dần.
SELECT s.StudentName, sub.SubName, m.Mark FROM Mark m
JOIN Student s ON s.StudentID = m.StudentID
JOIN `Subject` sub ON sub.SubID = m.SubID
ORDER BY m.Mark DESC, s.StudentName;

-- 7. Xóa dữ liệu.
-- Xóa tất cả các lớp có trạng thái là 0.
DELETE FROM Class WHERE `Status` = 0;

-- a.	Xóa tất cả các môn học chưa có sinh viên dự thi.
DELETE FROM `Subject` WHERE SubName NOT IN (
	SELECT SubName FROM (
		SELECT sub.SubName, m.Mark FROM Mark m
		JOIN `Subject` sub ON sub.SubID = m.StudentID
	) AS sub
);

-- 8.	Thay đổi.
-- Xóa bỏ cột ExamTimes trên bảng Mark.
ALTER TABLE Mark
DROP COLUMN ExamTimes;

-- a.	Sửa đổi cột status trên bảng class thành tên ClassStatus.
ALTER TABLE Class
RENAME COLUMN `status` TO ClassStatus;

-- b.	Đổi tên bảng Mark thành SubjectTest.
ALTER TABLE Mark
RENAME SubjectTest;

