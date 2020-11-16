--------------------------------------------INICIO ARCHIVO DEL PUNTO B--------------------------------

--PUNTO B)1)


-- INSTANCIA DE REVISION:
/*
select *
from g9_movimiento;

--En este momento la base se encuentra con todos los bloques y direcciones en null.
-- Insertamos el usuario 1 con la moneda 'BTC' con el numero de bloque 5.

insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(3, 'BTC', current_date, 'e', 0.1, 12000, 10, 'oasjsdou44');

--Por ende si ahora queremos insertar el usuario 10 con el numero de bloque 4 no deberia dejarnos.
insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(11, 'BTC', current_date, 'e', 0.1, 12000, 9, 'oasjsdou44');

--Efectivamente nos da que :  ERROR: El numero de bloque es menor al que corresponde.
*/

CREATE OR REPLACE FUNCTION TRFN_G9_MOVIMIENTO_VALIDO_BLOQUE() RETURNS trigger AS $$
    DECLARE
        ultimoNumBloq integer;
    BEGIN
        ultimoNumBloq := (select m.bloque
                        from g9_movimiento m
                        where bloque is not null
                        order by m.bloque desc
                        limit 1);
        IF (new.bloque <= ultimoNumBloq) then
            RAISE EXCEPTION 'El numero de bloque es menor al que corresponde.';
        END IF;
    RETURN NEW;
    end;
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER TR_MOVIMIENTO_VALIDO_BLOQUE BEFORE INSERT OR UPDATE OF bloque ON g9_movimiento
FOR EACH ROW EXECUTE FUNCTION TRFN_G9_MOVIMIENTO_VALIDO_BLOQUE();


/*

-- Check correspondiente a B1

alter table g9_movimiento add constraint  ck_G9_movimiento_mov_valido_bloque
check ( bloque >  (select m.bloque
                        from g9_movimiento m
                        order by m.bloque desc
                        limit 1));
*/

----------------------------------------------------------------------------------
--PUNTO B)2)

-- INSTANCIA DE REVISION:
/*
select *
from g9_billetera
where id_usuario=1 and moneda='EUR';

-- Vamos a agregar una oden del usuario 1, de compra, con un monto de 100 000 euros, cuando en su billetera tiene
-- un numero menor de euros, no podemos saber cual es exactamente ya que se genera de forma random.

-- Ingresamos una id grande del usuario 1, con el valor y cantidad de 100 000.

select *
from g9_billetera
where id_usuario=1 and (moneda='EUR' or moneda='USDT');

insert into g9_orden(id, mercado, id_usuario, tipo, fecha_creacion, fecha_ejec, valor, cantidad, estado) VALUES
(1231231322, 'Mercado_EUR_USDT', 1, 'Compra', current_date, current_date, 100000, 100000, 'Pendiente');

-- En efecto sale que : ERROR: No se puede agregar la orden debido a que no se tiene el saldo suficiente.
*/

-- **ACLARACION**
-- Consideramos que las ordenes van a restar de la billetera por ende con preguntar el saldo en la billetera
-- tenemos el saldo neto que tiene para gastar.
CREATE OR REPLACE FUNCTION  TRFN_G9_ORDEN_VALIDA() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_orden o
            INNER JOIN (select m.moneda_o, m.nombre from  g9_mercado m) m2
                on (m2.nombre = new.mercado)
            INNER JOIN g9_billetera b on (new.id_usuario = b.id_usuario) and (b.moneda = m2.moneda_o)
            where (new.valor*new.cantidad > b.saldo) or (new.valor<=0)) then
            RAISE EXCEPTION 'No se puede agregar la orden debido a que no se tiene el saldo suficiente';
        END IF;

    RETURN NEW;
    end;
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_G9_ORDEN_VALIDA BEFORE INSERT OR UPDATE OF valor ON g9_orden
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_ORDEN_VALIDA();


