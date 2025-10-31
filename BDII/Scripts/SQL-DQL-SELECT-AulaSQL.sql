-- SQL - DQL - Select
select * from funcionario;

select nome, cpf, carteiraTrab, dataNasc, genero, estadoCivil,
	email, chavePix, cargaHoraria, salario
    from funcionario;

select nome, cpf, carteiraTrab, dataNasc, genero, estadoCivil,
	email, chavePix, cargaHoraria, salario
    from funcionario
		order by nome;

select nome, cpf, carteiraTrab, dataNasc, genero, estadoCivil,
	email, chavePix, cargaHoraria, salario
    from funcionario
		order by salario desc;

select nome, cpf, carteiraTrab, dataNasc, genero, estadoCivil,
	email, chavePix, cargaHoraria, salario
    from funcionario
		where salario between 2500 and 3500
			order by salario desc;

-- https://dev.mysql.com/doc/refman/8.4/en/string-functions.html#function_upper
-- https://dev.mysql.com/doc/refman/8.4/en/string-functions.html#function_replace
-- https://dev.mysql.com/doc/refman/8.4/en/date-and-time-functions.html#function_date-format
-- https://dev.mysql.com/doc/refman/8.4/en/string-functions.html#function_concat
select upper(nome) "Funcionário", 
	replace(replace(cpf, ".", ""), "-", "") as "CPF", 
    carteiraTrab "Carteira de Trabalho", 
    date_format(dataNasc, "%d/%m/%Y") "Data de Nascimento", 
    replace(replace(genero, "Feminino", "F"), "Masculino", "M") "Gênero", 
    ucase(estadoCivil) "Estado Civil",
	email "E-mail", chavePix "Chave PIX", 
    concat(cargaHoraria, "h") "Carga Horária", 
    concat("R$ ",format(salario, 2, 'de_DE')) "Salário"
    from funcionario
		order by nome;

select nome "Dependente", 
	replace(replace(cpf, '.', ''), '-', '') "CPF do Dependente", 
    timestampdiff(year, dataNasc, now()) "Idade", 
	upper(parentesco) "Parentesco"
	from dependente
		order by idade desc;

-- join implicito
select d.nome "Dependente", 
	replace(replace(d.cpf, '.', ''), '-', '') "CPF do Dependente", 
    timestampdiff(year, d.dataNasc, now()) "Idade", 
	upper(d.parentesco) "Parentesco", f.nome "Responsável"
	from dependente d, funcionario f
		order by d.nome;

-- join implicito
select d.nome "Dependente", 
	replace(replace(d.cpf, '.', ''), '-', '') "CPF do Dependente", 
    timestampdiff(year, d.dataNasc, now()) "Idade", 
	upper(d.parentesco) "Parentesco", f.nome "Responsável"
	from dependente d, funcionario f
		where d.funcionario_cpf = f.cpf
			order by d.nome;

-- join explicito            
select d.nome "Dependente", 
	replace(replace(d.cpf, '.', ''), '-', '') "CPF do Dependente", 
    timestampdiff(year, d.dataNasc, now()) "Idade", 
	upper(d.parentesco) "Parentesco", f.nome "Responsável",
    e.cidade "Cidade"
	from dependente d
    inner join funcionario f on f.cpf = d.funcionario_cpf
    inner join endereco e on e.funcionario_cpf = f.cpf
			order by d.nome;

select upper(f.nome) "Funcionário", 
	replace(replace(f.cpf, ".", ""), "-", "") as "CPF", 
    f.carteiraTrab "Carteira de Trabalho", 
    date_format(f.dataNasc, "%d/%m/%Y") "Data de Nascimento", 
    replace(replace(f.genero, "Feminino", "F"), "Masculino", "M") "Gênero", 
    coalesce(group_concat(distinct d.nome order by d.nome ASC separator ", "), '--') "Dependente",
    ucase(f.estadoCivil) "Estado Civil",
	f.email "E-mail", 
    group_concat(distinct t.numero separator ", ") "Telefone", 
    f.chavePix "Chave PIX", 
    concat(f.cargaHoraria, "h") "Carga Horária", 
    concat("R$ ",format(f.salario, 2, 'de_DE')) "Salário",
    e.bairro "Bairro", e.Cidade "Cidade"
    from funcionario f
    inner join endereco e on e.funcionario_cpf = f.cpf
    inner join telefone t on t.funcionario_cpf = f.cpf
    left join dependente d on d.funcionario_cpf = f.cpf
		group by f.cpf
			order by f.nome;

