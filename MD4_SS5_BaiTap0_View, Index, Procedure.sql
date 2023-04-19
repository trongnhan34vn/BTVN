CREATE DATABASE demo;
USE demo;

CREATE TABLE Products
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    productCode VARCHAR(5) NOT NULL,
    productName VARCHAR(50) NOT NULL,
    productPrice FLOAT NOT NULL,
    productAmount INT NOT NULL,
	productDescription TEXT,
    productStatus BIT DEFAULT(1)
);

INSERT INTO Products(productCode, productName, productPrice, productAmount, productDescription) VALUES 
("SP001", "Sản Phẩm 01", 5000, 10, null),
("SP002", "Sản Phẩm 02", 10000, 5, null),
("SP003", "Sản Phẩm 03", 8000, 10, null),
("SP004", "Sản Phẩm 04", 5000, 20, null),
("SP005", "Sản Phẩm 05", 2000, 10, null),
("SP006", "Sản Phẩm 06", 1000, 12, null),
("SP007", "Sản Phẩm 07", 5000, 13, null),
("SP008", "Sản Phẩm 08", 3000, 10, null),
("SP009", "Sản Phẩm 09", 5000, 10, null),
("SP010", "Sản Phẩm 10", 5000, 10, null);

SELECT * FROM Products WHERE productPrice = 5000;

ALTER TABLE Products
ADD INDEX index_productCode(productCode);

EXPLAIN SELECT * FROM Products WHERE productCode = "SP002";

ALTER TABLE Products
ADD INDEX index_productInfo (productName, productPrice);

EXPLAIN SELECT * FROM Products WHERE productName = "Sản Phâm 01";

ALTER TABLE Products
DROP INDEX index_productInfo;

CREATE VIEW ProductsView AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

SELECT * FROM ProductsView;

CREATE OR REPLACE VIEW ProductsView AS
SELECT productCode, productName, productPrice, productStatus
FROM Products
WHERE productPrice = 5000;

DROP VIEW ProductsView;

DELIMITER //
CREATE PROCEDURE getAllProducts()
BEGIN
	SELECT * FROM Products;
END //
DELIMITER ; 

CALL getAllProducts();

DELIMITER // 
CREATE PROCEDURE createProduct(
	IN newProductCode varchar(5),
    IN newProductName varchar(50),
    IN newProductPrice float,
    IN newProductAmount int
)
BEGIN
	INSERT INTO Products (productCode, productName, productPrice, productAmount) VALUES
    (newProductCode, newProductName, newProductPrice, newProductAmount);
END //
DELIMITER ;

CALL createProduct("SP011", "Sản Phẩm 11", 2800, 8);

DELIMITER //
CREATE PROCEDURE updateProductById(
	IN id int,
    IN newProductCode varchar(5),
    IN newProductName varchar(50),
    IN newProductPrice float,
    IN newProductAmount int
)
BEGIN 
	UPDATE Products
    SET productCode = newProductCode, productName = newProductName, productPrice = newProductPrice, productAmount = newProductAmount where id = id;
END //
DELIMITER ;

CALL updateProductById(5, "SP-5", "Sản phẩm 5", 3000, 4);

DELIMITER //
CREATE PROCEDURE deleteById(
	IN id int
)
BEGIN
	DELETE FROM Products WHERE id = id;
END //
DELIMITER ;

CALL deleteById(11);