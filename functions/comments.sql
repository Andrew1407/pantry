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
    values (_user_id, _entries, _rate)
    returning Comments.id, Comments.post_date;
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
    delete from Comments c where id = _id returning c.user_id, c.entries, c.rate, c.post_date;
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
  return query
    update Comments set entries = _entries where Comments.id = _id
      returning Comments.id, Comments.user_id, Comments.rate, Comments.post_date, Comments.entries;
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
  return query
    update Comments set rate = _rate where Comments.id = _id
      returning Comments.id, Comments.user_id, Comments.rate, Comments.post_date, Comments.entries;
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
  return query
    select c.id, c.rate, c.post_date, c.entries from Comments c where c.user_id = _id;
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
  return query
    select c.id, c.user_id, c.post_date, c.entries
    from Comments c
    where c.rate = _rate;
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
  return query
    select c.id, c.user_id, c.rate, c.entries
    from Comments c
    where c.post_date = _post_date;
end;
$$
language plpgsql;
