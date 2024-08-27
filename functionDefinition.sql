create or replace FUNCTION public.Calisanlar(yil INT)
 returns TABLE (Calisan   varchar, ciro NUMERIC) 
as 
$func$
select  e.First_Name Calisan,sum(od.Quantity*od.Unit_Price*(1-Discount)) Ciro 
    from Employees e
    inner join orders o on e.Employee_ID = o.Employee_ID
    inner join Order_Details od on od.Order_ID=o.Order_ID
    where date_part('year',o.order_date)=yil 
     group by  e.First_Name 
    order by ciro desc ;
$func$
LANGUAGE sql;

select * from Calisanlar(1997) --where calisan = 'Janet';


create or replace FUNCTION public.CalisanPerformanslari()
 RETURNS TABLE (
  Calisan VARCHAR,
  Yil int,
  Adet bigint,
  Ciro float8
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  Select e.First_Name As Calisan ,
            date_part('year',o.order_date)::int AS Yil ,
            count(*) Adet,
            sum(od.quantity*od.Unit_Price) AS Ciro
  from Employees e 
  inner join orders o on o.Employee_ID = e.Employee_ID
  inner join Order_Details od on od.Order_ID = o.order_id 
 -- where e.employee_id = calisanId
  group by e.first_name , date_part('year',o.order_date) ;

  end; $$;
 select * from CalisanPerformanslari();
drop function public.CalisanlarinPerformansi
CREATE OR REPLACE FUNCTION public.CalisanlarinPerformansi(calisanId INT)
RETURNS TABLE (
  Calisan VARCHAR,
  Yil int,
  Adet bigint,
  Ciro float8
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY


		  SELECT e.First_Name  AS Calisan,
		  date_part('year',o.order_date)::int Yil,
		         COUNT(*) AS Adet,
		         SUM(od.quantity * od.unit_price) AS Ciro
		  FROM employees e
		  INNER JOIN orders o USING (employee_id)
		  INNER JOIN order_details od USING (order_id)
		  WHERE e.employee_id = calisanId
		  GROUP BY First_Name , date_part('year',o.order_date)
		  ORDER BY Ciro DESC;

END;
$$;
select * from CalisanlarinPerformansi(1)