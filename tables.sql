drop table if exists Persons;
drop table if exists Users;
drop table if exists Workers;
drop table if exists Positions;
drop table if exists Goods;
drop table if exists StorageData;
drop table if exists Comments;

-- PERSONS TABLE
create table Persons (
  id serial,
  address varchar(100) not null,
  email varchar(40) default null,
  phone varchar(15) not null,
  name varchar(50) not null,
  second_name varchar(50) not null,
  surname varchar(50) not null
);

alter table Persons add primary key (id);

-- WORKERS TABLE
create table Workers (
  id serial,
  person_id int not null,
  position_id int not null,
  reg_date timestamp default now(),
  passport varchar(30) not null,
  wage numeric(7, 2) not null,
  shift int not null
);

alter table Workers add primary key (id);

alter table Workers add constraint upassport unique (passport);

-- POSITIONS TABLE
create table Positions (
  id serial,
  person_salary numeric(7, 2) not null,
  name varchar(25) not null,
  max_workers int not null
);

alter table Positions add primary key (id);

alter table Workers
  add constraint workpersfk
  foreign key (person_id)
  references Persons (id)
  on update cascade;

alter table Workers
  add constraint workposfk
  foreign key (position_id)
  references Positions (id)
  on update cascade;

-- USERS TABLE
create table Users (
  id serial,
  person_id int not null,
  nickname varchar(40) not null,
  reg_date timestamp default now(),
  password varchar(60) not null
);

alter table Users add primary key (id);

alter table Users
  add constraint usersperfk
  foreign key (person_id)
  references Persons (id)
  on update cascade;

-- COMMENTS TABLE
create table Comments (
  id serial,
  user_id int not null,
  entries text not null,
  post_date timestamp default now(),
  rate int not null
);

alter table Comments add primary key (id);

alter table Comments
  add constraint commusersfk
  foreign key (user_id)
  references Users (id)
  on update cascade;

alter table Comments
  add constraint validrate
  check (rate <= 10);

-- GOODS TABLE
create table Goods (
  id serial,
  user_id int not null,
  name varchar(60) not null,
  category varchar(30) not null,
  weight numeric(5, 2) not null,
  price numeric(8, 2) not null,
  volume numeric(6,2) not null
);

alter table Goods add primary key (id);

alter table Goods
  add constraint goodsusersfk
  foreign key (user_id)
  references Users (id)
  on update cascade;

-- STORAGE_DATA TABLE
create table StorageData (
  id serial,
  item_id int not null,
  status varchar(8) default 'наявна',
  fine numeric(10, 2) default 0,
  store_price numeric(10, 2) not null,
  start_date timestamp default now(),
  end_date timestamp not null
);

alter table StorageData add primary key (id);

alter table StorageData
  add constraint goodsinfofk
  foreign key (item_id)
  references Goods (id)
  on update cascade
  on delete cascade;

alter table StorageData
  add constraint validstatus
  check (status = 'наявна' or status = 'відсутня');
