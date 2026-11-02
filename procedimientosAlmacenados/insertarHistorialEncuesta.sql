USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarHistorialEncuesta
    @idEncuesta INT,
    @operacion VARCHAR(10),
    @valorAnterior VARCHAR(250),
    @valorNuevo VARCHAR(250)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Encuesta WHERE idEncuesta = @idEncuesta)
        BEGIN
            PRINT 'error: laa encuesta indicada no existe';
            RETURN;
        END;

        IF @operacion = ''
        BEGIN
            PRINT 'Error: La operacion no puede estar vacia';
            RETURN;
        END;

        INSERT INTO HistorialEncuesta
        (idEncuesta, operacion, valorAnterior, valorNuevo)
        VALUES
        (@idEncuesta, @operacion, @valorAnterior, @valorNuevo);

        PRINT 'Historial de encuesta insertado ';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el historial de encuesta';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
