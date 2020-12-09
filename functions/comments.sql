-- 1
create or replace function add_comment(
  _user_id int,
  _entries text,
  _rate int
) returns table (
  id int,
  post_date timestamp
) as
$$
begin
  return query
    insert into Comments (user_id, entries, rate)
      values (_user_id, _entries, _rate) returning id, post_date;
end;
$$
language plpgsql;

-- 2
create or replace function remove_comment(
  _id int
) returns table (
  user_id int,
  entries text,
  rate int,
  post_date timestamp
) as
$$
begin
  return query
    delete from Comments where id = _id returning user_id, entries, rate, post_date;
end;
$$
language plpgsql;

-- 3
create or replace function set_comment_entries(
  _id int,
  _entries text
) returns table (
  id int,
  user_id int,
  rate int,
  post_date timestamp,
  entries text
) as
$$
begin
  update Comments set entries = _entries where id = _id
    returning id, user_id, rate, post_date, entries;
end;
$$
language plpgsql;

-- 4
create or replace function set_comment_rate(
  _id int,
  _rate int
) returns table (
  id int,
  user_id int,
  rate int,
  post_date timestamp,
  entries text
) as
$$
begin
  update Comments set rate = _rate where id = _id
    returning id, user_id, rate, post_date, entries;
end;
$$
language plpgsql;

-- 5
create or replace function get_user_comments(
  _id int
) returns table (
  id int,
  rate int,
  post_date timestamp,
  entries text
) as
$$
begin
  select id, rate, post_date, entries from Comments where user_id = _id;
end;
$$
language plpgsql;

-- 6
create or replace function get_comments_by_rate(
  _rate int
) returns table (
  id int,
  user_id int,
  post_date timestamp,
  entries text
) as
$$
begin
  select id, user_id, post_date, entries from Comments where rate = _rate;
end;
$$
language plpgsql;

-- 7
create or replace function get_comments_by_date(
  _post_date timestamp
) returns table (
  id int,
  user_id int,
  rate int,
  entries text
) as
$$
begin
  select id, user_id, rate, entries from Comments where post_date = _post_date;
end;
$$
language plpgsql;
