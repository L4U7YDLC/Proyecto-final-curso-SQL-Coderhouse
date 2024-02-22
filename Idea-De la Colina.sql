CREATE DATABASE IF NOT EXISTS businessInfo;
USE businessInfo;

CREATE TABLE CLIENTS (
    accountNumber INT AUTO_INCREMENT PRIMARY KEY,
    dni INT CHECK (dni>0),
    name VARCHAR(100),
    address VARCHAR(200),
    phoneNumber VARCHAR(20),
    accountType ENUM('cliente eventual', 'cta Corriente'),
    salesman INT,
    FOREIGN KEY (salesman) REFERENCES SALESMEN(sManNumber)
);

CREATE TABLE SALESMEN (
    sManNumber INT AUTO_INCREMENT PRIMARY KEY,
    password VARCHAR(100),
    name VARCHAR(100),
    salesTarget DECIMAL(11, 2) CHECK (salesTarget>0),
    commission DECIMAL(3, 2) CHECK (comission>=0 AND comission<=5),
    monthlySales DECIMAL(12, 2) CHECK (salesTarget>0)
);

CREATE TABLE ORDERS (
    traceability INT AUTO_INCREMENT PRIMARY KEY,
    clientNumber INT,
    salesman INT,
    facturationDate DATE,
    discount INT,
    totalPrice DECIMAL(12, 2) AS (CalculateTotalPrice(traceability)), 
    FOREIGN KEY (clientNumber) REFERENCES CLIENTS(accountNumber),
    FOREIGN KEY (salesman) REFERENCES SALESMEN(sManNumber)
);

CREATE TABLE ARTICLES (
    SKU INT AUTO_INCREMENT PRIMARY KEY,
    articleDescription VARCHAR(200),
    supplier VARCHAR(100),
    repositionCost DECIMAL(10, 2),
    stock INT CHECK (stock>=0),
    profit DECIMAL(4, 2) CHECK (profit>=0),
    repositionDelay INT CHECK (repositionDelay>=0)
);

CREATE TABLE PURCHASE_ORDERS (
    orderNumber INT AUTO_INCREMENT PRIMARY KEY,
    supplier VARCHAR(100),
    dateOfArrival DATE
);

CREATE TABLE ARTICLES_ORDER (
    orderNumber INT,
    SKU INT,
    quantity INT,
    salePrice DECIMAL(10, 2) AS (CalculateSalePrice(SKU, quantity)),
    dateOfDelivery DATE,
    PRIMARY KEY (orderNumber, SKU),
    FOREIGN KEY (orderNumber) REFERENCES ORDERS(traceability),
    FOREIGN KEY (SKU) REFERENCES ARTICLES(SKU)
);

CREATE TABLE ARTICLES_PURCHASE_ORDER (
    orderNumber INT,
    SKU INT,
    quantity INT CHECK (quantity>0),
    PRIMARY KEY (orderNumber, SKU),
    FOREIGN KEY (orderNumber) REFERENCES PURCHASE_ORDERS(orderNumber),
    FOREIGN KEY (SKU) REFERENCES ARTICLES(SKU)
);

CREATE VIEW SalesSummaryBySalesman AS
SELECT
    salesman,
    YEAR(facturationDate) AS salesYear,
    MONTH(facturationDate) AS salesMonth,
    COUNT(*) AS totalOrders,
    SUM(totalPrice) AS totalSalesAmount
FROM ORDERS
GROUP BY salesman, salesYear, salesMonth;

CREATE VIEW TopCustomers AS
SELECT
    c.accountNumber,
    c.name AS clientName,
    COUNT(*) AS totalOrders
FROM CLIENTS c
JOIN ORDERS o ON c.accountNumber = o.clientNumber
GROUP BY c.accountNumber, c.clientName
ORDER BY totalOrders DESC;

CREATE VIEW ArticleStock AS
SELECT
    SKU,
    articleDescription,
    stock
FROM ARTICLES;

CREATE VIEW PurchaseOrderTracking AS
SELECT
    orderNumber,
    supplier,
    dateOfArrival,
    DATEDIFF(dateOfArrival, CURDATE()) AS daysUntilArrival
