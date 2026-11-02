USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarBarrio
    @idBarrio INT,
    @idComuna INT,
    @nombre VARCHAR(80)
AS
BEGIN
    BEGIN TRY

        IF @nombre = ''
        BEGIN
            PRINT 'Error: El nombre del barrio no puede estar vacio';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Comuna WHERE idComuna = @idComuna)
        BEGIN
            PRINT 'Error: La comuna indicada no existe';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
        BEGIN
            PRINT 'Error: Ya existe un barrio con ese ID';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Barrio WHERE idComuna = @idComuna AND nombre = @nombre)
        BEGIN
            PRINT 'Error: Ya existe un barrio con ese nombre en la comuna';
            RETURN;
        END;

        INSERT INTO Barrio (idBarrio, idComuna, nombre)
        VALUES (@idBarrio, @idComuna, @nombre);

        PRINT 'Barrio insertado correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el barrio';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;
GO
