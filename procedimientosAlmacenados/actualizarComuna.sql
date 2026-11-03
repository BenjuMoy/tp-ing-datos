USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarComuna
	@idComuna INT,
	@nombre VARCHAR(80)
AS
BEGIN
	BEGIN TRY

		IF NOT EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
		BEGIN
			PRINT 'error: la couman no existe';
			RETURN
		END;

		IF @nombre IS NULL
		BEGIN
			PRINT 'error: el nombre no puede estar vacio';
			RETURN
		END;

		IF EXISTS (SELECT 1 FROM Comuna WHERE nombre = @nombre AND idComuna <> @idComuna)
		BEGIN
			PRINT 'error: ya existe una comuna con ese nombre';
			RETURN;
		END;

		UPDATE Comuna SET nombre = @nombre WHERE idComuna = @idComuna;
		PRINT 'se actualizo la comuna';
	
	END TRY
	BEGIN CATCH
		PRINT 'Error al actualizar la comuna';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;