USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarComuna
    @idComuna INT,
    @nombre VARCHAR(80)
AS
BEGIN
    BEGIN TRY

        IF @nombre = ''
        BEGIN
            PRINT 'Error: El nombre de la comuna no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
        BEGIN
            PRINT 'Error: Ya existe una comuna con ese ID';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Comuna WHERE nombre = @nombre)
        BEGIN
            PRINT 'Error: Ya existe una comuna con ese nombre';
            RETURN;
        END;

        INSERT INTO Comuna (idComuna, nombre)
        VALUES (@idComuna, @nombre);

        PRINT 'Comuna insertada correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar la comuna';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO