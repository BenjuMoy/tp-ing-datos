USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarInteres
    @idInteres INT,
    @nombre VARCHAR(80),
    @idCategoria INT
AS
BEGIN
    BEGIN TRY

        IF @nombre IS NULL OR @nombre = ''
        BEGIN
            PRINT 'error: el nombre no puede estar vacio';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteres)
        BEGIN
            PRINT 'error: ya existe un interes con ese ID';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Categoria WHERE idCategoria = @idCategoria)
        BEGIN
            PRINT 'error: la categoria indicada no existe';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Interes WHERE nombre = @nombre)
        BEGIN
            PRINT 'error: ya existe un interes con ese nombre';
            RETURN;
        END;

        INSERT INTO Interes (idInteres, nombre, idCategoria)
        VALUES (@idInteres, @nombre, @idCategoria);

        PRINT 'Interes insertado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el interes';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;