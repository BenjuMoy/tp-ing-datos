USE [UADEAnalytics];
GO

CREATE OR ALTER PROCEDURE sp_InsertarCiudadano
    @dni VARCHAR(12),
    @nombreCompleto VARCHAR(120),
    @genero VARCHAR(30),
    @idFranja INT,
    @idBarrio INT
AS
BEGIN
    BEGIN TRY

        IF @dni = '' OR @nombreCompleto = '' OR @genero = ''
        BEGIN
            PRINT 'Error: los datos del ciudadano no pueden estar vacios';
            RETURN;
        END;

        IF EXISTS (SELECT 1 FROM Ciudadano WHERE dni = @dni)
        BEGIN
            PRINT 'Error: ya existe un ciudadano con ese DNI';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
        BEGIN
            PRINT 'Error: la franja etaria indicada no existe';
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
        BEGIN
            PRINT 'Error: el barrio indicado no existe';
            RETURN;
        END;

        INSERT INTO Ciudadano
        (dni, nombreCompleto, genero, idFranja, idBarrio)
        VALUES
        (@dni, @nombreCompleto, @genero, @idFranja, @idBarrio);

        PRINT 'Ciudadan insertado correctamente';

    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el ciudadano';
        PRINT 'Mensaje de error: ' + ERROR_MESSAGE();
        PRINT 'Codigo de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    END CATCH;
END;