##TRIGGERS
#cuando se registra un préstamo, marcar el ejemplar como prestado
delimiter //

create trigger trg_prestamo_insert
after insert on detalle_prestamo
for each row
begin
    update ejemplar
    set estado = 'Prestado'
    where id_ejemplar = new.id_ejemplar;
end//

delimiter ;

#cuando se devuelve un préstamo, marcar el ejemplar como disponible
delimiter //

create trigger trg_prestamo_update
after update on prestamo
for each row
begin
    if new.estado = 'Devuelto' then
        update ejemplar e
        join detalle_prestamo dp on e.id_ejemplar = dp.id_ejemplar
        set e.estado = 'Disponible'
        where dp.id_prestamo = new.id_prestamo;
    end if;
end//

delimiter ;

#si se elimina un préstamo, liberar el ejemplar automáticamente
delimiter //

create trigger trg_prestamo_delete
after delete on detalle_prestamo
for each row
begin
    update ejemplar
    set estado = 'Disponible'
    where id_ejemplar = old.id_ejemplar;
end//

delimiter ;