/*
-- Check correspondiente a B2:

create assertion AS_G9_ORDEN_VALIDA
check ( not exists (SELECT 1
            from g9_orden o
            INNER JOIN (select m.moneda_o, m.nombre from  g9_mercado m) m2
                on (m2.nombre = new.mercado)
            INNER JOIN g9_billetera b on (new.id_usuario = b.id_usuario) and (b.moneda = m2.moneda_o)
            where (new.valor > b.saldo) or (new.valor<=0)));
*/

------------------------------------------------------------------------------------
--PUNTO B)3)

-- INSTANCIA DE REVISION:
/*
SELECT *
FROM g9_billetera
WHERE id_usuario=2 AND moneda='BTC';

-- Sentencia de prueba para activar el trigger, el valor es muy alto porque al generarse random,
-- pusimos uno que si o si lo supere
insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(1,'BTC', current_date,'s', 0.01, 100000000, null, null);

-- En efecto ERROR: Actualmente no posee la suma que desea retirar
*/

CREATE OR REPLACE FUNCTION  TRFN_G9_RETIRO_VALIDO() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_billetera b
            where ((new.id_usuario = b.id_usuario) and (b.moneda = new.moneda)and (new.tipo='s') and
                   (new.valor + new.comision) > b.saldo )) then
            RAISE EXCEPTION 'Actualmente no posee la suma que desea retirar';
        END IF;
    RETURN NEW;
    end
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_G9_movimiento_RETIRO_VALIDO BEFORE INSERT OR UPDATE OF valor ON g9_movimiento
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_RETIRO_VALIDO();

/*
-- Check correspondiente a B3

alter table g9_movimiento add constraint  ck_G9_movimiento_retiro_valido
check (not exists( SELECT 1
            from g9_billetera b
            where ((id_usuario = b.id_usuario) and (b.moneda = moneda) and
                   (valor + comision) > b.saldo )));
*/

-----------------------------------------------------------------------------------------
--PUNTO B)4)


-- INSTANCIA DE REVISION:
/*
-- Sentencia de prueba, este insert genera un error que activa el trigger
insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(1, 'BTC', current_date, 'e', 0.01, 1.0, 100, null);

-- En efecto ERROR: Direccion y bloque deben ser ambos null, o ninguno debe serlo
*/

CREATE OR REPLACE FUNCTION TRFN_G9_MOVIMIENTO_NULL() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_movimiento
            where ((new.bloque is null and new.direccion is not null) or
                   (new.bloque is not null and new.direccion is null))) then
            RAISE EXCEPTION 'Direccion y bloque deben ser ambos null, o ninguno debe serlo ';
        END IF;
    RETURN NEW;
    end
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_G9_movimiento_MOVIMIENTO_NULL BEFORE INSERT OR UPDATE OF direccion, bloque ON g9_movimiento
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_MOVIMIENTO_NULL();

-- Check correspondiente a B4
/*
alter table g9_movimiento add constraint  ck_G9_movimiento_movimiento_null
check ((bloque is null and direccion is not null) or
                   (bloque is not null and direccion is null));
*/
-------------------------------------------------------------------------------
--------------------INCISO C-------------------

--Inciso C.1.A : brinde el precio actual de cotización en un mercado determinado.


-- La usamos para el calculo de la funcion de abajo.
create or replace function FN_G9_sumaPorcentaje(cantV numeric(20,10),cantC numeric(20,10),  mercado1 varchar) returns numeric(20,10) as
    $$
    declare
        rec record;
        val1 numeric(20,10);
        val2 numeric(20,10);
        count numeric(20,10);
    begin
        count:=0;
        val1:=0;
        for rec in (SELECT *  FROM G9_orden_venta o where o.mercado=mercado1 order by o.valor) loop
            exit when count>(cantV);
            val1:= val1+(rec.valor*rec.cantidad);
            count:= count+rec.cantidad;
            end loop;
        if (count <> 0) then
        val1:=val1/count;
        end if;
        val2:=0;
        count:=0;
        for rec in (SELECT *  FROM G9_orden_compra o where o.mercado=mercado1 order by o.valor ) loop
            exit when count>(cantC);
            val2:= val2+(rec.valor*rec.cantidad);
            count:= count+rec.cantidad;
            end loop;
        if (count <> 0) then
            val2:=val2/count;
        end if;
    return ((val1+val2)/2);
    end;
    $$language plpgsql;

