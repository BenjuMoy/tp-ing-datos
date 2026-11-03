USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarFranjaEtaria
    @idFranja INT,
    @descripcion VARCHAR(40)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'error: la franja etaria indicada no existe';
            RETURN;
        END;

        IF @descripcion IS NULL OR @descripcion = ''
        BEGIN
            PRINT 'error: la descripcion no puede estar vacia';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM FranjaEtaria WHERE descripcion = @descripcion AND idFranja <> @idFranja)
        BEGIN
            PRINT 'error: ya existe una franja con esa descripcion';
            RETURN;
        END;

        UPDATE FranjaEtaria SET descripcion = @descripcion WHERE idFranja = @idFranja;

        PRINT 'franja etaria actualizada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la franja etaria';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;