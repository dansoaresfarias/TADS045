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











