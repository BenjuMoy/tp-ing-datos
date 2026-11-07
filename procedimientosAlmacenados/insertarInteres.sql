USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarInteres
    @idInteres INT,
    @nombre VARCHAR(80),
    @categoria VARCHAR(50)
AS
BEGIN
    BEGIN TRY

        IF @nombre = '' OR @categoria = ''
        BEGIN
            PRINT 'error: el nombre y la categoria no pueden estar vacios';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Interes WHERE idInteres = @idInteres)
        BEGIN
            PRINT 'error: ya existe un interes con ese ID';
            RETURN;
        END;

        INSERT INTO Interes (idInteres, nombre, categoria)
        VALUES (@idInteres, @nombre, @categoria);

        PRINT 'Interes insertado';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el interes';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;