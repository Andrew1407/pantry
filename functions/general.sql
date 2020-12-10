-- 1
create or replace function get_user_personal()
returns table (
  full_name text,
  email varchar(40),
  phone varchar(15),
  address varchar(100)
) as
$$
begin
  return query 
    select
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name, p.email, p.phone, p.address
      from persons p
      inner join users u
      on p.id = u.person_id;
end;
$$
language plpgsql;

-- 2
create or replace function get_user_account()
returns table (
  nickname varchar(40),
  reg_date timestamp,
  password varchar(60)
) as
$$
begin
  return query
    select u.nickname, u.reg_date, u.password from users u;
end;
$$
language plpgsql;

-- 3
create or replace function get_user_comments(
  uname varchar(40)
) returns table (
  rate int,
  post_date timestamp,
  entries text
) as
$$
begin
  return query
    select c.rate, c.post_date, c.entries
      from comments c
      inner join users u
      on c.user_id = u.id
      where u.nickname = uname;
end;
$$
language plpgsql;

-- 4
create or replace function get_user_comments_amount(
  uname varchar(40)
) returns table (
  nickname varchar(40),
  comments_amount int
) as
$$
begin
  return query
    select u.nickname, count(c.id) as comments_amount
      from comments c
      left join users u
      on c.user_id = u.id
      group by u.nickname
      having u.nickname = uname;
end;
$$
language plpgsql;

-- 5
create or replace function get_coments_amount()
 returns table (
  nickname varchar(40),
  comments_amount int
) as
$$
begin
  return query
    select u.nickname, count(c.id) as comments_amount
      from comments c
      left join users u
      on c.user_id = u.id
      group by u.nickname
      order by comments_amount desc;
end;
$$
language plpgsql;

-- 6
create or replace function set_user_email(
  search_name varchar(40),
  set_email varchar(40)
)
returns table (
  id int,
  email varchar(40)
) as
$$
begin
  return query
    update persons set email = set_email where persons.id = (
      select p.id
      from persons p
      inner join users u
      on p.id = u.person_id
      where u.nickname = search_name
    ) returning persons.id, persons.email;
end;
$$
language plpgsql;

-- 7
create or replace function get_user_goods(
  uname varchar(40)
) returns table (
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as 
$$
begin
  return query
    select g.name, g.category, g.weight, g.price, g.volume
      from goods g
      left join users u
      on g.user_id = u.id
      where u.nickname = uname;
end;
$$
language plpgsql;

-- 8
create or replace function get_item_storage_info(
  iname varchar(60),
  uname varchar(40)
) returns table (
  status varchar(8),
  fine numeric(10, 2),
  store_price numeric(10, 2),
  start_date timestamp,
  end_date timestamp 
) as
$$
begin
  return query
    select d.status, d.fine, d.store_price, d.start_date, d.end_date
      from storageData d
      left join goods g
      on d.item_id = g.id
      left join users u
      on u.id = g.user_id
      where g.name = iname and u.nickname = uname;
end;
$$
language plpgsql;

-- 9
create or replace function get_user_items_terms(
  uname varchar(40)
) returns table (
  storage_term interval,
  item_name varchar(60),
  id int
) as
$$
begin
  return query
    select (d.end_date - d.start_date) as storage_term, g.name as item_name, d.id
      from storageData d
      left join goods g
      on d.item_id = g.id
      left join users u
      on u.id = g.user_id
      where u.nickname = uname
      order by d.start_date desc;
end;
$$
language plpgsql;

-- 10
create or replace function set_user_item_fine(
  iname varchar(60),
  uname varchar(40)
) returns table (
  fine numeric(10, 2),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    update storageData set fine = 100 where item_id = (
      select g.id from goods g
      left join users u
      on u.id = g.user_id
      where u.nickname = 'plagHunter' and g.name = 'Скрипка'
    ) returning storageData.fine, storageData.start_date, storageData.end_date;
end;
$$
language plpgsql;

-- 11
create or replace function get_user_max_fine(
  uname varchar(40)
) returns table (
  item_name varchar(60),
  max_fine numeric(10, 2)
) as
$$
begin
  return query
    select a.name, a.fine_max from (
      select g.name, d.fine as fine_max
      from goods g
      left join users u
      on u.id = g.user_id
      left join storageData d
      on d.item_id = d.id
      where u.nickname = uname
      order by d.fine desc
    ) a limit 1;
end;
$$
language plpgsql;

-- 12
create or replace function get_user_goods_amount(
  uname varchar(40)
) returns table (
  name varchar(40),
  goods_amount bigint
) as
$$
begin
  return query
    select u.nickname, count(*) as goods_amount
      from goods g left join users u
      on g.user_id = u.id
      group by u.nickname
      having u.nickname = uname;
end;
$$
language plpgsql;

-- 13
create or replace function get_users_goods_amount()
returns table (
  name varchar(40),
  goods_amount bigint
) as
$$
begin
  return query
    select u.nickname, count(*) as goods_amount
      from goods g left join users u
      on g.user_id = u.id
      group by u.nickname
      order by goods_amount desc;
end;
$$
language plpgsql;

-- 14
create or replace function remove_user_item(
  iname varchar(60),
  uname varchar(40)
) returns table (
  id int,
  name varchar(60),
  user_id int
) as
$$
begin
  return query
    delete from goods g where g.name = iname and g.user_id = (
    select id from users where nickname = uname
  ) returning g.id, g.name, g.user_id;
end;
$$
language plpgsql;

-- 15
create or replace function get_workers_allowance()
returns table (
  full_name text,
  allowance numeric(7, 2),
  work varchar(25)
) as
$$
begin
  return query
    select
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      (w.wage - pos.person_salary) as allowance,
      pos.name as work
    from persons p
    right join workers w
    on w.person_id = p.id
    inner join positions pos
    on pos.id = w.position_id
    order by allowance;
end;
$$
language plpgsql;

-- 16
create or replace function get_workers_by_shift(
  search_shift int
)
returns table (
  full_name text,
  reg_date timestamp,
  work varchar(25)
) as
$$
begin
  return query
    select
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      w.reg_date,
      pos.name as work
    from persons p
    right join workers w
    on w.person_id = p.id
    inner join positions pos
    on pos.id = w.position_id
    where w.shift = 1
    order by full_name;
end;
$$
language plpgsql;
