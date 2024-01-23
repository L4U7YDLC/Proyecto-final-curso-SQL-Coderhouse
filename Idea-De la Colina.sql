CREATE TABLE CLIENTS (
    accountNumber INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) AS 'accNum',
    name VARCHAR(100) AS 'name',
    address VARCHAR(200) AS 'addr',
    phoneNumber VARCHAR(20) AS 'phNum',
    accountType ENUM('cliente eventual', 'cta Corriente') AS 'accTy',
    salesman VARCHAR(100) AS 'sman',
    FOREIGN KEY (salesman) REFERENCES SALESMEN(userName)
);

CREATE TABLE SALESMEN (
    userName VARCHAR(50) PRIMARY KEY AS 'user',
    password VARCHAR(100) AS 'pword',
    name VARCHAR(100) AS 'name',
    salesTarget DECIMAL(10, 2) AS 'starg',
    amountOfClients INT AS 'ammCli',
    commission DECIMAL(5, 2) AS 'commission',
    monthlySales DECIMAL(10, 2) AS 'mthSls'
);

CREATE TABLE ORDERS (
    orderNumber VARCHAR(50) PRIMARY KEY AS 'ordNum',
    clientNumber INT AS 'clNum',
    salesman VARCHAR(100) AS 'sman',
    facturationDate DATE AS 'facDt',
    discount DECIMAL(5, 2) AS 'dis',
    totalPrice DECIMAL(10, 2) AS 'tPr',
    FOREIGN KEY (clientNumber) REFERENCES CLIENTS(accountNumber),
    FOREIGN KEY (salesman) REFERENCES SALESMEN(userName)
);

CREATE TABLE ARTICLES (
    SKU INT AUTO_INCREMENT PRIMARY KEY,
    articleDescription VARCHAR(200) AS 'artDesc',
    supplier VARCHAR(100) AS 'supp',
    repositionCost DECIMAL(10, 2) AS 'repCost',
    repositionDelay INT AS 'repDel'
);

CREATE TABLE PURCHASE_ORDERS (
    orderNumber VARCHAR(50) PRIMARY KEY AS 'ordNum',
    supplier VARCHAR(100) AS 'supp',
    dateOfArrival DATE AS 'doA'
);

CREATE TABLE ARTICLES_ORDER (
    orderNumber VARCHAR(50) AS 'ordNum',
    SKU INT AS 'SKU',
    quantity INT AS 'qty',
    salePrice DECIMAL(10, 2) AS 'sPr',
    dateOfDelivery DATE AS 'doD',
    PRIMARY KEY (orderNumber, SKU),
    FOREIGN KEY (orderNumber) REFERENCES ORDERS(orderNumber),
    FOREIGN KEY (SKU) REFERENCES ARTICLES(SKU)
);

CREATE TABLE ARTICLES_PURCHASE_ORDER (
    orderNumber VARCHAR(50) AS 'ordNum',
    SKU INT AS 'SKU',
    quantity INT AS 'qty',
    PRIMARY KEY (orderNumber, SKU),
    FOREIGN KEY (orderNumber) REFERENCES PURCHASE_ORDERS(orderNumber),
    FOREIGN KEY (SKU) REFERENCES ARTICLES(SKU)
);