create or replace function FN_G9_valor_mercado(  mercado1 varchar) returns numeric(20,10) as
    $$
    declare
        cantV numeric(20,10);
        cantC numeric(20,10);
        val numeric(20,10);
    begin
        cantV:= (select sum(o1.cantidad) from g9_orden_venta o1 where o1.mercado=mercado1)*0.2;
        cantC:= (select sum(o2.cantidad) from g9_orden_compra o2 where o2.mercado=mercado1)*0.2;
        if ((cantV=0) or (cantC=0)) then
            RAISE EXCEPTION 'No existen ordenes de compra o venta para este mercado';
        else
            val := (select FN_G9_sumaPorcentaje(cantV, cantC, mercado1 ));
        end if;
        update g9_mercado set precio_mercado=val where nombre=mercado1;
        return val;
    end;

    $$language plpgsql;

-- INSTANCIA DE REVISION:
/*
-- Linea para probar la funcion, checkear que el mercado existe y hay ordenes cargadas
select fn_g9_valor_mercado('Mercado_USDT_BTC');

-- Por ejemplo para ver bien el mercado si se actualiza solo o no, podemos insertar un valor de 3000 a 1 para alterar el valor del mercado, y si
-- volvermos a ver la fn_g9_valor_mercado con el mismo mercado vemos que este a aumentado.

INSERT INTO g9_orden(id, mercado, id_usuario, tipo, fecha_creacion, fecha_ejec, valor, cantidad, estado) values
(1010202332, 'Mercado_USDT_BTC', 1, 'Compra', current_date, current_date, 3000, 1, 'Pendiente');
*/

----------------------------------------------------------------------------
--Inciso C.1.B
--ejecute una orden de mercado (orden del tipo Market) para compra y venta.


create view G9_orden_compra as
    select *
    from g9_orden g9o
    where tipo='Compra' and estado<>'Cumplida'
    order by (g9o.valor);

-- Prueba para ver la vista.
--Select * from G9_orden_compra;

create view G9_orden_venta as
    select *
    from g9_orden g9o
    where tipo='Venta' and estado<>'Cumplida'
    order by (g9o.valor);

-- Prueba para ver la vista.
--SELECT * from G9_orden_venta;

