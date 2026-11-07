USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarInteres
    @idInteres INT,
    @nombre VARCHAR(80),
    @idCategoria INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteres)
        BEGIN
            PRINT 'error: el interes indicado no existe';
            RETURN;
        END;

        IF @nombre IS NULL OR @nombre = ''
        BEGIN
            PRINT 'error: el nombre no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Interes WHERE nombre = @nombre AND idInteres <> @idInteres)
        BEGIN
            PRINT 'error: ya existe otro interes con ese nombre';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Categoria WHERE idCategoria = @idCategoria)
        BEGIN
            PRINT 'error: la categoria indicada no existe';
            RETURN;
        END;

        UPDATE Interes SET nombre = @nombre, idCategoria = @idCategoria WHERE idInteres = @idInteres;
        
        PRINT 'interes actualizado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar el interes';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;