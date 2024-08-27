CREATE OR REPLACE FUNCTION stok_kontrol()
   RETURNS TRIGGER
   LANGUAGE PLPGSQL
AS
$$
DECLARE
   eldekistok int;
   fark int;
BEGIN
   raise notice 'Yeni Kayit : % Gelen Stock Id:%',NEW,NEW.product_id ;

select p.units_in_stock into eldekistok from products p where p.product_id =NEW.product_id ;
raise notice 'Eldeki Stok :%',eldekistok;
select  (eldekistok - new.quantity) into fark;
  raise notice 'eldeki stok  : %  Gelen Siparis:% fark:%',eldekistok,new.quantity,fark;   
    if  fark < 0 then 
       raise notice 'Elde ki stok  : % . Yeteri kadar urun yok.',(eldekistok - new.quantity);
       ROLLBACK;
    end if ;

   if NEW.quantity < 0  then 
       raise notice 'Adet 0 dan kucuk olamaz  : %',NEW.quantity;
       ROLLBACK;
    end if;
   RETURN NEW;
END;
$$

CREATE TRIGGER order_details_before_insert
BEFORE INSERT
ON order_details
FOR EACH ROW
EXECUTE FUNCTION stok_kontrol();

select * from order_details where order_id =10248 limit 5
delete from order_details where order_id =10248 and product_id =1 
insert into order_details (order_id,product_id,unit_price,quantity,discount)
  values (10248,1,10,400,0)