create or replace function fn_G9_ejecutar_orden(ingreso integer, cantidad integer, mercado1 varchar, tipo_orden varchar, id_user integer, mon_d varchar, mon_o varchar) returns integer as $$
    declare
        suma integer;
        rec record;
    begin
    suma :=0;
    if tipo_orden='Compra' then
        for rec in (SELECT *  FROM G9_orden_venta o where o.mercado=mercado1 and o.estado='Pendiente' and ingreso>=o.valor) loop
             exit when ((suma+(rec.valor*rec.cantidad))>ingreso*cantidad);

                update g9_orden o set estado='Cumplida' where o.id=rec.id;
                --se le resta la cantidad de moneda que vendio
                update g9_billetera b set saldo= saldo-(rec.cantidad)
                    where b.moneda= mon_d and b.id_usuario=rec.id_usuario;
                --se le suma la cantidad de moneda que vendio, por el valor de mercado de esas dos monedas
                update g9_billetera b set saldo= saldo+(rec.valor*rec.cantidad)
                    where b.moneda= mon_o and b.id_usuario=rec.id_usuario;
                --actualizo la cantidad de moneda que compre en mi billetera
                update g9_billetera b set saldo= saldo+(rec.cantidad)
                    where b.moneda= mon_d and b.id_usuario=id_user;
                suma:= suma+(rec.valor*rec.cantidad);
        end loop;
        --resto lo que pague de moneda origen
        update g9_billetera b set saldo=(saldo-suma) where b.id_usuario=id_user and b.moneda= mon_o;
    else
        for rec in (SELECT *  FROM G9_orden_compra o where o.mercado=mercado1 and o.estado='Pendiente' and ingreso<=o.valor) loop
             exit when ((suma+(rec.valor*rec.cantidad))>ingreso*cantidad);
                update g9_orden o set estado='Cumplida' where o.id=rec.id;
                --el gana la moneda que compro
                update g9_billetera b set saldo= saldo+(rec.cantidad)
                    where b.moneda= mon_d and b.id_usuario=rec.id_usuario;
                --el pierde la moneda que dio a cambio
                update g9_billetera b set saldo= saldo-(rec.valor*rec.cantidad)
                    where b.moneda= mon_o and b.id_usuario=rec.id_usuario;
                -- yo pierdo la moneda que vendi
                update g9_billetera b set saldo= saldo-(rec.cantidad)
                    where b.moneda= mon_d and b.id_usuario=id_user;
                suma:= suma+(rec.valor*rec.cantidad);
        end loop;
        update g9_billetera b set saldo=(saldo+suma) where b.id_usuario=id_user and b.moneda= mon_o;
    end if;
    return (suma);
    end
$$ language plpgsql;


-- Prueba manual, para la funcion ejecutar orden.
/*
select fn_G9_ejecutar_orden(800, 20, 'Mercado_USDT_BTC', 'Compra', 1, 'USDT', 'BTC');
*/

create or replace function TRFN_G9_ejecucion_orden() returns trigger as
    $$
    declare
        mon1 varchar;
        mon2 varchar;
        val integer;
        cantidad integer;
    begin
        UPDATE g9_orden SET estado='Cumplida' where id=new.id;
        mon1:=(select m.moneda_d
            from g9_mercado m inner join g9_orden o on m.nombre = o.mercado  where m.nombre=new.mercado limit 1);
        mon2:=(select m.moneda_o
            from g9_mercado m inner join g9_orden o on m.nombre = o.mercado where m.nombre=new.mercado limit 1);
        val=new.valor;
        cantidad=new.cantidad;

        PERFORM  fn_G9_ejecutar_orden(val, cantidad,new.mercado, new.tipo, new.id_usuario,mon1, mon2);
        return new;
    end
$$language plpgsql;


CREATE TRIGGER TR_G9_ejecucion_orden after INSERT OR UPDATE of valor ON g9_orden
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_ejecucion_orden();

-- INSTANCIA DE REVISION:

/*
-- Para ver que hay en orden y poder ver si "agarra" bien las ordenes de venta, ya que vamos a efectuar una compra.
select * from g9_orden where mercado='Mercado_USDT_BTC' AND tipo='Venta' and estado='Pendiente' order by valor;

-- Para ver cuanto dinero tiene el usuario para saber si resta y suma bien el valor en la billetera a ejecutar una orden.
select *
from g9_billetera
where id_usuario=4 and(moneda='USDT' or moneda='BTC');

insert into g9_orden (id, mercado, id_usuario, tipo, fecha_creacion, fecha_ejec, valor, cantidad, estado)
values (100602023, 'Mercado_USDT_BTC', 4, 'Compra', current_date, null, 488, 7, 'Pendiente');

-- Para ver si la orden agarrada paso a cumplida.
select * from g9_orden where mercado='Mercado_USDT_BTC' AND estado='Cumplida' and id=100602023 order by valor;

*/

----------------------------------------------------------------------------------
--Inciso C.1.C

CREATE OR REPLACE function FN_G9_ORDENES_MERCADO_FECHA(nombre_mercado character varying, fecha_param timestamp)
returns table(id bigint, tipo character(6), estado character(10)) as
$$
    begin
        return query (select o.id, o.tipo, o.estado
            from g9_orden o
            where o.mercado=nombre_mercado and o.fecha_creacion=fecha_param
            order by o.fecha_creacion);
    end
