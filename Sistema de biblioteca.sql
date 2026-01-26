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

###INSERTAR DATOS

INSERT INTO Usuario (nombre, apellido, dni, email, telefono, direccion, tipo_usuario, fecha_registro, estado) VALUES
('Juan', 'Pérez', '12345678', 'juan.perez@mail.com', '5551111', 'Av. Central 123', 'Estudiante', '2024-01-10', 'Activo'),
('María', 'Gómez', '87654321', 'maria.gomez@mail.com', '5552222', 'Calle Norte 456', 'Docente', '2024-02-15', 'Activo');

INSERT INTO Editorial (nombre, pais, telefono) VALUES
('Editorial Alfa', 'España', '349111111'),
('Editorial Beta', 'México', '521222222');

INSERT INTO Categoria (nombre, descripcion) VALUES
('Informática', 'Libros relacionados con tecnología y programación'),
('Literatura', 'Obras literarias clásicas y modernas');

INSERT INTO Libro (titulo, isbn, anio_publicacion, descripcion, id_editorial, id_categoria) VALUES
('Introducción a Bases de Datos', '9781111111111', 2020, 'Conceptos básicos de bases de datos', 1, 1),
('Cien Años de Soledad', '9782222222222', 1967, 'Novela de Gabriel García Márquez', 2, 2);

INSERT INTO Autor (nombre, apellido, nacionalidad) VALUES
('Carlos', 'Ramírez', 'Española'),
('Gabriel', 'García Márquez', 'Colombiana');

INSERT INTO Libro_Autor (id_libro, id_autor) VALUES
(1, 1),
(2, 2);

INSERT INTO Ejemplar (id_libro, codigo_barra, estado, ubicacion) VALUES
(1, 'BD-001', 'Disponible', 'Estante A1'),
(2, 'LIT-001', 'Disponible', 'Estante B3');

INSERT INTO Prestamo (id_usuario, fecha_prestamo, fecha_devolucion_estimada, fecha_devolucion_real, estado) VALUES
(1, '2024-03-01', '2024-03-10', NULL, 'Activo'),
(2, '2024-03-02', '2024-03-12', '2024-03-11', 'Devuelto');

INSERT INTO Detalle_Prestamo (id_prestamo, id_ejemplar) VALUES
(1, 1),
(2, 2);

###CONSULTAS

###Libros actualemnte prestados con datos del usuario

SELECT 
    u.nombre,
    u.apellido,
    l.titulo,
    e.codigo_barra,
    p.fecha_prestamo,
    p.fecha_devolucion_estimada
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
WHERE p.estado = 'Activo';

###Usuarios con préstamos retrasados

SELECT 
    u.nombre,
    u.apellido,
    u.dni,
    p.fecha_devolucion_estimada,
    DATEDIFF(CURDATE(), p.fecha_devolucion_estimada) AS dias_retraso
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
WHERE p.estado = 'Activo'
AND p.fecha_devolucion_estimada < CURDATE();

###Libros más prestados

SELECT 
    l.titulo,
    COUNT(dp.id_ejemplar) AS veces_prestado
FROM Detalle_Prestamo dp
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
GROUP BY l.id_libro
ORDER BY veces_prestado DESC
LIMIT 5;

###Disponibilidad de libros por título

SELECT 
    l.titulo,
    SUM(CASE WHEN e.estado = 'Disponible' THEN 1 ELSE 0 END) AS disponibles,
    COUNT(e.id_ejemplar) AS total_ejemplares
FROM Libro l
JOIN Ejemplar e ON l.id_libro = e.id_libro
GROUP BY l.id_libro;

###Historial de préstamos de un usuario

SELECT 
    u.nombre,
    u.apellido,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion_real,
    p.estado
FROM Usuario u
JOIN Prestamo p ON u.id_usuario = p.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar e ON dp.id_ejemplar = e.id_ejemplar
JOIN Libro l ON e.id_libro = l.id_libro
WHERE u.id_usuario = 1;

## Funciones

DELIMITER //

