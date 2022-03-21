--Considere a tabela Produto com os seguintes atributos:
--Produto (Codigo | Nome | Valor)
--Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
--(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
--Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
--Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de cada transação de cada produto.

CREATE DATABASE db_loja
USE db_loja
GO
CREATE TABLE produto(
	codigo INT NOT NULL,
	nome VARCHAR(100),
	valor DECIMAL(7,2),
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE entrada(
	codigo_transacao INT NOT NULL,
	codigo_produto INT NOT NULL,
	quantidade INT,
	valor_total DECIMAL(7,2),
	PRIMARY KEY (codigo_transacao),
	FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
)
GO
CREATE TABLE saida(
	codigo_transacao INT NOT NULL,
	codigo_produto INT NOT NULL,
	quantidade INT,
	valor_total DECIMAL(7,2),
	PRIMARY KEY  (codigo_transacao),
	FOREIGN KEY(codigo_produto) REFERENCES produto(codigo)
)
CREATE PROCEDURE sp_insereproduto (@codigo_transacao INT, @codigo INT, @quantidade INT, @tabela VARCHAR(1), @saida VARCHAR(30) OUTPUT)
	AS 
	DECLARE @query VARCHAR(MAX), 
			@valor_total DECIMAL(7,2),
			@valor DECIMAL(7,2), 
			@erro VARCHAR(MAX)
	SET @valor_total = @quantidade * @valor
	BEGIN TRY
		IF(@tabela='e')
		BEGIN
			SET @query = 'INSERT INTO entrada VALUES ('+CAST(@codigo_transacao AS VARCHAR(5))
			+','+CAST(@codigo AS VARCHAR(5))+','+CAST(@quantidade AS VARCHAR(5))+','
			+CAST(@valor_total AS VARCHAR(9))+')'
			exec(@query)
			SET @saida = 'Compra realizada com sucesso'
		END
		ELSE
		BEGIN
			IF(@tabela='s')
			BEGIN
				SET @query = 'INSERT INTO saida VALUES ('+CAST(@codigo_transacao AS VARCHAR(5))
				+','+CAST(@codigo as varchar(5))+','+CAST(@quantidade as varchar(5))+','+CAST(@valor_total AS VARCHAR(9))+')'
				exec(@query)
				RAISERROR('Código Inválido', 16, 1)
			END
		END 
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		RAISERROR(@erro, 16,1)
	END CATCH

	DECLARE @saida1 VARCHAR(40)
	EXEC sp_insereproduto 1,1001,30,'e',@saida1 OUTPUT
	PRINT @saida1

	DECLARE @saida2 VARCHAR(40)
	EXEC sp_insereproduto 1,101,3,'e',@saida2 OUTPUT
	PRINT @saida2