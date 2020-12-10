-- 1
create or replace function add_person(
  _surname varchar(50),
  _name varchar(50),
  _second_name varchar(50),
  _address varchar(100),
  _email varchar(40),
  _phone varchar(15)
) returns table (
  id int,
  full_name text
) as
$$
begin
  return query
    insert into Persons (name, second_name, surname, email, phone, address)
      values (_name, _second_name, _surname, _email, _phone, _address)
    returning Persons.id, concat(surname, ' ', name, ' ', second_name) as full_name;
end;
$$
language plpgsql;

-- 2
create or replace function remove_person(
  _id int
) returns table (
  id int,
  full_name text
) as
$$
begin
  return query
    delete from Persons p where id = _id
      returning p.id, concat(surname, ' ', name, ' ', second_name) as full_name;
end;
$$
language plpgsql;

-- 3
create or replace function get_person(
  _id int
) returns table (
  full_name text,
  email varchar(40),
  phone varchar(15),
  address varchar(100)
) as
$$
begin
  return query
    select
      concat(surname, ' ', name, ' ', second_name) as full_name, p.email, p.phone, p.address
      from Persons p
      where p.id = _id;
end;
$$
language plpgsql;

-- 4
create or replace function update_person_full_name(
  _id int,
  _full_name text
) returns table (
  id int,
  full_name text
) as
$$
begin
  return query
    update Persons p set
      surname = split_part(_full_name, ' ', 1),
      name = split_part(_full_name, ' ', 2),
      second_name = split_part(_full_name, ' ', 3)
    where p.id = _id
    returning p.id, concat(surname, ' ', name, ' ', second_name) as full_name;
end;
$$
language plpgsql;

-- 5
create or replace function update_person_email_addr(
  _id int,
  _email varchar(40),
  _address varchar(100)
) returns table (
  id int,
  email varchar(40),
  address varchar(100)
) as
$$
begin
  return query
    update Persons p set
      p.email = _email,
      p.address = _address
    where p.id = _id
    returning p.id, p.email, p.address;
end;
$$
language plpgsql;
