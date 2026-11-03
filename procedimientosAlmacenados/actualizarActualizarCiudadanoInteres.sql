USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarCiudadanoInteres
    @idCiudadano INT,
    @idInteres INT,
    @nivelPrioridad INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM CiudadanoInteres WHERE idCiudadano = @idCiudadano AND idInteres = @idInteres)
        BEGIN
            PRINT 'error: la relacion entre ciudadano e interes no existe';
            RETURN;
        END;

        IF @nivelPrioridad < 1 OR @nivelPrioridad > 5
        BEGIN
            PRINT 'error: la prioridad debe estar entre 1 y 5';
            RETURN;
        END;

        UPDATE CiudadanoInteres SET nivelPrioridad = @nivelPrioridad WHERE idCiudadano = @idCiudadano AND idInteres = @idInteres;

        PRINT 'prioridad actualizada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la relacion';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;