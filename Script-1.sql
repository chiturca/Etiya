--1. Product isimlerini (`ProductName`) ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
select product_name, quantity_per_unit from products p;

--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
select product_id, product_name, discontinued from products p
where discontinued = 1;

--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) değerleriyle almak için bir sorgu yazın.
select product_id, product_name, discontinued from products p 
where discontinued = 1;

--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products p 
where unit_price < 20;

--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products p 
where unit_price between 15 and 25;

--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_name, units_on_order, units_in_stock from products p 
where units_in_stock  < units_on_order;

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
select * from products p 
where  product_name like 'A%';

--8. İsmi `i` ile biten ürünleri listeleyeniz.
select * from products p 
where product_name like '%i';

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak (ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name, unit_price * 1.18 as UnitPriceVAT from products p;

--10. Fiyatı 30 dan büyük kaç ürün var?
select count(*) Above30 from products p 
where unit_price > 30;

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
select lower(product_name) LowerName, unit_price from products p
order by unit_price desc;

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
select concat(first_name, ' ', last_name) FullName from employees e;

--13. Region alanı NULL olan kaç tedarikçim var?
select count(*) NullRegion from suppliers s 
where region is null;

--14. a.Null olmayanlar?
select count(*) RegionCount from suppliers s 
where region is not null;

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select concat('TR ', upper(product_name)) from products p;

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select concat('TR ', product_name) from products p
where  unit_price < 20;

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products p 
order by unit_price desc;

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products p
order by unit_price desc
limit 10;

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products p
where unit_price  > (select avg(unit_price) from products p2)
order by unit_price;

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select sum(unit_price*units_in_stock) TotalIncome from products p;

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select count(case when discontinued = 0 then 1 end) discountinued,
	count(case when discontinued = 1 then 1 end) continued,
	count(discontinued) total
from products p; 

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
select p.product_name, c.category_name from products p
inner join categories c on p.category_id = c.category_id;

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select c.category_name, avg(p.unit_price) AS Average_Prices from products p
inner join categories c on  p.category_id = c.category_id
group by c.category_name ;

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on p.category_id = c.category_id
where p.unit_price = (select max(unit_price) from products p2);

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name from products p 
join categories c on p.category_id = c.category_id
join suppliers s on p.supplier_id = s.supplier_id
where reorder_level = (select max(reorder_level) from products p2);

--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, s.company_name, s.phone from products p 
left join suppliers s on p.supplier_id = s.supplier_id 
where p.units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select o.ship_address, e.first_name || ' ' || e.last_name Order_Employee, o.order_date from orders o 
join employees e on o.employee_id = e.employee_id 
where o.order_date >= '1998-03-01' and o.order_date <= '1998-03-31';

--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) MarchOrders from orders o 
where date_part('year', order_date) = 1997 
	and date_part('month', order_date) = 02; 

--29. London şehrinden 1998 yılında kaç siparişim var?
select ship_city, count(order_id) order_count from orders o
where ship_city = 'London' and date_part('year', order_date) = 1998
group by ship_city;
	
