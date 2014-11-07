-- Tables for Portfolio

create table users (
	username varchar(64) not null primary key,
	
	password varchar(64) not null,
	
	email 	varchar(256) not null unique
		constraint email_ok check (email like '%@%')
		
)

create table portfolios (
	portID number not null primary key,
	
	name varchar(64),
	
	numstocks number not null,
	
	useremail varchar(256) not null references users(email)
	
)
	
-- A list of all 

create table stocks (
	symb varchar(64) not null primary key,
	
	fullname varchar(256) not null
)
	
		
create table owned_stocks (
	symb varchar(64) not null primary key,
	
	count number not null,
	
	portId number not null references portfolios(portID)	
)

create table accounts (
	portID number not null references portfolios(portID),
	
	cash number not null
)




