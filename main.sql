CREATE DATABASE UADEAnalytics
GO

USE [UADEAnalytics];
GO

CREATE TABLE Comuna (
   idComuna INT PRIMARY KEY,
   nombre VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE Barrio (
   idBarrio INT PRIMARY KEY,
   idComuna INT NOT NULL,
   nombre VARCHAR(80) NOT NULL,
   CONSTRAINT FK_Barrio_Comuna FOREIGN KEY (idComuna)
       REFERENCES Comuna(idComuna),
   CONSTRAINT UQ_Barrio_Comuna_Nombre UNIQUE (idComuna, nombre)
);

CREATE TABLE FranjaEtaria (
   idFranja INT PRIMARY KEY,
   descripcion VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE Ciudadano (
   idCiudadano INT IDENTITY(1,1) PRIMARY KEY,
   dni VARCHAR(12) NOT NULL UNIQUE,
   nombreCompleto VARCHAR(120) NOT NULL,
   genero VARCHAR(30) NOT NULL,
   idFranja INT NOT NULL,
   idBarrio INT NOT NULL,
   CONSTRAINT FK_Ciudadano_Franja FOREIGN KEY (idFranja)
       REFERENCES FranjaEtaria(idFranja),
   CONSTRAINT FK_Ciudadano_Barrio FOREIGN KEY (idBarrio)
       REFERENCES Barrio(idBarrio),
   CONSTRAINT CK_Ciudadano_Genero
       CHECK (genero IN ('Femenino', 'Masculino', 'No binario', 'Prefiere no decir'))
);

CREATE TABLE Interes (
   idInteres INT PRIMARY KEY,
   nombre VARCHAR(80) NOT NULL UNIQUE,
   categoria VARCHAR(50) NOT NULL
);

CREATE TABLE CiudadanoInteres (
   idCiudadano INT NOT NULL,
   idInteres INT NOT NULL,
   nivelPrioridad INT NOT NULL,
   CONSTRAINT PK_CiudadanoInteres PRIMARY KEY (idCiudadano, idInteres),
   CONSTRAINT FK_CI_Ciudadano FOREIGN KEY (idCiudadano)
       REFERENCES Ciudadano(idCiudadano),
   CONSTRAINT FK_CI_Interes FOREIGN KEY (idInteres)
       REFERENCES Interes(idInteres),
   CONSTRAINT CK_CI_Prioridad CHECK (nivelPrioridad BETWEEN 1 AND 5)
);

CREATE TABLE Encuesta (
   idEncuesta INT IDENTITY (1,1) PRIMARY KEY,
   idCiudadano INT NOT NULL,
   fechaEncuesta DATE NOT NULL,
   intencionVoto VARCHAR(80) NOT NULL,
   probabilidadVoto DECIMAL(5,2) NOT NULL,
   CONSTRAINT FK_Encuesta_Ciudadano FOREIGN KEY (idCiudadano)
        REFERENCES Ciudadano(idCiudadano),
   -- Relacion 1:1 con Ciudadano (segun el modelo conceptual): una encuesta por ciudadano
   CONSTRAINT UQ_Encuesta_Ciudadano UNIQUE (idCiudadano),
   CONSTRAINT CK_Encuesta_Intencion
       CHECK (intencionVoto IN ('Alianza Innovadora', 'Frente Ciudadano', 'Movimiento Evolución',
                                'Unión Vecinal CABA', 'Indeciso', 'Voto en Blanco')),
   CONSTRAINT CK_Encuesta_Probabilidad
       CHECK (probabilidadVoto BETWEEN 0 AND 100)
);

CREATE TABLE AccionCampania (
   idAccion INT IDENTITY(1,1) PRIMARY KEY,
   idComuna INT NOT NULL,
   idInteresObjetivo INT NOT NULL,
   tipoAccion VARCHAR(60) NOT NULL,
   presupuestoAsignado DECIMAL(12,2) NOT NULL,
   CONSTRAINT FK_Accion_Comuna FOREIGN KEY (idComuna)
       REFERENCES Comuna(idComuna),
   CONSTRAINT FK_Accion_Interes FOREIGN KEY (idInteresObjetivo)
       REFERENCES Interes(idInteres),
   CONSTRAINT CK_Accion_Presupuesto CHECK (presupuestoAsignado >= 0)
);

CREATE TABLE HistorialEncuesta (
   idHistorial INT IDENTITY(1,1) PRIMARY KEY,
   idEncuesta INT NOT NULL,
   fechaCambio DATETIME NOT NULL DEFAULT SYSDATETIME(),
   operacion VARCHAR(10) NOT NULL,
   valorAnterior VARCHAR(250) NULL,
   valorNuevo VARCHAR(250) NULL,
   CONSTRAINT FK_Historial_Encuesta FOREIGN KEY (idEncuesta)
       REFERENCES Encuesta(idEncuesta)
);


