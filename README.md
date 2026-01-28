# Sistema de Biblioteca – Proyecto Final Bases de Datos

## Descripción general

Este proyecto corresponde al **proyecto final de la asignatura Bases de Datos**, desarrollado como un **sistema de gestión de biblioteca** utilizando **MySQL**. El sistema permite administrar usuarios, libros, autores, préstamos y ejemplares, incorporando conceptos avanzados de bases de datos como seguridad, optimización, triggers, funciones, vistas y respaldos.

El enfoque del proyecto es **académico**, orientado a demostrar el uso correcto y práctico de estructuras relacionales, integridad referencial y mecanismos de administración de bases de datos.

---

## Integrantes del grupo

* Ariel Paz
* Carlos Serrano

---

## Institución

* Escuela Politécnica Nacional
* Carrera: Desarrollo de Software
* Asignatura: Bases de Datos

---

## Motor de base de datos

* MySQL

---

## Alcance del proyecto

El sistema de biblioteca incluye:

* Diseño relacional completo.
* Uso de claves primarias y foráneas.
* Inserción de datos de prueba.
* Consultas complejas con JOIN.
* Funciones de agregación y de cadena.
* Subconsultas y vistas.
* Triggers para INSERT, UPDATE y DELETE.
* Control de accesos y seguridad.
* Prevención de inyección SQL.
* Cifrado de contraseñas mediante hash.
* Optimización con índices y EXPLAIN.
* Respaldo completo e incremental.

---

## Modelo de datos

El sistema está compuesto por las siguientes entidades principales:

* Usuario.
* Libro.
* Autor.
* Editorial.
* Categoría.
* Ejemplar.
* Préstamo.
* Detalle_Préstamo.

Las relaciones permiten manejar préstamos múltiples, autores por libro y control de ejemplares físicos.

---

## Seguridad implementada

### Control de accesos

* Usuario administrador con privilegios completos.
* Usuario bibliotecario con permisos de lectura y escritura.
* Usuario lector con permisos solo de consulta.

### Cifrado de contraseñas

* Almacenamiento de contraseñas usando hash SHA2.
* Nunca se guardan contraseñas en texto plano.

### Prevención de inyección SQL

* Uso de funciones con parámetros tipados.
* Eliminación de SQL dinámico.
* Uso de vistas para limitar la exposición de datos sensibles.

---

## Funciones, triggers y vistas

### Funciones

* Conteo de libros por categoría.
* Conteo de ejemplares disponibles.
* Promedio de libros por préstamo.
* Funciones de cadena para manejo de nombres.

### Triggers

* Trigger AFTER INSERT para marcar ejemplares como prestados.
* Trigger AFTER UPDATE para devolver ejemplares.
* Trigger AFTER DELETE para liberar ejemplares.

### Vistas

* Vista de catálogo completo.
* Vista de préstamos pendientes.
* Vista segura de usuarios (protección de DNI).

---

## Optimización y rendimiento

* Creación de índices sobre campos críticos.
* Consultas optimizadas con JOIN eficientes.
* Análisis de planes de ejecución usando EXPLAIN.

Esto permite mejorar el rendimiento en consultas frecuentes como préstamos activos, historial de usuarios y disponibilidad de libros.

---

## Respaldos (Backups)

### Backup completo

Se realiza un respaldo lógico completo de la base de datos utilizando herramientas nativas de MySQL.

**Comandos utilizados en la terminal:**

```bash
mkdir backups_mysql
cd backups_mysql
mysqldump -u root -p sistema_biblioteca > backup_completo_sistema_biblioteca.sql
```

Para restaurar el backup completo:

```bash
mysql -u root -p sistema_biblioteca < backup_completo_sistema_biblioteca.sql
```

---

### Backup incremental (lógico)

El backup incremental se realiza utilizando los **binary logs** de MySQL, los cuales almacenan únicamente los cambios realizados después del último backup completo.

**Verificar que el binlog esté activo:**

```sql
show variables like 'log_bin';
```

**Listar los archivos binlog:**

```sql
show binary logs;
```

**Generar backup incremental desde la terminal:**

```bash
mysqlbinlog mysql-bin.000002 > backup_incremental_sistema_biblioteca.sql
```

**Restauración del backup incremental:**

```bash
mysql -u root -p sistema_biblioteca < backup_incremental_sistema_biblioteca.sql
```

---

## Ejecución del proyecto

1. Crear la base de datos.
2. Ejecutar el script de creación de tablas.
3. Insertar los datos de prueba.
4. Crear funciones, triggers y vistas.
5. Crear usuarios y asignar privilegios.
6. Ejecutar consultas y pruebas.

---

## Nivel del proyecto

* Intermedio – Avanzado.

El proyecto integra múltiples conceptos vistos en la asignatura y buenas prácticas de bases de datos relacionales.

---

## Observaciones finales

Este sistema fue desarrollado con fines académicos, aplicando criterios de seguridad, consistencia y optimización, y cumple con los requerimientos de un sistema de gestión de biblioteca a nivel universitario.
