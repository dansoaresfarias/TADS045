-- SQL - DML - Insert
desc funcionario;
desc uh;

insert into funcionario (cpf, nome, datanasc, genero, estadoCivil,
	email, carteiratrab, cargahoraria, salario, chavePix, 
    `status`)
    value ("987.654.876-99", "Gustavo Koichi", '1994-06-27',
    "Masculino", "Solteiro", "gustavo.dorama@gmail.com", 
	"9876789-00", 44, 1890, "gustavo.dorama@gmail.com", 1);
    
insert into funcionario (cpf, nome, datanasc, genero, estadoCivil,
	email, carteiratrab, cargahoraria, salario, chavePix, 
    `status`)
    values ("321.456.768-99", "Maria Vitória Barboza", '2006-12-05',
    "Feminino", "Solteira", "maria.vit.barboza@gmail.com", 
	"1236789-00", 40, 3000, "321.456.768-99", 1),
    
    ("345.567.987-88", "Arthur Bem", '1993-06-28',
    "Masculino", "Solteiro", "bem10@gmail.com", 
	"3456789-00", 40, 3590, "345.567.987-88", 1),
    
    ("111.222.444-99", "Luciana Borges", '1998-12-11',
    "Feminino", "Casada", "luciana.borges@gmail.com", 
	"1116789-00", 40, 2890, "luciana.borges@gmail.com", 1);    

insert into endereco
	values ("111.222.444-99", "PE", "Jaboatão dos Guararapes", "Piedade",
    "Rua da Alegria", 13, null, "50070-090"),
    ("321.456.768-99", "PE", "Recife", "Santo Amaro",
    "Rua da Aurora", 1071, "Ap 1403", "50400-090"),
    ("345.567.987-88", "PE", "Recife", "Vázea",
    "Rua da Feira", 145, "Ap 1204", "50040-090"),
    ("987.654.876-99", "PE", "Recife", "Afogados",
    "Av. Estrada dos Remédios", 234, "Ap 304", "50090-080");

-- SQL - DML - Update
update endereco
	set rua = "Rua Antônio Valdevino Costa", comp = null
		where funcionario_cpf = "987.654.876-99";

update funcionario
	set salario = salario * 1.2
		where salario <= 2000;

SET SQL_SAFE_UPDATES = 0;

update funcionario
	set fg = 500
		where genero = "Feminino" and dataNasc <= '2005-09-12';

update funcionario
	set fg = 1000, salario = 5000, estadoCivil = "Viúva"
		where nome like "Renata Santos";
        
update funcionario
	set salario = salario * 1.05;

-- Bom problema...    
update funcionario
	set fg = fg + 300
		where salario >= 1500 and salario <= 2500;

update funcionario
	set fg = 0
		where fg is null;

alter table funcionario
	change column fg fg decimal(6,2) unsigned null default 0.0;

insert into funcionario (CPF, nome, dataNasc, genero, estadoCivil,
	email, carteiraTrab, cargaHoraria, salario, chavePIX, `status`)
    value ("108.801.000-33", "Priscila Vivida", '1996-04-16', 
		"Feminino", "Casada", "priscila.vivida@gmail.com", 
        "321886-98", 40, 3000.30, "108.801.000-33", 1);
        
update funcionario
	set fg = fg + 300
		where salario between 1500 and 2500;
	
update funcionario
	set fg = 500
		where nome like "%Lima%" or nome like "%Silva";
        
update funcionario
	set fg = fg + 150
		where estadoCivil like "_olteir_";

update funcionario
	set salario = 5000
		where genero = "Feminino" and (salario <= 3000 or fg = 0.0);

-- SQL - DML - Delete

delete from funcionario
	where nome like "Aline%";

delete from funcionario
	where salario > 5000;
    
delete from funcionario
	where estadoCivil like "Solteir%";
    
-- SQL - DTL
start transaction;
delete from funcionario; -- cabuloso
commit;
rollback;



