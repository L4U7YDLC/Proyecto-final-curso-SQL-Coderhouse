
INSERT INTO CLIENTS (dni, name, address, phoneNumber, accountType, salesman) VALUES
(35627891, 'Juan Pérez', 'CalleGenérica1', '3511234567', 'cta Corriente', 2),
(21568432, 'María González', 'CalleGenérica2', '3512345678', 'cta Corriente', 3),
(39857124, 'Luis Rodríguez', 'CalleGenérica3', '3513456789', 'cliente eventual', 4),
(12345678, 'Ana Martínez', 'CalleGenérica4', '3514567890', 'cliente eventual', 1),
(29573186, 'Pedro Sánchez', 'CalleGenérica5', '3515678901', 'cta Corriente', 2);

INSERT INTO SALESMEN (password, name, salesTarget, commission, monthlySales) VALUES
('clave123', 'Carlos López', 25000000.00, 3.00, 700000000.00),
('password123', 'Lucía Fernández', 30000000.00, 2.50, 800000000.00),
('secret123', 'Martín Torres', 35000000.00, 4.00, 900000000.00),
('pass1234', 'Laura Díaz', 40000000.00, 3.25, 600000000.00);

INSERT INTO ORDERS (clientNumber, salesmanNumber, facturationDate, discount) VALUES
(1, 2, '2024-02-15', 10),
(3, 3, '2024-01-05', 20),
(4, 1, '2024-02-10', 0),
(5, 2, '2024-02-20', 15),
(2, 3, '2024-01-10', 0),
(1, 4, '2024-02-05', 30),
(3, 1, '2024-02-01', 0);

INSERT INTO ARTICLES (articleDescription, supplier, repositionCost, stock, profit, repositionDelay) VALUES
('térmica', 'ABB', 12000.00, 500, 28.00, 90),
('disyuntor', 'ABB', 15000.00, 400, 23.00, 90),
('térmica', 'Steck', 10000.00, 600, 27.00, 75),
('disyuntor', 'Steck', 17000.00, 450, 25.00, 75),
('cable', 'Erpla', 8000.00, 150000, 40.00, 60),
('gabinete', 'Gen-Rod', 300000.00, 50, 32.00, 30),
('caño', 'Gen-Rod', 800.00, 7000, 38.00, 30);

INSERT INTO PURCHASE_ORDERS (supplier, dateOfArrival) VALUES
('ABB', '2024-05-15'),
('Erpla', '2024-03-05'),
('Steck', '2024-04-20'),
('Gen-Rod', '2024-06-01'),
('Steck', '2024-06-10'),
('Gen-Rod', '2024-06-15');

INSERT INTO ARTICLES_ORDER (orderNumber, SKU, quantity, dateOfDelivery) VALUES
(1, 1, 50, '2024-03-01'),
(1, 2, 60, '2024-03-01'),
(2, 3, 30, '2024-02-25'),
(2, 4, 40, '2024-02-25'),
(2, 5, 150, '2024-02-25'),
(3, 6, 20, '2024-03-10'),
(3, 7, 5, '2024-03-10'),
(4, 1, 70, '2024-05-10'),
(4, 2, 80, '2024-05-10'),
(4, 3, 40, '2024-05-10'),
(5, 4, 50, '2024-06-05'),
(5, 5, 200, '2024-06-05'),
(5, 6, 10, '2024-06-05'),
(5, 7, 2, '2024-06-05'),
(6, 1, 90, '2024-04-15'),
(6, 2, 100, '2024-04-15'),
(6, 3, 50, '2024-04-15'),
(6, 4, 60, '2024-04-15'),
(7, 5, 250, '2024-03-20'),
(7, 6, 30, '2024-03-20'),
(7, 7, 8, '2024-03-20');

INSERT INTO ARTICLES_PURCHASE_ORDER (orderNumber, SKU, quantity) VALUES
(1, 1, 100),
(1, 2, 120),
(2, 5, 20000)
(3, 3, 200),
(3, 4, 100)
(4, 6, 8),
(4, 7, 300);
(5, 3, 100 )
(5, 4, 135)
(6, 6, 12)
(6, 7, 450)