select func.nome "Funcionário", func.cpf "CPF",
	func.chavePix "Chave PIX",
	concat(func.cargahoraria, 'h') "Carga Horária",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário",
    crg.nome "Cargo", dpt.nome "Departamento", grt.nome "Gerente"
		from funcionario func
        inner join trabalhar trb on trb.funcionario_cpf = func.cpf
        inner join cargo crg on crg.cbo= trb.cargo_cbo
        inner join departamento dpt on dpt.idDepartamento = trb.Departamento_idDepartamento
        left join funcionario grt on grt.cpf = dpt.gerente_cpf
			where trb.dataFim is null
				order by func.nome;
-- data Oc, gravidade, desc, funcionario
select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
	upper(gravidade) "Gravidade",
    descricao "Descrição",
    nome "Funcionário"
	from ocorrenciainterna
	inner join funcionario on funcionario_cpf = cpf
		order by datahora desc;

select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
	upper(gravidade) "Gravidade",
    descricao "Descrição",
    nome "Funcionário"
	from ocorrenciainterna
	inner join funcionario on funcionario_cpf = cpf
		where gravidade like "Alta"
union
select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
	upper(gravidade) "Gravidade",
    descricao "Descrição",
    nome "Funcionário"
	from ocorrenciainterna
	inner join funcionario on funcionario_cpf = cpf
		where gravidade like "Média"
union
select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
	upper(gravidade) "Gravidade",
    descricao "Descrição",
    nome "Funcionário"
	from ocorrenciainterna
	inner join funcionario on funcionario_cpf = cpf
		where gravidade like "Baixa";

select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
	upper(gravidade) "Gravidade",
    descricao "Descrição",
    nome "Funcionário"
	from ocorrenciainterna
	inner join funcionario on funcionario_cpf = cpf
		where gravidade like "Alta"
			order by dataHora desc;
            
create view oiAlta as
	select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
		upper(gravidade) "Gravidade",
		descricao "Descrição",
		nome "Funcionário"
		from ocorrenciainterna
		inner join funcionario on funcionario_cpf = cpf
			where gravidade like "Alta"
				order by dataHora desc;

create view oiMedia as
	select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
		upper(gravidade) "Gravidade",
		descricao "Descrição",
		nome "Funcionário"
		from ocorrenciainterna
		inner join funcionario on funcionario_cpf = cpf
			where gravidade like "Média"
				order by dataHora desc;

create view oiBaixa as
	select date_format(dataHora, '%d/%m/%Y - %h:%i') "Data da Ocorrência",
		upper(gravidade) "Gravidade",
		descricao "Descrição",
		nome "Funcionário"
		from ocorrenciainterna
		inner join funcionario on funcionario_cpf = cpf
			where gravidade like "Baixa"
				order by dataHora desc;

select * from oialta
union 
select * from oimedia
union
select * from oibaixa
	order by `Data da Ocorrência` desc;

-- Ano de Referência | Data Início (03/10/2025) | Data Fim (03/10/2025) | 
-- Quantidade de Dias | Valor (R$ 1.300,56) | Funcionário (nome)
-- Ordenado pelo ano de referência de forma do ano mais recente ao mais antigo
select anoRef "Ano de Referência", 
	date_format(datainicio, '%d/%m/%Y') "Data Início",
    date_format(date_add(datainicio, interval qtdDias day), '%d/%m/%Y') "Data Fim",
    concat(qtdDias, " dias") "Quantidade de Dias",
    concat("R$ ", format(valor, 2, 'de_DE')) "Valor a Receber",
    nome "Funcionário"
	from ferias
	inner join funcionario on cpf = funcionario_cpf
		order by anoRef desc;

select func.nome "Funcionário", count(fer.idFerias) "Quantidade de Férias"
	from funcionario func
    left join ferias fer on fer.Funcionario_CPF = func.CPF
		group by func.cpf
			order by func.nome;

