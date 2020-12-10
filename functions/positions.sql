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
      values (_person_salary, _name, _max_workers) returning Positions.id;
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
    delete from Positions p where p.id = _id returning p.name, p.person_salary, p.max_workers;
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
  return query
    select p.id, p.name, p.person_salary, p.max_workers from Positions p;
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
  return query
    select p.id, p.name, p.person_salary, p.max_workers 
    from Positions p
    where p.max_workers = _max_workers;
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
  select p.id, p.name, p.person_salary, p.max_workers
  from Positions p
  where p.person_salary = _person_salary;
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
  select p.id, p.name, p.person_salary, p.max_workers
  from Positions p
  where p.name = _name;
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
  update Positions set name = _name
  where Positions.id = _id
  returning Positions.id, Positions.name;
end;
$$
language plpgsql;