--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select c.contact_name, c.phone from customers c 
join orders o on c.customer_id = o.customer_id 
where date_part('year', o.order_date) = 1997 
group by c.customer_id 
order by c.contact_name;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders o 
where freight > 40
order by order_id 

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select o.ship_city, c.company_name, sum(freight) AS Total_Ship_Price from orders o 
join customers c ON o.customer_id = c.customer_id 
where o.freight > 40
group by company_name, o.ship_city 
order by company_name;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select o.order_date, o.ship_city, upper(concat(e.first_name, ' ', e.last_name)) from orders o 
join employees e on o.employee_id = e.employee_id 
where date_part('year', o.order_date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select c.contact_name, REGEXP_REPLACE(c.phone, '[^0-9]', '', 'g') AS Phone_Formatted from orders o 
join customers c on o.customer_id = c.customer_id 
where date_part('year', o.order_date) = 1997; 

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date, c.contact_name, concat(e.first_name, ' ', e.last_name) employee_name from orders o 
join customers c on o.customer_id = c.customer_id 
join employees e on o.employee_id = e.employee_id;

--36. Geciken siparişlerim?
select * from orders o 
where required_date < shipped_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select o.order_date, c.company_name, c.contact_name from orders o 
join customers c on o.customer_id = c.customer_id 
where required_date < shipped_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity from order_details od 
join products p on od.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
where od.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name, s.contact_name from order_details od 
join products p on od.product_id = p.product_id 
join suppliers s on p.supplier_id = s.supplier_id 
where od.order_id = 10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity from products p 
join order_details od on od.product_id = p.product_id 
join orders o on od.order_id = o.order_id 
where o.employee_id = 3 and date_part('year', o.order_date) = 1997;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name, e.last_name, (od.quantity * od.unit_price * (1 - od.discount)) as Sale_amount from orders o 
join order_details od on o.order_id = od.order_id 
join employees e on o.employee_id = e.employee_id 
where date_part('year', o.order_date) = 1997
group by o.order_id, e.employee_id, e.first_name, e.last_name, Sale_amount
order by Sale_amount desc limit 1; 

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, e.first_name, e.last_name, sum(od.quantity * od.unit_price * (1 - od.discount)) as Total_sales from orders o 
join order_details od on o.order_id = od.order_id 
join employees e on o.employee_id = e.employee_id 
where date_part('year', o.order_date) = 1997
group by o.order_id, e.employee_id, e.first_name, e.last_name
order by Total_sales desc limit 1; 

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p 
join categories c on p.category_id = c.category_id
order by p.unit_price desc limit 1;

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id from employees e 
join orders o on e.employee_id = o.employee_id 
order by o.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.unit_price * od.quantity * (1 - od.discount)) avg_price, o.order_id from order_details od 
join orders o on od.order_id = o.order_id 
group by o.order_id
order by o.order_date desc limit 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, (od.unit_price * od.quantity * (1 - od.discount)) total_sales from products p 
join categories c on p.category_id = c.category_id 
join order_details od on od.product_id = p.product_id
join orders o on od.order_id = o.order_id 
where date_part('month', o.order_date) = 01;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select * from order_details od 
where 
	(quantity*unit_price*(1-discount))
	> 
	(select avg(quantity*unit_price*(1-discount)) from order_details od2);

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name, s.contact_name from order_details od 
join products p on od.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
join suppliers s on p.supplier_id = s.supplier_id 
where 
	od.quantity 
	=
	(select max(quantity) from order_details od2);