CREATE FUNCTION TotalLibrosPorCategoria(p_id_categoria INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    
    SELECT COUNT(*) INTO total 
    FROM Libro 
    WHERE id_categoria = p_id_categoria;
    
    RETURN total;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION EjemplaresDisponibles(p_id_libro INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    
    SELECT COUNT(*) INTO cantidad 
    FROM Ejemplar 
    WHERE id_libro = p_id_libro AND estado = 'Disponible';
    
    RETURN cantidad;
END //

DELIMITER ;

DELIMITER //

CREATE FUNCTION PromedioLibrosPorPrestamo() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    
    SELECT AVG(conteo) INTO promedio FROM (
        SELECT COUNT(*) as conteo 
        FROM Detalle_Prestamo 
        GROUP BY id_prestamo
    ) AS subconsulta;
    
    RETURN promedio;
END //

DELIMITER ;

select TotalLibrosPorCategoria(1);
select EjemplaresDisponibles(1);
select PromedioLibrosPorPrestamo();

## Función cadena
DELIMITER //

CREATE FUNCTION NombreCompletoUsuario(p_id_usuario INT) 
RETURNS VARCHAR(201)
DETERMINISTIC
BEGIN
    DECLARE v_nombre_completo VARCHAR(201);
    
    SELECT CONCAT(nombre, ' ', apellido) INTO v_nombre_completo
    FROM Usuario
    WHERE id_usuario = p_id_usuario;
    
    RETURN v_nombre_completo;
END //

DELIMITER ;

## Subconsultas

SELECT nombre, apellido, email 
FROM Usuario 
WHERE id_usuario IN (
    SELECT id_usuario 
    FROM Prestamo 
    WHERE estado = 'Retrasado'
);

SELECT titulo, total 
FROM (
    SELECT id_libro, COUNT(*) AS total 
    FROM Ejemplar 
    GROUP BY id_libro
) AS ConteoEjemplares
JOIN Libro ON Libro.id_libro = ConteoEjemplares.id_libro
WHERE total > 3;

## Vistas

CREATE VIEW Vista_Catalogo_Completo AS
SELECT 
    l.id_libro,
    l.titulo,
    CONCAT(a.nombre, ' ', a.apellido) AS autor,
    e.nombre AS editorial,
    c.nombre AS categoria,
    l.anio_publicacion
FROM Libro l
JOIN Editorial e ON l.id_editorial = e.id_editorial
JOIN Categoria c ON l.id_categoria = c.id_categoria
JOIN Libro_Autor la ON l.id_libro = la.id_libro
JOIN Autor a ON la.id_autor = a.id_autor;

CREATE VIEW Vista_Prestamos_Pendientes AS
SELECT 
    p.id_prestamo,
    u.nombre AS usuario,
    u.telefono,
    l.titulo AS libro,
    ej.codigo_barra,
    p.fecha_devolucion_estimada
FROM Prestamo p
JOIN Usuario u ON p.id_usuario = u.id_usuario
JOIN Detalle_Prestamo dp ON p.id_prestamo = dp.id_prestamo
JOIN Ejemplar ej ON dp.id_ejemplar = ej.id_ejemplar
JOIN Libro l ON ej.id_libro = l.id_libro
WHERE p.estado = 'Activo';

DELIMITER //
CREATE FUNCTION obtener_usuario(p_id_usuario INT)
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE resultado VARCHAR(100);
    SELECT nombre
    INTO resultado
    FROM usuario
    WHERE id_usuario = p_id_usuario;
    
    RETURN resultado;
END//
DELIMITER ;
select obtener_usuario(1 or 1=1);

CREATE USER 'admin_biblio'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON Sistema_Biblioteca.* TO 'admin_biblio'@'localhost';

CREATE USER 'bibliotecario_1'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT, INSERT, UPDATE ON Sistema_Biblioteca.* TO 'bibliotecario_1'@'localhost';

CREATE USER 'lector_consulta'@'localhost' IDENTIFIED BY '12345';
GRANT SELECT ON Sistema_Biblioteca.Libro TO 'lector_consulta'@'localhost';
GRANT SELECT ON Sistema_Biblioteca.Vista_Catalogo_Completo TO 'lector_consulta'@'localhost';


DROP USER 'admin_biblio'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_biblio'@'localhost';

DROP USER 'bibliotecario_1'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'bibliotecario_1'@'localhost';

DROP USER 'lector_consulta'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'lector_consulta'@'localhost';
