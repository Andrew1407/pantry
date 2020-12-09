-- 1
create or replace function add_position(
  _name varchar(25),
  _person_salary numeric(7, 2),
  _max_workers int
) returns table (
  id int
) as
$$
begin
  return query
    insert into Positions (person_salary, name, max_workers)
      values (_person_salary, _name, _max_workers) returning id;
end;
$$
language plpgsql;

-- 2
create or replace function remove_position(
  id int
) returns table (
  name varchar(25),
  person_salary numeric(7, 2),
  max_workers int
) as
$$
begin
  return query
    delete from Positions where id = _id returning name, person_salary, max_workers;
end;
$$
language plpgsql;

-- 3
create or replace function get_all_positions()
returns table (
  id int,
  name varchar(25),
  person_salary numeric(7, 2),
  max_workers int
) as
$$
begin
  select * from Positions;
end;
$$
language plpgsql;

-- 4
create or replace function get_position_by_max_workers(
  _max_workers int
) returns table (
  id int,
  name varchar(25),
  person_salary numeric(7, 2),
  max_workers int
) as
$$
begin
  select * from Positions where max_workers = _max_workers;
end;
$$
language plpgsql;

-- 5
create or replace function get_position_by_salary(
  _person_salary numeric(7, 2)
) returns table (
  id int,
  name varchar(25),
  person_salary numeric(7, 2),
  max_workers int
) as
$$
begin
  select * from Positions where person_salary = _person_salary;
end;
$$
language plpgsql;

-- 6
create or replace function get_position_by_name(
  _name varchar(25)
) returns table (
  id int,
  name varchar(25),
  person_salary numeric(7, 2),
  max_workers int
) as
$$
begin
  select * from Positions where name = _name;
end;
$$
language plpgsql;

-- 7
create or replace function set_position_name(
  _id int,
  _name varchar(25)
) returns table (
  id int,
  name varchar(25)
) as
$$
begin
  update Positions set name = _name where id = _id returning id, name;
end;
$$
language plpgsql;
