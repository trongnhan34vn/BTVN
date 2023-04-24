USE QLBH_NHAN;

-- 8.	Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị 
CREATE VIEW Sales AS
SELECT SUM(Total) AS Sales FROM (
	SELECT o.oID, o.oDate, SUM(od.odQTY * pPrice) AS Total 
	FROM `Order` o
	JOIN OrderDetail od ON od.oID = o.oID
	JOIN Product p ON p.pID = od.pID
	GROUP BY o.oID 
) AS Total;

-- 10.	Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo
-- 11. Tạo stored procedure delProduct nhận vào 1 tham số là tên của một sản phẩm, strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail:	
DELIMITER //
CREATE PROCEDURE delProduct (
	pNameDel VARCHAR(25)
)
BEGIN 
	DELETE FROM Product
    WHERE pName like "Quat";
	DELETE FROM OrderDetail 
    WHERE "Quat" IN (
		SELECT pName FROM (
			SELECT p.pID, p.pName FROM Product p JOIN OrderDetail od ON od.pID = p.pID
		) AS PNAME
	);
END //
DELIMITER ;

CALL delProduct("Quat");




