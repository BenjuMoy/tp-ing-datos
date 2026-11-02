USE [UADEAnalytics]
GO

CREATE OR ALTER PROCEDURE sp_InsertarAccionCampania
	@idAccion INT,
	@idComuna INT,
	@idInteresObjetivo INT,
	@tipoAccion VARCHAR(60),
	@presupuestoAsignado DECIMAL(12,2)

AS
BEGIN
	BEGIN TRY
        IF @tipoAccion = ''
        BEGIN
            PRINT 'error: el tipo de accion no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM AccionCampania WHERE idAccion = @idAccion)
        BEGIN
            PRINT 'error: ya existe una accion con ese ID';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
        BEGIN
            PRINT 'error: la comuna indicada no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteresObjetivo)
        BEGIN
            PRINT 'error: el interes indicado no existe';
            RETURN;
        END;

        IF @presupuestoAsignado < 0
        BEGIN
            PRINT 'Error: El presupuesto no puede ser negativo';
            RETURN;
        END;

        INSERT INTO AccionCampania
        (idAccion, idComuna, idInteresObjetivo, tipoAccion, presupuestoAsignado)
        VALUES
        (@idAccion, @idComuna, @idInteresObjetivo, @tipoAccion, @presupuestoAsignado);

        PRINT 'Accion de campaña insertada';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la accion de campaña';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;