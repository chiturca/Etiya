-- 1. En Pahalı Ürünü Getirin
SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice DESC
LIMIT 1;

-- 2. En Son Verilen Siparişi Bulun
SELECT OrderID, OrderDate FROM Orders
ORDER BY OrderDate DESC
LIMIT 1;

-- 3. Fiyatı Ortalama Fiyattan Yüksek Olan Ürünleri Getirin
SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products);

-- 4. Belirli Kategorilerdeki Ürünleri Listeleyin
SELECT ProductName, CategoryID FROM Products
WHERE CategoryID IN (1, 3);

-- 5. En Yüksek Fiyatlı Ürünlere Sahip Kategorileri Listeleyin
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice FROM Products
GROUP BY CategoryID
ORDER BY MaxPrice DESC;

-- 6. Bir Ülkedeki Müşterilerin Verdiği Siparişleri Listeleyin
SELECT Orders.OrderID, Customers.CompanyName, Customers.Country FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Customers.Country = 'Belgium';

-- 7. Her Kategori İçin Ortalama Fiyatın Üzerinde Olan Ürünleri Listeleyin
SELECT ProductName, UnitPrice, CategoryID FROM Products p1
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products p2 WHERE p1.CategoryID = p2.CategoryID);

-- 8. Her Müşterinin En Son Verdiği Siparişi Listeleyin
SELECT Customers.CompanyName, MAX(Orders.OrderDate) AS LastOrderDate FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName;

-- 9. Her Çalışanın Kendi Departmanındaki Ortalama Maaşın Üzerinde Maaş Alıp Almadığını Bulun xxx
-- 9. (Maaş kısmı olmadığı için alternatif soru) En çok sipariş alan çalışan
-- SELECT e1.FirstName || ' ' || e1.LastName AS EmployeeName, e1.Salary, AVG(e2.Salary) AS AvgSalary FROM Employees e1
-- JOIN Employees e2 ON e1.DepartmentID = e2.DepartmentID
-- GROUP BY e1.EmployeeID
-- HAVING e1.Salary > AVG(e2.Salary);

SELECT e.FirstName || ' ' || e.LastName AS EmployeeName, COUNT(o.OrderID) AS TotalOrders FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID
ORDER BY TotalOrders DESC
LIMIT 1;

-- 10. En Az 10 Ürün Satın Alınan Siparişleri Listeleyin
SELECT OrderID, SUM(Quantity) AS TotalQuantity FROM "Order Details"
GROUP BY OrderID
HAVING TotalQuantity >= 10;

-- 11. Her Kategoride En Pahalı Olan Ürünlerin Ortalama Fiyatını Bulun
SELECT AVG(MaxPrice) AS AvgMaxPrice
FROM (SELECT MAX(UnitPrice) AS MaxPrice FROM Products
      GROUP BY CategoryID);

-- 12. Müşterilerin Verdiği Toplam Sipariş Sayısına Göre Sıralama Yapın
SELECT Customers.CompanyName, COUNT(Orders.OrderID) AS TotalOrders FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
ORDER BY TotalOrders DESC;

-- 13. En Fazla Sipariş Vermiş 5 Müşteriyi ve Son Sipariş Tarihlerini Listeleyin
SELECT Customers.CompanyName, COUNT(Orders.OrderID) AS TotalOrders, MAX(Orders.OrderDate) AS LastOrderDate FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
ORDER BY TotalOrders DESC
LIMIT 5;

-- 14. Toplam Ürün Sayısı 7'ten Fazla Olan Kategorileri Listeleyinz
SELECT Categories.CategoryName, COUNT(Products.ProductID) AS TotalProducts FROM Products
JOIN Categories on Products.CategoryID = Categories.CategoryID
GROUP BY Products.CategoryID
HAVING TotalProducts > 7;

-- 15. En Fazla 77 Farklı Ürün Sipariş Eden Müşterileri Listeleyin
SELECT Customers.CompanyName, COUNT(DISTINCT "Order Details".ProductID) AS ProductCount FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID
GROUP BY Customers.CompanyName
HAVING ProductCount <= 77;

-- 16. 2'den Fazla Ürün Sağlayan Tedarikçileri Listeleyin
SELECT Suppliers.CompanyName, COUNT(Products.ProductID) AS TotalProducts FROM Suppliers
JOIN Products ON Suppliers.SupplierID = Products.SupplierID
GROUP BY Suppliers.CompanyName
HAVING TotalProducts > 2;

-- 17. Her Müşteri İçin En Pahalı Ürünü Bulun
SELECT Customers.CompanyName, Products.ProductName, MAX("Order Details".UnitPrice) AS MaxPrice FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID
JOIN Products ON "Order Details".ProductID = Products.ProductID
GROUP BY Customers.CompanyName;

-- 18. 50.000.000'den Fazla Sipariş Değeri Olan Çalışanları Listeleyin
SELECT Employees.FirstName || ' ' || Employees.LastName AS EmployeeName, SUM("Order Details".Quantity * "Order Details".UnitPrice) AS TotalSales FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID
GROUP BY Employees.EmployeeID
HAVING TotalSales > 50000000;

-- 19. Kategorisine Göre En Çok Sipariş Edilen Ürünü Bulun
SELECT p.CategoryID, p.ProductName, SUM(od.Quantity) AS TotalOrdered
FROM Products p
JOIN "Order Details" od ON p.ProductID = od.ProductID
GROUP BY p.CategoryID, p.ProductID
HAVING SUM(od.Quantity) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(od2.Quantity) AS total
        FROM Products p2
        JOIN "Order Details" od2 ON p2.ProductID = od2.ProductID
        WHERE p2.CategoryID = p.CategoryID
        GROUP BY p2.ProductID
    )
);

-- 20. Müşterilerin En Son Sipariş Verdiği Ürün ve Tarihlerini Listeleyin
SELECT Customers.CompanyName, Products.ProductName, MAX(Orders.OrderDate) AS LastOrderDate FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID
JOIN Products ON "Order Details".ProductID = Products.ProductID
GROUP BY Customers.CompanyName;

-- 21. Her Çalışanın Teslim Ettiği En Pahalı Siparişi ve Tarihini Listeleyin
SELECT Employees.FirstName || ' ' || Employees.LastName AS EmployeeName, Orders.OrderID, MAX("Order Details".UnitPrice * "Order Details".Quantity) AS MaxOrderValue, MAX(Orders.OrderDate) AS OrderDate FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
JOIN "Order Details" ON Orders.OrderID = "Order Details".OrderID
GROUP BY Employees.EmployeeID;

-- 22. En Fazla Sipariş Verilen Ürünü ve Bilgilerini Listeleyin
SELECT Products.ProductName, SUM("Order Details".Quantity) AS TotalOrdered FROM Products
JOIN "Order Details" ON Products.ProductID = "Order Details".ProductID
GROUP BY Products.ProductID
ORDER BY TotalOrdered DESC
LIMIT 1;