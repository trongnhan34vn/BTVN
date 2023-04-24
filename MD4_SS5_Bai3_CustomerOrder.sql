CREATE DATABASE QLBH_NHAN;

USE QLBH_NHAN;

CREATE TABLE Customer
(
	cID INT PRIMARY KEY AUTO_INCREMENT,
    `Name` VARCHAR(25),
    cAge TINYINT
);

INSERT INTO Customer (`Name`, cAge) VALUES
("Minh Quan", 10),
("Ngoc Oanh", 20),
("Hong Ha", 50);

CREATE TABLE `Order`
(
	oID INT PRIMARY KEY AUTO_INCREMENT,
    cID INT, 
    FOREIGN KEY (cID) REFERENCES Customer(cID),
    oDate DATETIME, 
    oTotalPrice INT
);

INSERT INTO `Order` (cID, oDate) VALUES
(1,"2006-03-21"),
(2,"2006-03-23"),
(1,"2006-03-16");

CREATE TABLE Product
(
	pID INT PRIMARY KEY AUTO_INCREMENT,
    pName VARCHAR(25),
    pPrice INT
);

INSERT INTO Product(pName, pPrice) VALUES
("May Giat", 3),
("Tu Lanh", 5),
("Dieu Hoa", 7),
("Quat", 1),
("Bep Dien", 2);

CREATE TABLE OrderDetail
(
	oID INT,
    pID INT,
    odQTY INT,
    FOREIGN KEY (oID) REFERENCES `Order`(oID),
    FOREIGN KEY (pID) REFERENCES Product(pID)
);

INSERT INTO OrderDetail VALUES
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2.	Hiển thị các thông tin  gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order, danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên 
SELECT o.oID, o.oDate, o.oTotalPrice FROM `Order` o ORDER BY o.oDate DESC;

-- 3.	Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:
SELECT p.pName, p.pPrice 
FROM Product p
WHERE p.pPrice in (
	SELECT MAX(p.pPrice) FROM Product p
);

-- 4.	Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:
SELECT c.`Name`, p.pName
FROM Customer c 
JOIN `Order` o ON o.cID = c.cID
JOIN OrderDetail od ON od.oID = o.oID
JOIN Product p ON p.pID = od.pID;

-- 5.	Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào
SELECT c.`Name` FROM Customer c
WHERE c.`Name` NOT IN (
	SELECT c.`Name` FROM (
		SELECT c.`Name`, p.pName
		FROM Customer c 
		JOIN `Order` o ON o.cID = c.cID
		JOIN OrderDetail od ON od.oID = o.oID
		JOIN Product p ON p.pID = od.pID
	) as c
);

-- 6.	Hiển thị chi tiết của từng hóa đơn
SELECT o.oID, o.oDate, od.odQTY, p.pName, p.pPrice FROM `Order` o
JOIN OrderDetail od ON od.oID = o.oID
JOIN Product p ON p.pID = od.pID;

-- 7.	Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice)
SELECT o.oID, o.oDate, SUM(od.odQTY * pPrice) AS Total 
FROM `Order` o
JOIN OrderDetail od ON od.oID = o.oID
JOIN Product p ON p.pID = od.pID
GROUP BY o.oID;