--49. Kaç ülkeden müşterim var
select count(distinct country) from customers c;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(od.quantity * od.unit_price * (1-od.discount)) total_sales from orders o 
join order_details od on o.order_id = od.order_id 
where o.employee_id = 3
	and 
	o.order_date between '1998-01-01' and now();

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, od.quantity from order_details od 
join products p on od.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
where od.order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name, s.contact_name from order_details od 
join products p on od.product_id = p.product_id 
join suppliers s on p.supplier_id = s.supplier_id 
where od.order_id = 10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity from products p 
join order_details od on od.product_id = p.product_id 
join orders o on od.order_id = o.order_id 
where o.employee_id = 3 and date_part('year', o.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name, e.last_name, (od.quantity * od.unit_price * (1 - od.discount)) as Sale_amount from orders o 
join order_details od on o.order_id = od.order_id 
join employees e on o.employee_id = e.employee_id 
where date_part('year', o.order_date) = 1997
group by o.order_id, e.employee_id, e.first_name, e.last_name, Sale_amount
order by Sale_amount desc limit 1; 

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, e.first_name, e.last_name, sum(od.quantity * od.unit_price * (1 - od.discount)) AS Total_sales from orders o 
join order_details od on o.order_id = od.order_id 
join employees e on o.employee_id = e.employee_id 
where date_part('year', o.order_date) = 1997
group by o.order_id, e.employee_id, e.first_name, e.last_name
order by Total_sales desc limit 1; 

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p 
join categories c on p.category_id = c.category_id
order by p.unit_price desc limit 1;

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name, e.last_name, o.order_date, o.order_id from employees e 
join orders o on e.employee_id = o.employee_id 
order by o.order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select avg(od.unit_price * od.quantity * (1 - od.discount)) avg_price, o.order_id from order_details od 
join orders o on od.order_id = o.order_id 
group by o.order_id
order by o.order_date desc limit 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, (od.unit_price * od.quantity * (1 - od.discount)) total_sales from products p 
join categories c on p.category_id = c.category_id 
join order_details od on od.product_id = p.product_id
join orders o on od.order_id = o.order_id 
where date_part('month', o.order_date) = 01;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select * from order_details od 
where 
	(quantity*unit_price*(1-discount))
	> 
	(select avg(quantity*unit_price*(1-discount)) from order_details od2);

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name, s.contact_name from order_details od 
join products p on od.product_id = p.product_id 
join categories c on p.category_id = c.category_id 
join suppliers s on p.supplier_id = s.supplier_id 
where 
	od.quantity 
	=
	(select max(quantity) from order_details od2);

--62. Kaç ülkeden müşterim var
select count(distinct country) from customers c;

--63. Hangi ülkeden kaç müşterimiz var
select country, count(*) total_customers from customers c 
group by country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(od.quantity * od.unit_price * (1-od.discount)) total_sales from orders o 
join order_details od on o.order_id = od.order_id 
where o.employee_id = 3
	and 
	o.order_date between '1998-01-01' and now();

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select sum(od.quantity * od.unit_price * (1-od.discount)) total_sales from order_details od
join orders o on o.order_id = od.order_id 
where od.product_id = 10 
	and o.order_date between '1998-02-01' and '1998-05-06';

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select 
	e.employee_id, e.first_name, e.last_name, count(o.order_id) as total_orders 
from employees e
join orders o on e.employee_id = o.employee_id
group by e.employee_id, e.first_name, e.last_name
order by total_orders desc;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select c.customer_id, c.contact_name from customers c
left join orders o on c.customer_id = o.customer_id
where o.customer_id is null;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers c
where country in ('Brazil');

--69. Brezilya’da olmayan müşteriler
select * from customers c
where country <> 'Brazil'; 

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, country from customers c 
where country in ('Spain', 'France', 'Germany');

--71. Faks numarasını bilmediğim müşteriler
select * from customers  c
where fax is null;

--72. Londra’da ya da Paris’de bulunan müşterilerim
select company_name, contact_name, city from customers c
where city in ('London', 'Paris');

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select company_name, contact_name, city, contact_title from customers c
where city in ('México D.F.') and contact_title in ('Owner');

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products p
where product_name like 'C%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name, birth_date from employees
where first_name like 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers c
where upper(company_name) like ('%RESTAURANT%');

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products p
where unit_price between 50 and 150;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select o.order_id , o.order_date from orders o
where o.order_date >= '1996-07-01' and o.order_date <= '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, country from customers c 
where country in ('Spain', 'France', 'Germany');

--80. Faks numarasını bilmediğim müşteriler
select * from customers  c
where fax is null;

--81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers c
order by country;

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products p
order by unit_price desc;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select p.product_name, p.unit_price from products p
order by p.unit_price desc, p.units_in_stock;

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(*) as product_count from products p
where category_id = 1;

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct ship_country) from orders o;

--86. a.Bu ülkeler hangileri..?
select distinct ship_country from orders o;

--87. En Pahalı 5 ürün
select * from products p
order by unit_price desc limit 5;

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select count(*) from orders o
where customer_id = 'ALFKI';

--89. Ürünlerimin toplam maliyeti
select sum(units_in_stock * unit_price) as total_cost from products p;

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum(od.quantity*p.unit_price * (1 - od.discount)) as total_revenue from order_details od
inner join products p on p.product_id = od.product_id;

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products p;

--92. En Pahalı Ürünün Adı
select product_name from products p
where unit_price = (select max(unit_price) from products p2);

--93. En az kazandıran sipariş
select 
	order_id, (quantity * unit_price * (1 - discount)) as order_revenue 
from order_details od
order by order_revenue limit 1;

--94. Müşterilerimin içinde en uzun isimli müşteri
select company_name from customers c
order by length(company_name) desc limit 1;

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name, last_name, extract(year from age(current_date, birth_date)) age from employees e;

--96. Hangi üründen toplam kaç adet alınmış..?
select p.product_name, sum(od.quantity) amount from products p
inner join order_details od on p.product_id = od.product_id
group by product_name;

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select 
	order_id, sum(unit_price*quantity * (1 - discount)) as total_earnings 
from order_details od
group by order_id;

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select c.category_name, count(p.product_id) as total_products from categories c
inner join products p on c.category_id = p.category_id
group by c.category_name;

--99. 1000 Adetten fazla satılan ürünler?
select p.product_name, sum(od.quantity) as total_sales from products p
inner join order_details od on p.product_id = od.product_id
group by p.product_id, p.product_name
having sum(od.quantity) > 1000;

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.customer_id, c.company_name from customers c
left join orders o on c.customer_id = o.customer_id
where o.customer_id is null;

