-- Tables for Portfolio

create table port_users (
	username varchar(64) not null primary key,
	password varchar(64) not null,
	email 	varchar(256) not null unique
		constraint good_email  check (email like '%@%')
);

create table portfolios (
	portID number not null primary key,
	name varchar(64),
	numstocks number not null,
	username varchar(256) not null references port_users(username)
);
	
		
create table owned_stocks (
	symb varchar(64) not null,
	count number not null,
	portId number not null references portfolios(portID),
	primary key(symb, portID)	
);

create table accounts (
	portID number not null references portfolios(portID),
	cash number not null
);

create table new_data (
	symbol varchar(16) not null references cs339.stockssymbols(symbol),
	timestamp number not null,
	open number not null,
	high number not null,
	low number not null,
	close number not null,
	volume number not null,
	primary key(symbol, timestamp)
);

--Add admin and no user

insert into port_users values('admin', 'adminadmin', 'admin@iholdthepower.com');
insert into port_users values('anon', 'anonanon', 'anon@anon.com');

quit;
