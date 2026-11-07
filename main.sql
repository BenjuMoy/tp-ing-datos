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

-- Cada franja es un rango de edad. edadMaxima NULL = sin tope (ej: "Mas de 60").
-- La franja de un ciudadano no se guarda: se calcula con su edad (ver vw_Ciudadano).
CREATE TABLE FranjaEtaria (
   idFranja INT PRIMARY KEY,
   descripcion VARCHAR(40) NOT NULL UNIQUE,
   edadMinima INT NOT NULL,
   edadMaxima INT NULL,
   CONSTRAINT CK_Franja_Rango CHECK (edadMinima >= 16 AND (edadMaxima IS NULL OR edadMaxima >= edadMinima))
);

CREATE TABLE Ciudadano (
   idCiudadano INT IDENTITY(1,1) PRIMARY KEY,
   dni VARCHAR(12) NOT NULL UNIQUE,
   nombreCompleto VARCHAR(120) NOT NULL,
   genero VARCHAR(30) NOT NULL,
   fechaNacimiento DATE NOT NULL,
   idBarrio INT NOT NULL,
   CONSTRAINT FK_Ciudadano_Barrio FOREIGN KEY (idBarrio)
       REFERENCES Barrio(idBarrio),
   CONSTRAINT CK_Ciudadano_Genero
       CHECK (genero IN ('Femenino', 'Masculino', 'No binario', 'Prefiere no decir'))
);

CREATE TABLE Categoria (
   idCategoria INT PRIMARY KEY,
   nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Interes (
   idInteres INT PRIMARY KEY,
   nombre VARCHAR(80) NOT NULL UNIQUE,
   idCategoria INT NOT NULL,
   CONSTRAINT FK_Interes_Categoria FOREIGN KEY (idCategoria)
       REFERENCES Categoria(idCategoria)
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

-- Opciones posibles de respuesta en una encuesta.
-- esPartido = 0 para respuestas que no son un partido (Indeciso, Voto en Blanco).
-- esPartidoPropio = 1 marca el partido para el que trabaja la campania (solo uno).
CREATE TABLE OpcionVoto (
   idOpcionVoto INT PRIMARY KEY,
   nombre VARCHAR(80) NOT NULL UNIQUE,
   esPartido BIT NOT NULL,
   esPartidoPropio BIT NOT NULL DEFAULT 0,
   CONSTRAINT CK_OpcionVoto_Propio CHECK (esPartidoPropio = 0 OR esPartido = 1)
);

-- Garantiza que haya un unico partido propio
CREATE UNIQUE INDEX UQ_OpcionVoto_PartidoPropio
   ON OpcionVoto(esPartidoPropio) WHERE esPartidoPropio = 1;

CREATE TABLE Encuesta (
   idEncuesta INT IDENTITY (1,1) PRIMARY KEY,
   idCiudadano INT NOT NULL,
   fechaEncuesta DATE NOT NULL,
   idOpcionVoto INT NOT NULL,
   probabilidadVoto DECIMAL(5,2) NOT NULL,
   CONSTRAINT FK_Encuesta_Ciudadano FOREIGN KEY (idCiudadano)
        REFERENCES Ciudadano(idCiudadano),
   CONSTRAINT FK_Encuesta_OpcionVoto FOREIGN KEY (idOpcionVoto)
        REFERENCES OpcionVoto(idOpcionVoto),
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


