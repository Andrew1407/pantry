-- 1
create or replace function add_user(
  _person_id int,
  _nickname varchar(40),
  _password varchar(60)
) returns table (
  id int,
  reg_date timestamp
) as
$$
begin
  return query
    insert into Users (person_id, nickname, password)
      values (_person_id, _nickname, _password)
    returning Users.id, Users.reg_date;
end;
$$
language plpgsql;

-- 2
create or replace function remove_user(
  _id int
) returns table (
  person_id int,
  nickname varchar(40)
) as
$$
begin
  return query
    delete from Users u where u.id = _id returning u.person_id, u.nickname;
end;
$$
language plpgsql;

-- 3
create or replace function get_all_users()
returns table (
  id int,
  full_name text,
  nickname varchar(40),
  email varchar(40),
  password varchar(60),
  reg_date timestamp
) as
$$
begin
  return query
    select
      u.id,
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      u.nickname,
      p.email,
      u.password,
      u.reg_date
    from Users u
    left join Persons p
    on u.person_id = p.id;
end;
$$
language plpgsql;

-- 4
create or replace function get_users_empty_email()
returns table (
  id int,
  person_id int,
  full_name text,
  nickname varchar(40),
  password varchar(60),
  reg_date timestamp
) as
$$
begin
  return query
    select
      u.id,
      p.id,
      concat(p.surname, ' ', p.name, ' ', p.second_name) as full_name,
      u.nickname,
      u.password,
      u.reg_date
    from Users u
    left join Persons p
    on u.person_id = p.id
    where p.email is null;
end;
$$
language plpgsql;
