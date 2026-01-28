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

###5 CONSULTAS mas

###autores y cantidad de libros escritos
select 
    a.nombre,
    a.apellido,
    count(la.id_libro) as total_libros
from autor a
join libro_autor la on a.id_autor = la.id_autor
group by a.id_autor;

###libros con su editorial y categoria
select
    l.titulo,
    e.nombre as editorial,
    c.nombre as categoria
from libro l
join editorial e on l.id_editorial = e.id_editorial
join categoria c on l.id_categoria = c.id_categoria;

###usuarios que nunca han realizado prestamos
select
    u.nombre,
    u.apellido,
    u.dni
from usuario u
left join prestamo p on u.id_usuario = p.id_usuario
where p.id_prestamo is null;

###ejemplares no disponibles
select
    l.titulo,
    e.codigo_barra,
    e.estado
from ejemplar e
join libro l on e.id_libro = l.id_libro
where e.estado <> 'Disponible';

###cantidad de prestamos por tipo de usuario
select
    u.tipo_usuario,
    count(p.id_prestamo) as total_prestamos
from usuario u
join prestamo p on u.id_usuario = p.id_usuario
group by u.tipo_usuario;

###consultas avanzadas y operaciones sql para sistema de biblioteca

###funciones de agregacion (count, sum, avg)
select
    c.nombre as categoria,
    count(l.id_libro) as total_libros
from categoria c
left join libro l on c.id_categoria = l.id_categoria
group by c.id_categoria;

select
    u.tipo_usuario,
    count(p.id_prestamo) as total_prestamos
from usuario u
join prestamo p on u.id_usuario = p.id_usuario
group by u.tipo_usuario;

select
    avg(year(curdate()) - l.anio_publicacion) as promedio_antiguedad_libros
from libro l;

###funciones de cadena
select
    concat(nombre, ' ', apellido) as nombre_completo,
    upper(email) as email_mayusculas,
    length(dni) as longitud_dni
from usuario;

select
    substring(titulo, 1, 10) as inicio_titulo
from libro;

###subconsultas
select
    l.titulo
from libro l
where l.id_libro not in (
    select e.id_libro
    from ejemplar e
    join detalle_prestamo dp on e.id_ejemplar = dp.id_ejemplar
);

select
    nombre,
    apellido
from usuario
where id_usuario in (
    select id_usuario
    from prestamo
    where estado = 'Activo'
);

###vista
create view vista_historial_prestamos as
select
    u.nombre,
    u.apellido,
    l.titulo,
    p.fecha_prestamo,
    p.fecha_devolucion_real,
    p.estado
from usuario u
join prestamo p on u.id_usuario = p.id_usuario
join detalle_prestamo dp on p.id_prestamo = dp.id_prestamo
join ejemplar e on dp.id_ejemplar = e.id_ejemplar
join libro l on e.id_libro = l.id_libro;

###insert
insert into categoria (nombre, descripcion)
values ('historia', 'libros historicos');

###update
update ejemplar
set estado = 'Prestado'
where id_ejemplar = 1;