FROM
    PURCHASE_ORDERS;

DELIMITER //
CREATE PROCEDURE AddNewClient(
    IN dniParam INT,
    IN nameParam VARCHAR(100),
    IN addressParam VARCHAR(200),
    IN phoneNumberParam VARCHAR(20),
    IN accountTypeParam ENUM('cliente eventual', 'cta Corriente'),
    IN salesmanParam VARCHAR(100)
)
BEGIN
    INSERT INTO CLIENTS (dni, name, address, phoneNumber, accountType, salesman)
    VALUES (dniParam, nameParam, addressParam, phoneNumberParam, accountTypeParam, salesmanParam);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE newOrder(
    IN clientNumberParam INT,
    IN facturationDateParam DATE,
    IN discountParam DECIMAL(5, 2),
    IN articleDataParam TABLE(SKU INT, quantity INT)
)
BEGIN
    DECLARE orderId INT;
    INSERT INTO ORDERS (clientNumber, facturationDate, discount)
    VALUES (clientNumberParam, facturationDateParam, discountParam);
    SET orderId = LAST_INSERT_ID();
    INSERT INTO ARTICLES_ORDER (orderNumber, SKU, quantity, dateOfDelivery)
    SELECT orderId, articleData.SKU, articleData.quantity, facturationDateParam
    FROM articleDataParam AS articleData;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GeneratePurchaseOrder(
    IN supplierParam VARCHAR(100),
    IN dateOfArrivalParam DATE
)
BEGIN
    INSERT INTO PURCHASE_ORDERS (supplier, dateOfArrival)
    VALUES (supplierParam, dateOfArrivalParam);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddNewArticle(
    IN articleDescriptionParam VARCHAR(200),
    IN supplierParam VARCHAR(100),
    IN repositionCostParam DECIMAL(10, 2),
    IN stockParam INT,
    IN repositionDelayParam INT
)
BEGIN
    INSERT INTO ARTICLES (articleDescription, supplier, repositionCost, stock, repositionDelay)
    VALUES (articleDescriptionParam, supplierParam, repositionCostParam, stockParam, repositionDelayParam);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE AddNewSalesman(
    IN passwordParam VARCHAR(100),
    IN nameParam VARCHAR(100),
    IN salesTargetParam DECIMAL(11, 2),
    IN commissionParam DECIMAL(3, 2),
    IN monthlySalesParam DECIMAL(12, 2)
)
BEGIN
    INSERT INTO SALESMEN (password, name, salesTarget, commission, monthlySales)
    VALUES (passwordParam, nameParam, salesTargetParam, commissionParam, monthlySalesParam);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateSalesmanCommission(
    IN userNumberParam INT,
    IN newCommissionParam DECIMAL(3, 2)
)
BEGIN
    UPDATE SALESMEN
    SET commission = newCommissionParam
    WHERE sManNumber = userNumberParam;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateSalesmanSalesTarget(
    IN userNameParam VARCHAR(50),
    IN newSalesTargetParam DECIMAL(11, 2)
)
BEGIN
    UPDATE SALESMEN
    SET salesTarget = newSalesTargetParam
    WHERE userName = userNameParam;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION GetArticleStock(
    skuParam INT
)
RETURNS INT
BEGIN
    DECLARE stock INT;
    SELECT stock INTO stock
    FROM ARTICLES
    WHERE SKU = skuParam;
    RETURN stock;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CalculateTotalPrice(
    orderIdParam INT
)
RETURNS DECIMAL(12, 2)
BEGIN
    DECLARE total DECIMAL(12, 2);
    SELECT SUM(ao.salePrice) * (o.discount / 100)
    INTO total
    FROM ARTICLES_ORDER ao
    JOIN ORDERS o ON ao.orderNumber = o.traceability
    WHERE ao.orderNumber = orderIdParam;
    RETURN total;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CalculateSalePrice(
    skuParam INT,
    quantityParam INT
)
RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE salePrice DECIMAL(10, 2);
    SELECT repositionCost * (1 + profit / 100) * quantityParam
    INTO salePrice
    FROM ARTICLES
    WHERE SKU = skuParam;
    RETURN salePrice;
END //
DELIMITER ;