-- SQL - DDL - Alter

alter table uh 
	add column precoDiaria decimal(6,2) unsigned zerofill not null;
    
alter table uh
	drop column precoDiaria;

alter table uh
	change column precoDiaria precoDiaria decimal(7,2) unsigned 
		zerofill not null after nome;



		