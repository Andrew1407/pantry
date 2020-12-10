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
      returning StorageData.id, StorageData.start_date, StorageData.status, StorageData.fine;
end;
$$
language plpgsql;

-- 2
create or replace function remove_sdata(
  _id int
) returns table (
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
    delete from StorageData sd where id = _id
      returning sd.item_id, sd.store_price, sd.fine, sd.status, sd.start_date, sd.end_date;
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
    select sd.name, sd.id, sd.store_price, sd.fine, sd.status, sd.start_date, sd.end_date
    from StorageData sd
    where sd.item_id = _id;
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
    update StorageData set end_date = _edate where StorageData.id = _id
      returning StorageData.name, StorageData.id, StorageData.store_price, StorageData.fine, StorageData.status, StorageData.start_date, StorageData.end_date;
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
    update StorageData set fine = _fine where StorageData/id = _id
      returning StorageData.name, StorageData.id, StorageData.store_price, StorageData.fine, StorageData.status, StorageData.start_date, StorageData.end_date;
end;
$$
language plpgsql;

-- 7
create or replace function set_sdata_price(
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
    update StorageData set store_price = _sprice where StorageData.id = _id
      returning StorageData.name, StorageData.id, StorageData.store_price, StorageData.fine, StorageData.status, StorageData.start_date, StorageData.end_date;
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
    update StorageData set status = _status where StorageData.id = _id
      returning StorageData.name, StorageData.id, StorageData.store_price, StorageData.fine, StorageData.status, StorageData.start_date, StorageData.end_date;
end;
$$
language plpgsql;
