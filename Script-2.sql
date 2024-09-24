-- 101. Hangi tedarikçi hangi ürünü sağlıyor ?
select s.company_name, p.product_name from suppliers s 
join products p on p.supplier_id = s.supplier_id
order by s.company_name, p.product_name;

-- 102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select o.order_id, s.company_name, o.shipped_date from orders o 
join shippers s on s.shipper_id = o.ship_via; 

-- 103. Hangi siparişi hangi müşteri verir..?
select o.order_id, c.company_name from orders o 
join customers c on c.customer_id = o.customer_id;

-- 104. Hangi çalışan, toplam kaç sipariş almış..?
select 
	concat(e.first_name, ' ', e.last_name) employee_name, 
	count(o.order_id) order_count 
from employees e 
join orders o on o.employee_id = e.employee_id 
group by employee_name;

-- 105. En fazla siparişi kim almış..?
select 
	concat(e.first_name, ' ', e.last_name) employee_name, 
	count(o.order_id) order_count 
from employees e 
join orders o on o.employee_id = e.employee_id 
group by employee_name
order by order_count desc limit 1;

-- 106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select 
	o.order_id, 
	concat(e.first_name, ' ', e.last_name) employee_name,
	c.company_name 
from orders o 
join employees e on o.employee_id = e.employee_id 
join customers c on o.customer_id = c.customer_id;

-- 107. Hangi ürün, hangi kategoride bulunmaktadır..? 
--Bu ürünü kim tedarik etmektedir..?
select p.product_name, c.category_name, s.company_name from products p 
join categories c on p.category_id = c.category_id 
join suppliers s on p.supplier_id = s.supplier_id;

-- 108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, 
--hangi tarihte, hangi kargo şirketi tarafından gönderilmiş, 
--hangi üründen kaç adet alınmış, hangi fiyattan alınmış, 
--ürün hangi kategorideymiş, bu ürünü hangi tedarikçi sağlamış
select
	o.order_id, c.company_name,
	concat(e.first_name, ' ', e.last_name) employee_name,
	o.order_date, s.company_name shipper_company,
	p.product_name, od.quantity, od.unit_price, c2.category_name,
	s2.company_name supplier_company
from orders o 
join customers c on o.customer_id = c.customer_id 
join employees e on o.employee_id = e.employee_id 
join shippers s on o.ship_via = s.shipper_id 
join order_details od on o.order_id = od.order_id 
join products p on od.product_id = p.product_id 
join categories c2 on p.category_id = c2.category_id 
join suppliers s2 on p.supplier_id = s2.supplier_id
order by o.order_id;

-- 109. Altında ürün bulunmayan kategoriler
select * from categories c 
left join products p on c.category_id = p.category_id 
where p.product_id = null;

-- 110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select * from customers c 
where lower(contact_title) like '%manager%';

-- 111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select * from customers c 
where 
	lower(company_name) like 'fr___' 
	or 
	lower(contact_name) like 'fr___'
	or
	lower(customer_id) like 'fr___'; 

-- 112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers c 
where phone like '(171)%';

-- 113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products p 
where lower(quantity_per_unit) like '%boxes%';

-- 114. Fransa ve Almanyadaki (France,Germany) 
--Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select contact_name, phone from customers c
where country in ('France','Germany')
	and lower(contact_title) like '%manager%';

-- 115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select * from products p 
order by unit_price desc limit 10;

-- 116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select * from customers c 
order by country, city;

-- 117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name, last_name, extract(year from age(current_date, birth_date)) age from employees e;

-- 118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select order_id, order_date, shipped_date, (shipped_date - order_date) Days_To_Ship from orders o 
where (shipped_date - order_date) > 35 or shipped_date is null; 

-- 119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select c.category_name from products p 
join categories c on p.category_id = c.category_id 
where unit_price = (select max(unit_price) from products p2);

-- 120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select product_id, product_name, category_id from products p 
where category_id in (select category_id from categories c 
					where lower(category_name) like '%on%');

-- 121. Konbu adlı üründen kaç adet satılmıştır.
select sum(quantity) konbu_count from order_details od 
where product_id in (select product_id from products p
						where product_name = 'Konbu');

-- 122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(distinct product_id) japan_products from products p 
join suppliers s on p.supplier_id = s.supplier_id 
where s.country = 'Japan';
					
-- 123. 1997 yılında yapılmış satışların en yüksek, 
--en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight), min(freight), avg(freight) from orders o 
where date_part('year', order_date) = 1997;

-- 124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers c 
where fax is not null;

-- 125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select * from orders o 
where shipped_date between '1996-07-16' and '1996-07-30';
