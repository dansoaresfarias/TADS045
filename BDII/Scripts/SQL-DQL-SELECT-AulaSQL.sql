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
        









