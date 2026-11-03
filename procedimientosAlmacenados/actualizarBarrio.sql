USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarBarrio
    @idBarrio INT,
    @idComuna INT,
    @nombre VARCHAR(80)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
        BEGIN
            PRINT 'error: el barrio indicado no existe';
            RETURN;
        END;

        IF @nombre IS NULL OR @nombre = ''
        BEGIN
            PRINT 'error: el nombre no puede estar vacio';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
        BEGIN
            PRINT 'Error: la comuna indicada no existe';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Barrio WHERE idComuna = @idComuna AND nombre = @nombre AND idBarrio <> @idBarrio)
        BEGIN
            PRINT 'error: ya existe un barrio con ese nombre en esa comuna';
            RETURN;
        END;

        UPDATE Barrio SET idComuna = @idComuna, nombre = @nombre WHERE idBarrio = @idBarrio;

        PRINT 'barrio actualizado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar el barrio';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;