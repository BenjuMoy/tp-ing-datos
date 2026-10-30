USE UADEAnalytics;
GO

CREATE PROCEDURE sp_InsertarCiudadano
    @idCiudadano INT,
    @dni VARCHAR(12),
    @nombreCompleto VARCHAR(120),
    @genero VARCHAR(30),
    @idFranja INT,
    @idBarrio INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que la franja etaria exista
    IF NOT EXISTS (SELECT 1 FROM FranjaEtaria WHERE idFranja = @idFranja)
    BEGIN
        RAISERROR('La Franja Etaria especificada no existe.', 16, 1);
        RETURN;
    END

    -- Validar que el barrio exista
    IF NOT EXISTS (SELECT 1 FROM Barrio WHERE idBarrio = @idBarrio)
    BEGIN
        RAISERROR('El Barrio especificado no existe.', 16, 1);
        RETURN;
    END

    -- Inserción del registro
    INSERT INTO Ciudadano (idCiudadano, dni, nombreCompleto, genero, idFranja, idBarrio)
    VALUES (@idCiudadano, @dni, @nombreCompleto, @genero, @idFranja, @idBarrio);
END;
GO