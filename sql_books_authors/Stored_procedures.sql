CREATE DEFINER=`root`@`localhost` PROCEDURE `myproc`(IN bid integer)
BEGIN
	declare lcl_title varchar(255);
    declare lcl_aid integer;
    
    select title, authorid 
    into lcl_title, lcl_aid 
    from books 
    where bookid  = bid;   
    
    
    select concat(lcl_title, ' was written by ', lcl_aid) as msg;
    
END


CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_if`(num integer)
BEGIN
    if num = 1 then
        select "Monday" as day;
    elseif num = 2 then
        select "Tuesday" as day;
    elseif num = 3 then
        select "wed" as day;
    elseif num = 4 then
        select "Thursday" as day;
    elseif num = 5 then
        select "Friday" as day;
    elseif num = 6 then
        select "Saturday" as day;
    elseif num = 7 then
        select "Sunday" as day;
    else
        select "Out of range" as msg;
    end if;
        
END

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_case`(num integer)
BEGIN
case num
    when 1 then
        select "Monday" as day;
    when 2 then
        select "Tuesday" as day;
    when 3 then
        select "wed" as day;
    when 4 then
        select "Thursday" as day;
    when 5 then
        select "Friday" as day;
    when 6 then
        select "Saturday" as day;
    when 7 then
        select "Sunday" as day;
    else
        select "Out of range" as msg;
end case;

END



CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_ex`(num integer)
BEGIN
    declare continue handler for 1146
    begin
       select "Please check if table rtrtr exists on your database" as msg;
    end;
    declare continue handler for 1058
    begin
       select "There is no column called title in authors" as msg;
    end;
    declare continue handler for SQLEXCEPTION
    begin
       select "Something went wrong" as msg;
    end;
    -- Procedure Begins
    select "Start Procedure" as message;
    
    if num = 1 then
        select * from rtrtr;
    else
        select title from authors;
    end if;
    
    select "Procedure completed" as message;

END


CREATE DEFINER=`root`@`localhost` PROCEDURE `make_payment`(cid integer, amt integer)
BEGIN
    declare AmountNull condition for 1048;
    declare continue handler for AmountNull
    begin
        insert into fraud (client_id,message,tot)
        values(cid,'Fraud Trs.', now() );
    end;
    
    -- Procedure begins
    insert into payments values(cid, amt);
    select "Payment Processed" as msg;

END


CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_cursor1`()
BEGIN
    declare lcl_title varchar(255);
    declare lcl_aid integer;
    declare finished integer default 0;
    
    declare mycur cursor for select title, authorid from books;
    declare continue handler for NOT FOUND
    BEGIN
        set finished = 1;
    END;
    open mycur;
    readloop:LOOP
    
        fetch mycur into lcl_title, lcl_aid;
        
        if finished = 1 then
            leave readloop;
        end if;
        
        select concat(lcl_title, ' was written by ', lcl_aid) as msg;
    
    end LOOP readloop;
    
    close mycur;
END


CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_orders`()
BEGIN
    declare lcl_pcode varchar(15);
    declare lcl_pvendor varchar(50);
    declare lcl_qty integer;
    
    declare finished integer default 0;
    
    declare mycur cursor for select pcode, pvendor, qtyinstock from products;
    declare continue handler for NOT FOUND set finished = 1;
    
    open mycur;
    readloop:LOOP
    
        fetch mycur into lcl_pcode, lcl_pvendor,lcl_qty;
        
        if finished = 1 then
            leave readloop;
        end if;
        
        if lcl_qty < 2000 then
            insert into orders (product_code, vendor, status)
            values (lcl_pcode, lcl_pvendor, 'Immediate');
        elseif lcl_qty < 5000 then
            insert into orders (product_code, vendor, status)
            values (lcl_pcode, lcl_pvendor, 'Needed soon');
        end if;
    
    end LOOP readloop;
close mycur;
END

CREATE DEFINER=`root`@`localhost` FUNCTION `experience`(eid integer) RETURNS int
BEGIN
     declare exp integer;
     select year(now()) - year(hire_date) into exp from myemp where emp_id = eid;

RETURN exp;
END


CREATE DEFINER=`root`@`localhost` TRIGGER `bk_trg` AFTER UPDATE ON `books` FOR EACH ROW BEGIN
 insert into book_sales (bookid, title, qty_sold, tos)
 values(old.bookid, old.title, new.sales - old.sales, now());
END