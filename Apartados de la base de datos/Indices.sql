### creacion de indices para optimizar consultas
create index idx_prestamo_estado on prestamo(estado);
create index idx_prestamo_usuario on prestamo(id_usuario);
create index idx_ejemplar_libro on ejemplar(id_libro);
create index idx_libro_categoria on libro(id_categoria);
create index idx_detalle_prestamo_prestamo on detalle_prestamo(id_prestamo);

### consultas optimizadas usando indices

### libros actualmente prestados (usa idx_prestamo_estado, idx_detalle_prestamo_prestamo)
select 
    u.nombre,
    u.apellido,
    l.titulo,
    e.codigo_barra,
    p.fecha_prestamo,
    p.fecha_devolucion_estimada
from prestamo p
join usuario u on p.id_usuario = u.id_usuario
join detalle_prestamo dp on p.id_prestamo = dp.id_prestamo
join ejemplar e on dp.id_ejemplar = e.id_ejemplar
join libro l on e.id_libro = l.id_libro
where p.estado = 'Activo';

### disponibilidad de libros por categoria (usa idx_libro_categoria)
select
    c.nombre as categoria,
    count(e.id_ejemplar) as total_ejemplares
from categoria c
join libro l on c.id_categoria = l.id_categoria
join ejemplar e on l.id_libro = e.id_libro
group by c.id_categoria;

### historial de prestamos por usuario (usa idx_prestamo_usuario)
select
    u.nombre,
    u.apellido,
    l.titulo,
    p.fecha_prestamo,
    p.estado
from usuario u
join prestamo p on u.id_usuario = p.id_usuario
join detalle_prestamo dp on p.id_prestamo = dp.id_prestamo
join ejemplar e on dp.id_ejemplar = e.id_ejemplar
join libro l on e.id_libro = l.id_libro
where u.id_usuario = 1;

### uso de explain para analizar el plan de ejecucion

explain
select 
    u.nombre,
    u.apellido,
    l.titulo,
    e.codigo_barra,
    p.fecha_prestamo
from prestamo p
join usuario u on p.id_usuario = u.id_usuario
join detalle_prestamo dp on p.id_prestamo = dp.id_prestamo
join ejemplar e on dp.id_ejemplar = e.id_ejemplar
join libro l on e.id_libro = l.id_libro
where p.estado = 'Activo';

explain
select
    u.nombre,
    u.apellido,
    l.titulo,
    p.fecha_prestamo,
    p.estado
from usuario u
join prestamo p on u.id_usuario = p.id_usuario
where u.id_usuario = 1;

explain
select
    c.nombre,
    count(l.id_libro) as total_libros
from categoria c
join libro l on c.id_categoria = l.id_categoria
group by c.id_categoria;
