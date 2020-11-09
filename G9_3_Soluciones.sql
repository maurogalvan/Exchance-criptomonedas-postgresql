--------------------------------------------INICIO ARCHIVO DEL PUNTO B--------------------------------

--PUNTO B)1)

--sentencia de modificación, y inserción
/*
select *
from g9_movimiento;
--En la base se encuentra en numero de bloque 1 y 3, y ahora insertamos el 5.
insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(1, 'BTC', current_date, 'c', 0.1, 12000, 5, 'oasjsdou44');
--Por ende si ahora queremos insertar el 4 no deberia dejarnos.
insert into g9_movimiento(id_usuario, moneda, fecha, tipo, comision, valor, bloque, direccion) values
(5, 'BTC', current_date, 'c', 0.1, 12000, 4, 'oasjsdou44');
--Efectivamente nos da que :  ERROR: El numero de bloque es menor al que corresponde.
*/
CREATE OR REPLACE FUNCTION TRFN_G9_MOVIMIENTO_VALIDO_BLOQUE() RETURNS trigger AS $$
    BEGIN
        IF (new.bloque< (select m.bloque
                        from g9_movimiento m
                        order by m.bloque desc
                        limit 1)) then
            RAISE EXCEPTION 'El numero de bloque es menor al que corresponde.';
        END IF;

    RETURN NEW;
    end;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER TR_MOVIMIENTO_VALIDO_BLOQUE BEFORE INSERT OR UPDATE OF bloque ON g9_movimiento
FOR EACH ROW EXECUTE FUNCTION TRFN_G9_MOVIMIENTO_VALIDO_BLOQUE();

--------------------------------------------------------
--PUNTO B)2)
select *
from g9_billetera
where id_usuario=1;
--Vamos a agregar una oden del usuario 1 de compra con un monto de 16000 euros, cuando en su billetera tiene
--15933 euros, por ende, no deberia poder ejecutarse.
insert into g9_orden(id, mercado, id_usuario, tipo, fecha_creacion, fecha_ejec, valor, cantidad, estado) VALUES
(1000, 'Mercado_EUR_USDT', 1, 'Compra', current_date, current_date, 16000, 16000, 'pendiente');
--En efecto sale que : ERROR: No se puede agregar la orden debido a que no se tiene el saldo suficiente

--Consideramos que las ordenes van a restar de la billetera
CREATE OR REPLACE FUNCTION  TRFN_G9_ORDEN_VALIDA() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_orden o
            INNER JOIN g9_mercado m on (m.nombre = new.mercado)
            INNER JOIN g9_billetera b on (new.id_usuario = b.id_usuario) and (b.moneda = m.moneda_o)
            where (new.valor > b.saldo) or (new.valor<=0)) then
            RAISE EXCEPTION 'No se puede agregar la orden debido a que no se tiene el saldo suficiente';
        END IF;

    RETURN NEW;
    end;
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_G9_orden_ORDEN_VALIDA BEFORE INSERT OR UPDATE OF valor ON g9_orden
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_ORDEN_VALIDA();


------------------------------------------------------------------------------------
--PUNTO B)3)

CREATE OR REPLACE FUNCTION  TRFN_G9_RETIRO_VALIDO() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_billetera b
            where ((new.id_usuario = b.id_usuario) and (b.moneda = new.moneda) and
                   (new.valor + new.comision) > b.saldo )) then
            RAISE EXCEPTION 'Actualmente no posee la suma que desea retirar';
        END IF;
    RETURN NEW;
    end
$$
LANGUAGE plpgsql;

CREATE TRIGGER TR_G9_movimiento_RETIRO_VALIDO BEFORE INSERT OR UPDATE OF valor ON g9_movimiento
    FOR EACH ROW EXECUTE FUNCTION TRFN_G9_RETIRO_VALIDO();

-----------------------------------------------------------------------------------------
--PUNTO B)4)
CREATE OR REPLACE FUNCTION TRFN_G9_MOVIMIENTO_NULL() RETURNS trigger AS $$
    BEGIN
        IF EXISTS (SELECT 1
            from g9_billetera

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

-------------------------------------------------------------------------------
--------------------INCISO C-------------------

--Inciso C.1.A

create or replace function FN_G9_cotizacionMercado(nombreMercado varchar) returns numeric(20,10) as
$$
    declare
        valor numeric(20,10);
    begin
        valor:=(select m.precio_mercado
                    from g9_mercado m
                    where nombre=nombreMercado);
        return valor;
    end;
$$ language plpgsql;
/*
--Elegimos el mercado de EUR_USDT que el valor del mercado es de 90.8186346726, por ende
-- al ejecutar este select nos da ese valor del mercado.
select FN_G9_cotizacionMercado('Mercado_EUR_USDT');
*/

----------------------------------------------------------------------------
--Inciso C.1.B

/*create or replace function fn_ejecutar_orden() returns trigger as $$

    begin
        if not exists(select 1
                    from g9_orden o
                    where new.tipo!=o.tipo and new.mercado= o.mercado) then
            raise exception 'en este momento no hay disponibilidad';
        else
            if (new.tipo='venta') then
                select* from g9_orden

        end if;

    end

$$ */

--esta durisimo

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

-- Sentencia para verificar
--select FN_G9_ORDENES_MERCADO_FECHA('Mercado_EUR_USDT','08/11/2020');


-----------------------------------------------------------------------------
--Inciso D

--D
--1) Realice una vista que dé el saldo de cada moneda para cada uno de los usuarios.

create view G9_saldoUsuarios as
    select g9b.id_usuario, g9b.moneda, g9b.saldo
    from g9_billetera g9b
    order by g9b.id_usuario;

/*
select *
from G9_saldoUsuarios;--pruebo el funcionamiento de la consulta
*/

--2)Realice una vista que dé el listado de la cantidad de dinero que tiene cada usuario en
-- cada moneda junto con la cotización al momento de ejecutar la vista en BTC y USDT.


create view saldoUsuarios as
    select g9b.id_usuario, g9b.moneda, g9b.saldo, g9m2.moneda_d, g9m2.precio_mercado
    from g9_billetera g9b inner join (select g9m.moneda_d, g9m.precio_mercado, g9m.moneda_o
                                        from g9_mercado g9m
                                        where (g9m.moneda_d='BTC' or g9m.moneda_d='USDT')) g9m2 on g9b.moneda=g9m2.moneda_o
    order by g9b.id_usuario;

select g9b.id_usuario, g9b.moneda, g9b.saldo, g9m2.moneda_d, g9m2.precio_mercado
    from g9_billetera g9b inner join (select g9m.moneda_d, g9m.precio_mercado, g9m.moneda_o
                                        from g9_mercado g9m
                                        where (g9m.moneda_d='BTC' or g9m.moneda_d='USDT')) g9m2
                        on g9b.moneda=g9m2.moneda_o
    order by g9b.id_usuario;

--mauro,anda flama, si no te da resultados, proba cargar mas saldos en billetaras,
-- que sea en una cripto distinta a btc
--lo hice y anduvo. ademas faltan las comparaciones de las monedas contra usdt.

select * from g9_mercado;
select * from g9_billetera;

--3)Realice una vista (usando la vista anterior) que dé los 10 usuarios que más dinero tienen en TOTAL en toda su billetera.

/*
create view mayorSaldo10 as
    select id_usuario
    from saldoUsuarios sU
    limit 10
*/