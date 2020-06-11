set @no_pass = 40;

#call fill_stuff(@no_pass);

start transaction;
lock tables ba_booking write,
			ba_ticket as t read,
			ba_flight as f read;
call reserve(1, @no_pass, @book_num1);
commit;
unlock tables;


start transaction;
lock tables ba_contact write,
			ba_passenger write;
call add_passengers(1, @book_num1, '070-1234567', 'abc@def.gh');
commit;
unlock tables;

start transaction;
lock tables ba_booking as b read,
			ba_flight as f read,
			ba_payment write,
			ba_route as r read,
			ba_ticket as t read,
			ba_weekday as wd read,
			ba_weekly_flight as wf read;
call add_payment_details(@book_num1, 'Spongebob', 1, 1, 10, '12456789');
commit;
unlock tables;

start transaction;
lock tables ba_booking write,
			ba_booking as b read,
			ba_contact write,
			ba_flight as f read,
			ba_passenger write,
			ba_passenger as ps write,
			ba_payment write,
			ba_payment as p write,
			ba_route as r read,
			ba_ticket write,
			ba_ticket as t read,
			ba_weekday as wd read,
			ba_weekly_flight as wf read;
call confirm_booking(@book_num1);
commit;
unlock tables;