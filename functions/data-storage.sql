-- 1
create or replace function add_sdata(
  _item_id int,
  _store_price numeric(10, 2),
  _end_date timestamp
) returns table (
  id int,
  start_date timestamp,
  status varchar(8),
  fine numeric(10, 2)
) as
$$
begin
  return query
    insert into StorageData (item_id, store_price, end_date)
      values (_item_id, _store_price, _end_date)
      returning id, start_date, status, fine;
end;
$$
language plpgsql;

-- 2
create or replace function remove_sdata(
  _id int
) returns table (
  item_id int,
  store_price numeric(10, 2),
  end_date timestamp,
  start_date timestamp,
  status varchar(8),
  fine numeric(10, 2)
) as
$$
begin
  return query
    delete from So where id = _id
      returning item_id, store_price, fine, status, end_date, start_date;
end;
$$
language plpgsql;

-- 3
create or replace function get_item_sdata(
  _id int
) returns table (
  name varchar(50),
  id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    select name, id, store_price, fine, status, start_date, end_date
    from StorageData
    where item_id = _id;
end;
$$
language plpgsql;

-- 4
create or replace function get_user_items_sdata(
  _id int
) returns table (
  name varchar(50),
  item_id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    select g.name, g.id, s.store_price, s.fine, s.status, s.start_date, s.end_date
    from StorageData s
    inner join Goods g
    on s.item_id = g.id
    where g.user_id = _id;
end;
$$
language plpgsql;

-- 5
create or replace function set_sdata_end_date(
  _id int,
  _edate timestamp
) returns table (
  name varchar(50),
  item_id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    update StorageData set end_date = _edate where id = _id
      returning name, id, store_price, fine, status, start_date, end_date;
end;
$$
language plpgsql;

-- 6
create or replace function set_sdata_fine(
  _id int,
  _fine numeric(10, 2)
) returns table (
  name varchar(50),
  item_id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    update StorageData set fine = _fine where id = _id
      returning name, id, store_price, fine, status, start_date, end_date;
end;
$$
language plpgsql;

-- 7
create or replace function set_sdata_prie(
  _id int,
  _sprice numeric(10, 2)
) returns table (
  name varchar(50),
  item_id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    update StorageData set store_price = _sprice where id = _id
      returning name, id, store_price, fine, status, start_date, end_date;
end;
$$
language plpgsql;

-- 8
create or replace function set_sdata_status(
  _id int,
  _status varchar(8)
) returns table (
  name varchar(50),
  item_id int,
  store_price numeric(10, 2),
  fine numeric(10, 2),
  status varchar(8),
  start_date timestamp,
  end_date timestamp
) as
$$
begin
  return query
    update StorageData set status = _status where id = _id
      returning name, id, store_price, fine, status, start_date, end_date;
end;
$$
language plpgsql;