$$ language plpgsql;

-- INSTANCIA DE REVISION:
--select FN_G9_ORDENES_MERCADO_FECHA('Mercado_EUR_USDT','14/11/2020');
-- **ACLARACION: En esta funcion lo que entendi fue que dado una fecha exacta te daba todas las ordenes de ese fecha. Las fechas son random pueden
-- que la fecha que puse en el select de arriba no se encuentre.

----------------------------------------------------------------------------------------------------------------------------------------------
-- INCISO D

--D
--1) Realice una vista que dé el saldo de cada moneda para cada uno de los usuarios.

create view G9_saldoUsuarios as
    select g9b.id_usuario, g9b.moneda, g9b.saldo
    from g9_billetera g9b
    order by g9b.id_usuario;

-- INSTANCIA DE REVISION:
/*
select *
from G9_saldoUsuarios;
*/

---------------------------------------------------------------------------------------

--2)Realice una vista que dé el listado de la cantidad de dinero que tiene cada usuario en
-- cada moneda junto con la cotización al momento de ejecutar la vista en BTC y USDT.

create view g9_saldousuario_BTC_USDT as
    select g9b.id_usuario, g9b.moneda, g9b.saldo, g9m2.moneda_d, g9m2.precio_mercado
    from g9_billetera g9b inner join (select g9m.moneda_d, g9m.precio_mercado, g9m.moneda_o
                                        from g9_mercado g9m
                                        where (g9m.moneda_d='BTC' or g9m.moneda_d='USDT')) g9m2 on g9b.moneda=g9m2.moneda_o
    order by g9b.id_usuario;

-- INSTANCIA DE REVISION:
/*
select *
from g9_saldousuario_BTC_USDT;
*/

-- Al ser una vista con join debemos generar triggers instead of.

-- INSERT OR UPDATE
create or replace function trfn_g9_insertUpdate_SaldoUsuarios() returns trigger as $$
begin
    if (TG_OP='insert') then
        if not exists(select 1 from g9_billetera where id_usuario=new.id_usuario) then
            insert into g9_billetera(id_usuario, moneda, saldo) values (new.id_usuario,new.moneda, new.saldo);
        end if;
    end if;
    if (TG_OP='update') then
               update g9_billetera set id_usuario=new.id_usuario and moneda=new.moneda and saldo=new.saldo where
                        id_usuario=new.id_usuario and moneda=new.moneda;
    end if;
    return new;
end
$$ language plpgsql;

-- DELETE
create or replace function trfn_g9_delete_SaldoUsuarios() returns trigger as $$
begin
    delete from g9_billetera where id_usuario=old.id_usuario and moneda=old.moneda;
    return old;
end
$$ language plpgsql;

-- TRIGGER DE ACTIVACION
create trigger tr_g9_io_SaldoUsuario_insert_update instead of insert or update on g9_saldousuario_BTC_USDT
    for each row execute function trfn_g9_insertUpdate_SaldoUsuarios();
create trigger tr_g9_io_SaldoUsuario_delete instead of delete on g9_saldousuario_BTC_USDT
    for each row execute function trfn_g9_delete_SaldoUsuarios();


--3)Realice una vista (usando la vista anterior) que dé los 10 usuarios que más dinero tienen en TOTAL en toda su billetera.


create view G9_mayorSaldo10 as
    select s.id_usuario, sum(saldo*precio_mercado)
    from g9_saldousuario_BTC_USDT s
    where (moneda_d='BTC' or moneda='BTC')
    group by s.id_usuario
    order by sum(saldo*precio_mercado) desc
    limit 10;

-- INSTANCIA DE REVISION:
/*
-- select para probar lo que carga la view
    select * from G9_mayorSaldo10;
*/