select func.nome "Funcionário", count(fer.idFerias) "Quantidade de Férias"
	from funcionario func
    inner join ferias fer on fer.Funcionario_CPF = func.CPF
		group by func.cpf
			order by func.nome;

select func.nome "Funcionário", count(fer.idFerias) "Quantidade de Férias"
	from funcionario func
    left join ferias fer on fer.Funcionario_CPF = func.CPF
		where fer.`status` in ("Aprovado", "Em andamento")
			group by func.cpf
union
select func.nome "Funcionário", count(fer.idFerias) "Quantidade de Férias"
	from funcionario func
    left join ferias fer on fer.Funcionario_CPF = func.CPF
		group by func.cpf
			having count(fer.idFerias) = 0
				order by `Funcionário`;

-- Auxílio Creche --> 180 por filho menor que 7 anos!
select func.nome "Funcionário", func.cpf "CPF",
	count(dep.cpf) "Quantidade de Dependentes"
    from funcionario func
    left join dependente dep on dep.Funcionario_CPF = func.CPF
		group by func.cpf
			order by func.nome;

select func.nome "Funcionário", func.cpf "CPF",
	count(dep.cpf) * 180 "Auxílio Creche"
    from funcionario func
    left join dependente dep on dep.Funcionario_CPF = func.CPF
		where timestampdiff(year, dep.dataNasc, now()) < 7 
			group by func.cpf
				order by func.nome;
                
create view funcAuxCreche2 as
	select func.cpf "cpf",
		count(dep.cpf) * 180 "auxCreche"
		from funcionario func
		left join dependente dep on dep.Funcionario_CPF = func.CPF
			where timestampdiff(year, dep.dataNasc, now()) < 7 
				group by func.cpf
					order by func.nome;

