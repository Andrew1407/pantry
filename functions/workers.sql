-- 1
create or replace function get_all_workers()
returns table (
  id int,
  full_name varchar(150),
  work varchar(25),
  reg_date timestamp,
  passport varchar(30),
  wage numeric(7, 2),
  shift int
) as
$$
begin
  return query
    select
      w.id,
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      ps.name,
      w.reg_date,
      w.passport,
      w.wage,
      w.shift
    from Workers w
    left join Persons p
    on w.person_id = p.id
    left join Positions ps
    on ps.id = w.position_id;
end;
$$
language plpgsql;

-- 2
create or replace function remove_worker(
  _id int
) returns table (
  shift int,
  wage numeric(7, 2),
  reg_date timestamp
) as
$$
begin
  return query
    delete from Workers where id = _id
    returning shift, wage, reg_date;
end;
$$
language plpgsql;

-- 3
create or replace function add_worker(
  _person_id int,
  _position_id int,
  _passport varchar(30),
  _wage numeric(7, 2),
  _shift int
) returns table (
  id int,
  reg_date timestamp
) as
$$
begin
  return query
    insert into Workers (person_id, position_id, passport, wage, shift)
      values (_person_id, _position_id, _passport, _wage, _shift)
    returning id, reg_date;
end;
$$
language plpgsql;

-- 4
create or replace function get_workers_by_shift(
  _shift int
) returns table (
  id int,
  full_name varchar(150),
  work varchar(25),
  reg_date timestamp,
  passport varchar(30),
  wage numeric(7, 2)
) as
$$
begin
  return query
    select
      w.id,
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      ps.name,
      w.reg_date,
      w.passport,
      w.wage
    from Workers w
    left join Persons p
    on w.person_id = p.id
    left join Positions ps
    on ps.id = w.position_id
    where w.shift = _shift;
end;
$$
language plpgsql;

-- 5
create or replace function get_workers_by_full_name(
  _full_name varchar(150)
) returns table (
  id int,
  work varchar(25),
  reg_date timestamp,
  passport varchar(30),
  wage numeric(7, 2),
  shift int
) as
$$
begin
  return query
    select w.id, ps.name, w.reg_date, w.passport, w.wage, w.shift
      from Workers w
      left join Persons p
      on w.person_id = p.id
      left join Positions ps
      on ps.id = w.position_id
      where concat(p.surname, ' ', p.name, ' ', p.second_name) = _full_name;
end;
$$
language plpgsql;

-- 6
create or replace function set_worker_wage(
  _id int,
  _wage numeric(7, 2)
) returns table (
  id int,
  wage numeric(7, 2)
) as
$$
begin
  return query
    update Workers set wage = _wage where id = _id returning id, wage;
end;
$$
language plpgsql;

-- 7
create or replace function set_worker_shift(
  _id int,
  _shift int
) returns table (
  id int,
  shift int
) as
$$
begin
  return query
    update Workers set shift = _shift where id = _id returning id, shift;
end;
$$
language plpgsql;
