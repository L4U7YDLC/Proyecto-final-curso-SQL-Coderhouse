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
    commission DECIMAL(3, 2) CHECK (commission>=0 AND comission<=5),
    monthlySales DECIMAL(12, 2) CHECK (monthlySales>=0)
);

CREATE TABLE ORDERS (
    traceability INT AUTO_INCREMENT PRIMARY KEY,
    clientNumber INT,
    salesman INT,
    facturationDate DATE,
    discount INT,
    totalPrice DECIMAL(12, 2),
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
    salePrice DECIMAL(10, 2),
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
