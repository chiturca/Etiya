--Her kategorideki (CategoryID) ürün sayısını gösteren bir sorgu yazın.
SELECT CategoryID, COUNT(*) AS ProductCount FROM Products
GROUP BY CategoryID;

--Birim fiyatı en yüksek 5 ürünü listeleyin.
SELECT ProductName, UnitPrice FROM Products
ORDER BY UnitPrice DESC
LIMIT 5;

--Her tedarikçinin sattığı ürünlerin ortalama fiyatını listeleyin.
SELECT SupplierID, AVG(UnitPrice) AS AvgPrice FROM Products
GROUP BY SupplierID;

--"Products" tablosunda birim fiyatı 100'den büyük olan ürünlerin kategorilerini ve bu kategorilerdeki ortalama fiyatı listeleyin.
SELECT CategoryID, AVG(UnitPrice) AS AvgPrice FROM Products
WHERE UnitPrice > 100
GROUP BY CategoryID;

--"OrderDetails" tablosunda birim fiyat ve miktar çarpımıyla toplam satış değeri 1000'den fazla olan siparişleri listeleyin.
SELECT *, (UnitPrice * Quantity) AS TotalSales FROM [Order Details]
WHERE (UnitPrice * Quantity) > 1000;

--En son sevk edilen 10 siparişi listeleyin.
SELECT * FROM Orders
ORDER BY ShippedDate DESC
LIMIT 10;

--"Products" tablosundaki ürünlerin ortalama fiyatını hesaplayın.
SELECT AVG(UnitPrice) AS AvgPrice FROM Products;

--"Products" tablosunda fiyatı 50’den büyük olan ürünlerin toplam stok miktarını hesaplayın.
SELECT SUM(UnitsInStock) AS TotalStock  FROM Products
WHERE UnitPrice > 50;

--"Orders" tablosundaki en eski sipariş tarihini bulun.
SELECT MIN(OrderDate) AS OldestOrderDate FROM Orders;

--"Employees" tablosundaki çalışanların kaç yıl önce işe başladıklarını gösteren bir sorgu yazın.
SELECT CONCAT(FirstName, ' ', LastName) AS FullName, strftime('%Y', 'now') - strftime('%Y', HireDate) AS YearsWorked FROM Employees;

--"OrderDetails" tablosundaki her bir sipariş için, birim fiyatın toplamını yuvarlayarak (ROUND) hesaplayın.
SELECT OrderID, ROUND(SUM(UnitPrice), 2) AS TotalUnitPrice FROM [Order Details]
GROUP BY OrderID;

--"Products" tablosunda stoktaki (UnitsInStock) ürün sayısını gösteren bir COUNT sorgusu yazın.
SELECT COUNT(*) AS InStockProducts FROM Products
WHERE UnitsInStock > 0;

--"Products" tablosundaki en düşük ve en yüksek fiyatları hesaplayın.
SELECT MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice FROM Products;

--"Orders" tablosunda her yıl kaç sipariş alındığını listeleyin (YEAR() fonksiyonunu kullanarak).
SELECT strftime('%Y', OrderDate) AS OrderYear, COUNT(*) AS OrderCount FROM Orders
GROUP BY strftime('%Y', OrderDate);

--"Employees" tablosundaki çalışanların tam adını (FirstName + LastName) birleştirerek gösterin.
SELECT CONCAT(FirstName, ' ', LastName) AS FullName FROM Employees;

--"Customers" tablosundaki şehir adlarının uzunluğunu (LENGTH) hesaplayın.
SELECT City, LENGTH(City) AS CityNameLength FROM Customers;

--"Products" tablosundaki her ürünün fiyatını iki ondalık basamağa yuvarlayarak gösterin.
SELECT ProductName, ROUND(UnitPrice, 2) AS RoundedPrice FROM Products;

--"Orders" tablosundaki tüm siparişlerin toplam sayısını bulun.
SELECT COUNT(*) AS TotalOrders FROM Orders;

--"Products" tablosunda her kategorideki (CategoryID) ürünlerin ortalama fiyatını (AVG) hesaplayın.
SELECT CategoryID, AVG(UnitPrice) AS AvgCategoryPrice FROM Products
GROUP BY CategoryID;

--"Orders" tablosunda sevk tarihi (ShippedDate) boş olan siparişlerin yüzdesini (COUNT ve toplam sipariş sayısını kullanarak) hesaplayın.
SELECT (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders)) AS UnshippedPercentage FROM Orders
WHERE ShippedDate IS NULL;

--"Products" tablosundaki en pahalı ürünün fiyatını bulun ve bir fonksiyon kullanarak fiyatı 10% artırın.
SELECT MAX(UnitPrice) AS MaxPrice FROM Products; --En Pahalı Ürün 

SELECT ProductName, UnitPrice * 1.1 AS IncreasedPrice FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products); --%10 Artış

--"Products" tablosundaki ürün adlarının ilk 3 karakterini gösterin (SUBSTRING).
SELECT ProductName, SUBSTRING(ProductName, 1, 3) AS FirstThreeChars FROM Products;

--"Orders" tablosunda verilen siparişlerin yıl ve ay bazında kaç sipariş alındığını hesaplayın (YEAR ve MONTH fonksiyonları).
SELECT strftime('%Y', OrderDate) AS OrderYear, 
       strftime('%m', OrderDate) AS OrderMonth, 
       COUNT(*) AS OrderCount
FROM Orders
GROUP BY OrderYear, OrderMonth;

--"OrderDetails" tablosunda toplam sipariş değerini (UnitPrice * Quantity) hesaplayıp, bu değeri iki ondalık basamağa yuvarlayarak gösterin.
SELECT OrderID, ROUND(SUM(UnitPrice * Quantity), 2) AS TotalOrderValue FROM [Order Details]
GROUP BY OrderID;

--"Products" tablosunda stokta olmayan (UnitsInStock = 0) ürünlerin fiyatlarını toplam fiyat olarak hesaplayın.
SELECT SUM(UnitPrice) AS TotalPrice FROM Products
WHERE UnitsInStock = 0;