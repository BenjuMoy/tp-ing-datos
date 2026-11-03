USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_ActualizarAccionCampania
    @idAccion INT,
    @idComuna INT,
    @idInteresObjetivo INT,
    @tipoAccion VARCHAR(60),
    @presupuestoAsignado DECIMAL(12,2)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM AccionCampania WHERE idAccion = @idAccion)
        BEGIN
            PRINT 'Error: la accion indicada no existe';
            RETURN;
        END;

        IF @tipoAccion IS NULL OR @tipoAccion = ''
        BEGIN
            PRINT 'Error: el tipo de accion no puede estar vacio';
            RETURN;
        END;

        IF @presupuestoAsignado < 0
        BEGIN
            PRINT 'Error: el presupuesto no puede ser negativo';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
        BEGIN
            PRINT 'Error: la comuna indicada no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteresObjetivo)
        BEGIN
            PRINT 'Error: el interes indicado no existe';
            RETURN;
        END;

        UPDATE AccionCampania
        SET idComuna = @idComuna,idInteresObjetivo = @idInteresObjetivo,tipoAccion = @tipoAccion,presupuestoAsignado = @presupuestoAsignado
        WHERE idAccion = @idAccion;

        PRINT 'Accion de campania actualizada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar la accion de campania';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;