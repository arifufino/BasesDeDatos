CREATE DATABASE Sistema_Biblioteca;
use Sistema_Biblioteca;

CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200),
    tipo_usuario ENUM('Estudiante','Docente','Externo') NOT NULL,
    fecha_registro DATE NOT NULL,
    estado ENUM('Activo','Inactivo') DEFAULT 'Activo'
);

CREATE TABLE Editorial (
    id_editorial INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    pais VARCHAR(100),
    telefono VARCHAR(20)
);

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE Libro (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    anio_publicacion YEAR,
    descripcion TEXT,
    id_editorial INT,
    id_categoria INT,
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
) ;

CREATE TABLE Autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100)
);

CREATE TABLE Libro_Autor (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
        ON DELETE CASCADE,
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
        ON DELETE CASCADE
);

CREATE TABLE Ejemplar (
    id_ejemplar INT AUTO_INCREMENT PRIMARY KEY,
    id_libro INT NOT NULL,
    codigo_barra VARCHAR(50) UNIQUE NOT NULL,
    estado ENUM('Disponible','Prestado','Dañado','Perdido') DEFAULT 'Disponible',
    ubicacion VARCHAR(100),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

CREATE TABLE Prestamo (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion_estimada DATE NOT NULL,
    fecha_devolucion_real DATE,
    estado ENUM('Activo','Devuelto','Retrasado') DEFAULT 'Activo',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Detalle_Prestamo (
    id_prestamo INT NOT NULL,
    id_ejemplar INT NOT NULL,
    PRIMARY KEY (id_prestamo, id_ejemplar),
    FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo)
        ON DELETE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES Ejemplar(id_ejemplar)
);


