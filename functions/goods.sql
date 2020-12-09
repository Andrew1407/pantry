-- 1
create or replace function add_item(
  _user_id int,
  _name varchar(60),
  _category varchar(30),
  _weight numeric(5, 2),
  _price numeric(8, 2),
  _volume numeric(6,2)
) returns table (
  id int
) as
$$
begin
  return query
    insert into Goods (user_id, name, category, weight, price, volume)
      values (_user_id, _name, _category, _weight, _price, _volume) returning id;
end;
$$
language plpgsql;

-- 2
create or replace function remove_item(
  _id int
) returns table (
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    delete from Goods where id = _id
      returning user_id, name, category, weight, price, volume;
end;
$$
language plpgsql;

-- 3
create or replace function set_item_category(
  _id int,
  _category varchar(30)
) returns table (
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    update Goods set category = _category where id = _id
      returning user_id, name, category, weight, price, volume;
end;
$$
language plpgsql;

-- 4
create or replace function set_item_name(
  _id int,
  _name varchar(30)
) returns table (
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    update Goods set name = _name where id = _id
      returning user_id, name, category, weight, price, volume;
end;
$$
language plpgsql;

-- 5
create or replace function set_item_price(
  _id int,
  _price numeric(8, 2)
) returns table (
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    update Goods set price = _price where id = _id
      returning user_id, name, category, weight, price, volume;
end;
$$
language plpgsql;

-- 6
create or replace function set_item_weight_volume(
  _id int,
  _weight numeric(5, 2),
  _volume numeric(6, 2)
) returns table (
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6, 2)
) as
$$
begin
  return query
    update Goods set weight = _weight, volume = _volume where id = _id
      returning user_id, name, category, weight, price, volume;
end;
$$
language plpgsql;

-- 7
create or replace function get_user_items_avg_price(
  _id int
) returns table (
  id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    select user_id, avg(price) from Goods group by user_id having user_id = _id;
end;
$$
language plpgsql;

-- 8
create or replace function get_items_max_volume_limited(
  _limit int
)
returns table (
  id int,
  user_id int,
  name varchar(60),
  category varchar(30),
  weight numeric(5, 2),
  price numeric(8, 2),
  volume numeric(6,2)
) as
$$
begin
  return query
    select * from Goods order by volume desc limit _limit;
end;
$$
language plpgsql;