-- Funcionário, CPF, Carga Horária, Auxílio Creche, Salário
select func.nome "Funcionário", func.cpf "CPF", 
	concat(func.cargaHoraria, 'h') "Carga Horária",
    concat("R$ ", format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário"
    from funcionario func
	left join funcAuxCreche fac on fac.cpf = func.cpf
		order by func.nome;


select upper(func.nome) "Funcionário", func.cpf "CPF", 
	concat(func.cargaHoraria, 'h') "Carga Horária",
    case func.genero when "Feminino" then "F"
					when "Masculino" then "M" 
					else "Não informado" 
    end"Gênero",
    concat("R$ ", format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    case when timestampdiff(year, func.dataNasc, now()) < 25 
				then concat("R$ ", format(150, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 24 and 34
				then concat("R$ ", format(250, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 34 and 45
				then concat("R$ ", format(350, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 44 and 55
				then concat("R$ ", format(450, 2, 'de_DE'))
		else concat("R$ ", format(600, 2, 'de_DE'))
	end "Auxílio Saúde",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário"
    from funcionario func
	left join funcAuxCreche fac on fac.cpf = func.cpf
		order by func.nome;

select round(7.361, 1);

select round(7.341, 1);

select truncate(7.399, 1);

select mod(5, 2);

select sysdate();

select date_add(sysdate(), interval -7 day);

select date_add(sysdate(), interval 7 day);

select date_add(sysdate(), interval 50 minute);

select now(), date_add(sysdate(), interval 30 day);

select date_format(now(), '%d/%m/%y');

select avg(salario) from funcionario;

select round(avg(salario),2) from funcionario;

select max(salario) from funcionario;

select min(salario) from funcionario;

select func.CPF, func.nome, count(dep.cpf) 
	from dependente dep
	inner join funcionario func on func.CPF = dep.Funcionario_CPF
		group by Funcionario_CPF
			order by func.nome;

select func.CPF, func.nome, count(dep.cpf) 
	from funcionario func
	left join dependente dep on func.CPF = dep.Funcionario_CPF
		group by func.cpf
			order by func.nome;

select dep.nome "Departamento", 
	concat("R$ ", format(sum(func.salario), 2, 'de_DE')) "Custo Salarial",
    count(func.cpf) "Quantidade de Funcionários",
    concat("R$ ", format(avg(func.salario), 2, 'de_DE')) "Média Salarial"
	from trabalhar trb
	inner join funcionario func on func.CPF = trb.Funcionario_CPF
    inner join departamento dep on dep.idDepartamento = trb.Departamento_idDepartamento
		group by dep.idDepartamento
			order by avg(func.salario) desc;

select dep.nome "Departamento", 
	concat("R$ ", format(sum(func.salario), 2, 'de_DE')) "Custo Salarial",
    count(func.cpf) "Quantidade de Funcionários",
    concat("R$ ", format(avg(func.salario), 2, 'de_DE')) "Média Salarial"
	from trabalhar trb
	inner join funcionario func on func.CPF = trb.Funcionario_CPF
    inner join departamento dep on dep.idDepartamento = trb.Departamento_idDepartamento
			group by dep.idDepartamento
				having sum(func.salario) >= 10000
					order by `Custo Salarial` desc;


select dep.nome "Departamento", 
	concat("R$ ", format(sum(func.salario), 2, 'de_DE')) "Custo Salarial",
    count(func.cpf) "Quantidade de Funcionários",
    concat("R$ ", format(avg(func.salario), 2, 'de_DE')) "Média Salarial"
	from trabalhar trb
	inner join funcionario func on func.CPF = trb.Funcionario_CPF
    inner join departamento dep on dep.idDepartamento = trb.Departamento_idDepartamento
			group by dep.idDepartamento
				having sum(func.salario) >= 10000
					order by 4 desc;

select avg(salario) from funcionario;
                    
select upper(func.nome) "Funcionário", func.cpf "CPF", 
	concat(func.cargaHoraria, 'h') "Carga Horária",
    case func.genero when "Feminino" then "F"
					when "Masculino" then "M" 
					else "Não informado" 
    end"Gênero",
    concat("R$ ", format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    case when timestampdiff(year, func.dataNasc, now()) < 25 
				then concat("R$ ", format(150, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 24 and 34
				then concat("R$ ", format(250, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 34 and 45
				then concat("R$ ", format(350, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 44 and 55
				then concat("R$ ", format(450, 2, 'de_DE'))
		else concat("R$ ", format(600, 2, 'de_DE'))
	end "Auxílio Saúde",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário"
    from funcionario func
	left join funcAuxCreche fac on fac.cpf = func.cpf
		where salario <= (select avg(salario) from funcionario)
			order by func.nome;
            
select upper(func.nome) "Funcionário", func.cpf "CPF", 
	concat(func.cargaHoraria, 'h') "Carga Horária",
    case func.genero when "Feminino" then "F"
					when "Masculino" then "M" 
					else "Não informado" 
    end"Gênero",
    concat("R$ ", format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    case when timestampdiff(year, func.dataNasc, now()) < 25 
				then concat("R$ ", format(150, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 24 and 34
				then concat("R$ ", format(250, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 34 and 45
				then concat("R$ ", format(350, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 44 and 55
				then concat("R$ ", format(450, 2, 'de_DE'))
		else concat("R$ ", format(600, 2, 'de_DE'))
	end "Auxílio Saúde",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário"
    from funcionario func
	left join funcAuxCreche fac on fac.cpf = func.cpf
		where salario = (select max(salario) from funcionario)
			order by func.nome;
            
select upper(func.nome) "Funcionário", func.cpf "CPF", 
	concat(func.cargaHoraria, 'h') "Carga Horária",
    case func.genero when "Feminino" then "F"
					when "Masculino" then "M" 
					else "Não informado" 
    end"Gênero",
    concat("R$ ", format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    case when timestampdiff(year, func.dataNasc, now()) < 25 
				then concat("R$ ", format(150, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 24 and 34
				then concat("R$ ", format(250, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 34 and 45
				then concat("R$ ", format(350, 2, 'de_DE'))
		when timestampdiff(year, func.dataNasc, now()) between 44 and 55
				then concat("R$ ", format(450, 2, 'de_DE'))
		else concat("R$ ", format(600, 2, 'de_DE'))
	end "Auxílio Saúde",
    concat("R$ ", format(func.salario, 2, 'de_DE')) "Salário"
    from funcionario func
	left join funcAuxCreche fac on fac.cpf = func.cpf
		where salario = (select min(salario) from funcionario)
			order by func.nome;

update funcionario, 
	(select func.cpf from funcionario func
	inner join trabalhar trb on trb.Funcionario_CPF = func.cpf
	inner join cargo crg on crg.CBO = trb.Cargo_CBO
    where crg.nome like "Segurança%" or crg.nome like "Auxiliar%") as crgFunc
	set cargaHoraria = 36
		where funcionario.cpf = crgFunc.cpf;

-- https://dev.mysql.com/doc/refman/8.4/en/create-procedure.html
-- https://dev.mysql.com/doc/refman/8.4/en/declare-local-variable.html
            
delimiter $$ 
create function calcValeAlim(ch int)
	returns decimal(6,2) deterministic 
    begin
		declare diariaVA decimal(5,2) default 15.0;
        if (ch = 36) 
			then return 22 * diariaVA * 2;
		else 
			return 22 * diariaVA;
		end if;
    end $$
delimiter ;

delimiter $$
create function calcAuxSaude(dn date)
	returns decimal(6,2) deterministic
    begin
		declare idade int;
        set idade = timestampdiff(year, dn, now());
        if (idade < 25) 
			then return 150;
		elseif (idade < 35)
			then return 250;
		elseif (idade < 45)
			then return 350;
		elseif (idade < 55)
			then return 450;
		else 
			return 600;
        end if;
    end $$
delimiter ;

delimiter $$
create function calcValeTrans(pCPF varchar(14))
	returns decimal(5,2) deterministic
    begin
		declare c varchar(60);
        declare s decimal(7,2);
        declare VT decimal(5,2) default 0.0;
        
        select cidade into c from endereco where Funcionario_CPF = pCPF;
        select salario into s from funcionario where cpf = pCPF;
        
        if (c = "Recife") 
			then set VT = 22 * 4.3 * 2 - 0.06 * s;
		else 
			set VT = 22 * 4.3 * 4 - 0.06 * s;
		end if;
        
        if (VT > 0)
			then return VT;
		else 
			return 0.0;
		end if;
    end $$
delimiter ;

delimiter $$
create function calcINSS(salario decimal(7,2))
	returns decimal(6,2) deterministic
    begin
		if (salario <= 1518) 
			then return salario * 0.075;
		elseif (salario <= 2793.88)
			then return salario * 0.09;
		elseif (salario <= 4190.83)
			then return salario * 0.12;
		elseif (salario <= 8157.41)
			then return salario * 0.14;
		else 
			return 8157.41 * 0.14;
		end if;
    end $$
delimiter ;

delimiter $$
create function calcIRRF(salario decimal(7,2))
	returns decimal(6,2) deterministic
    begin
		if (salario <= 2259.20) 
			then return 0.0;
		elseif (salario <= 2826.65)
			then return salario * 0.075;
		elseif (salario <= 3751.05)
			then return salario * 0.15;
		elseif (salario <= 4664.68)
			then return salario * 0.225;
		else 
			return salario * 0.275;
		end if;
    end $$
delimiter ;

select upper(func.nome) "Funcionário",
	replace(replace(func.cpf, '.', ''), '-', '') "CPF",
    func.chavePIX "Chave PIX",
    concat(func.cargaHoraria, 'h') "Carga Horária",
    concat('R$ ', format(func.salario, 2, 'de_DE')) "Salário Bruto",
    concat('R$ ', format(calcValeAlim(func.cargaHoraria), 2, 'de_DE')) "Vale Alimentação",
    concat('R$ ', format(coalesce(fac.auxCreche, 0), 2, 'de_DE')) "Auxílio Creche",
    concat('R$ ', format(calcAuxSaude(func.dataNasc), 2, 'de_DE')) "Auxílio Saúde",
    concat('R$ ', format(calcValeTrans(func.cpf), 2, 'de_DE')) "Vale Transporte",  
    concat('- R$ ', format(calcINSS(func.salario), 2, 'de_DE')) "INSS",
    concat('- R$ ', format(calcIRRF(func.salario), 2, 'de_DE')) "IRRF",
    concat('R$ ', format(func.salario + calcValeAlim(func.cargaHoraria) + 
    coalesce(fac.auxCreche, 0) + calcAuxSaude(func.dataNasc) +
    calcValeTrans(func.cpf) - calcINSS(func.salario) -
    calcIRRF(func.salario), 2, 'de_DE')) "Salário Líquido"
	from funcionario func
    left join funcauxcreche fac on fac.cpf = func.CPF
		order by func.nome;



















