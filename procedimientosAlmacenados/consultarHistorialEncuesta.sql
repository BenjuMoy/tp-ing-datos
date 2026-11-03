USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ConsultarHistorialEncuesta
    @idEncuesta INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM Encuesta WHERE idEncuesta = @idEncuesta)
        BEGIN
            PRINT 'error: la encuesta indicada no existe';
            RETURN;
        END;

        SELECT
            idHistorial,
            idEncuesta,
            fechaCambio,
            operacion,
            valorAnterior,
            valorNuevo
        FROM HistorialEncuesta
        WHERE idEncuesta = @idEncuesta ORDER BY fechaCambio DESC;

        PRINT 'Consulta del historial realizada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al consultar el historial';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;