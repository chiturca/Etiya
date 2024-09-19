--Verilen Customers ve Orders tablolarını kullanarak, Customers tablosundaki müşterileri ve onların verdikleri siparişleri birleştirerek listeleyin. Müşteri adı, sipariş ID'si ve sipariş tarihini gösterin.
SELECT Customers.CompanyName, Orders.OrderID, Orders.OrderDate FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

--Verilen Suppliers ve Products tablolarını kullanarak tüm tedarikçileri ve onların sağladıkları ürünleri listeleyin. Eğer bir tedarikçinin ürünü yoksa, NULL olarak gösterilsin.
SELECT Suppliers.CompanyName, Products.ProductName FROM Suppliers
LEFT JOIN Products ON Suppliers.SupplierID = Products.SupplierID;

--Verilen Employees ve Orders tablolarını kullanarak tüm siparişleri ve bu siparişleri işleyen çalışanları listeleyin. Eğer bir sipariş bir çalışan tarafından işlenmediyse, çalışan bilgileri NULL olarak gösterilsin.
SELECT Orders.OrderID, Employees.FirstName || ' ' || Employees.LastName AS EmployeeName FROM Orders
LEFT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID;

--Verilen Customers ve Orders tablolarını kullanarak tüm müşterileri ve tüm siparişleri listeleyin. Sipariş vermeyen müşteriler ve müşterisi olmayan siparişler için NULL döndürün.
SELECT Customers.CompanyName, Orders.OrderID, Orders.OrderDate FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

--Verilen Products ve Categories tablolarını kullanarak tüm ürünler ve tüm kategoriler için olası tüm kombinasyonları listeleyin. Sonuç kümesindeki her satır bir ürün ve bir kategori kombinasyonunu göstermelidir.
SELECT Products.ProductName, Categories.CategoryName FROM Products
CROSS JOIN Categories;

--Verilen Orders, Customers, Employees tablolarını kullanarak bu tabloları birleştirin ve 2020 yılında verilen siparişleri listeleyin. Müşteri adı, sipariş ID'si, sipariş tarihi ve ilgili çalışan adı gösterilsin.
SELECT Customers.CompanyName, Orders.OrderID, Orders.OrderDate, Employees.FirstName || ' ' || Employees.LastName AS EmployeeName FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
WHERE strftime('%Y', Orders.OrderDate) = '2020';

--Verilen Orders ve Customers tablolarını kullanarak müşterileri, verdikleri sipariş sayısına göre gruplandırın. Sadece 5’ten fazla sipariş veren müşterileri listeleyin.
SELECT Customers.CompanyName, COUNT(Orders.OrderID) AS OrderCount FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
HAVING OrderCount > 5;

--Verilen OrderDetails ve Products tablolarını kullanarak her ürün için kaç adet satıldığını ve toplam satış miktarını listeleyin. Ürün adı, satılan toplam adet ve toplam kazancı (Quantity * UnitPrice) gösterin.
SELECT Products.ProductName, SUM("Order Details".Quantity) AS TotalQuantity, SUM("Order Details".Quantity * "Order Details".UnitPrice) AS TotalSales FROM "Order Details"
JOIN Products ON "Order Details".ProductID = Products.ProductID
GROUP BY Products.ProductName;

--Verilen Customers ve Orders tablolarını kullanarak, müşteri adı "B" harfiyle başlayan müşterilerin siparişlerini listeleyin.
SELECT Customers.CompanyName, Orders.OrderID, Orders.OrderDate FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.CompanyName LIKE 'B%';

--Verilen Products ve Categories tablolarını kullanarak tüm kategorileri listeleyin ve ürünleri olmayan kategorileri bulun. Ürün adı NULL olan satırları gösterin.
SELECT Categories.CategoryName, Products.ProductName FROM Categories
LEFT JOIN Products ON Categories.CategoryID = Products.CategoryID
WHERE Products.ProductName IS NULL;

--Verilen Employees tablosunu kullanarak her çalışanın yöneticisiyle birlikte bir liste oluşturun.
SELECT e1.FirstName || ' ' || e1.LastName AS EmployeeName,
       e2.FirstName || ' ' || e2.LastName AS ManagerName
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID;

--Verilen Products tablosunu kullanarak her kategorideki en pahalı ürünleri ve bu ürünlerin farklı fiyatlara sahip olup olmadığını sorgulayın.
SELECT CategoryID, MAX(UnitPrice) AS MaxPrice FROM Products
GROUP BY CategoryID;

--Verilen Orders ve OrderDetails tablolarını kullanarak bu tabloları birleştirin ve her siparişin detaylarını sipariş ID'sine göre artan sırada listeleyin.
SELECT "Order Details".OrderID, Products.ProductName, "Order Details".Quantity, "Order Details".UnitPrice FROM "Order Details"
JOIN Products ON "Order Details".ProductID = Products.ProductID
ORDER BY "Order Details".OrderID ASC;

--Verilen Employees ve Orders tablolarını kullanarak her çalışanın kaç tane sipariş işlediğini listeleyin. Sipariş işlemeyen çalışanlar da gösterilsin.
SELECT Employees.FirstName || ' ' || Employees.LastName AS EmployeeName, COUNT(Orders.OrderID) AS OrderCount FROM Employees
LEFT JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID;

--Verilen Products tablosunu kullanarak bir kategorideki ürünleri kendi arasında fiyatlarına göre karşılaştırın ve fiyatı düşük olan ürünleri listeleyin.
SELECT CategoryID, ProductName, UnitPrice FROM Products p1
WHERE UnitPrice < (SELECT MAX(UnitPrice) FROM Products p2 WHERE p1.CategoryID = p2.CategoryID);

--Verilen Products ve Suppliers tablolarını kullanarak tedarikçiden alınan en pahalı ürünleri listeleyin.
SELECT Suppliers.CompanyName, Products.ProductName, MAX(Products.UnitPrice) AS MaxPrice FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
GROUP BY Suppliers.SupplierID;

--Verilen Employees ve Orders tablolarını kullanarak her çalışanın işlediği en son siparişi bulun.
SELECT Employees.FirstName || ' ' || Employees.LastName AS EmployeeName, MAX(Orders.OrderDate) AS LastOrderDate FROM Orders
JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
GROUP BY Employees.EmployeeID;

--Verilen Products tablosunu kullanarak ürünleri fiyatlarına göre gruplandırın ve fiyatı 20 birimden fazla olan ürünlerin sayısını listeleyin.
SELECT COUNT(*) AS ProductCount FROM Products
WHERE UnitPrice > 20;

--Verilen Orders ve Customers tablolarını kullanarak 2020 ile 2021 yılları arasında verilen siparişleri müşteri adıyla birlikte listeleyin.
SELECT Customers.CompanyName, Orders.OrderID, Orders.OrderDate FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE strftime('%Y', Orders.OrderDate) IN ('2020', '2021');

--Verilen Customers ve Orders tablolarını kullanarak hiç sipariş vermeyen müşterileri listeleyin.
SELECT Customers.CompanyName, Orders.OrderID FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL;