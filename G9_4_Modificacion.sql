--inciso E


--lo que hicimos fue modificar nuestra funcion que ejecuta la orden,y  modifica las billeteras, para que
-- en vez de setear la orden como completa, genere una nueva con el remanente

create or replace function fn_G9_ejecutar_orden_remanente(id_orden integer, ingreso integer, cantidad integer, mercado1 varchar, tipo_orden varchar, id_user integer, mon_d varchar, mon_o varchar) returns integer as $$
    declare
        suma integer;
        rec record;
    begin
    suma :=0;
    if tipo_orden='Compra' then
        for rec in (SELECT *  FROM G9_orden_venta o where o.mercado=mercado1 and o.estado='Pendiente' and ingreso>=o.valor) loop
             exit when ((suma+(rec.valor*rec.cantidad))>ingreso*cantidad);

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
        update g9_billetera b set saldo=(saldo-ingreso) where b.id_usuario=id_user and b.moneda= mon_o;

        --linea agregada, genera una orden por el remanente de lo que queria comprar menos lo que pudo comprar
        --a su vez eliminamos la linea que daba la orden por cumplida en la funcion original
        -------------------------------------------------------------------------

        update g9_orden o set valor=(ingreso-suma) where o.id=id_orden;

        --------------------------------------------------------------------------
    else
        for rec in (SELECT *  FROM G9_orden_compra o where o.mercado=mercado1 and o.estado='Pendiente' and ingreso<=o.valor) loop
             exit when ((suma+(rec.valor*rec.cantidad))>ingreso*cantidad);
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
        update g9_billetera b set saldo=(saldo+ingreso) where b.id_usuario=id_user and b.moneda= mon_o;

        --linea agregada, genera una orden nueva, con los datos originales de la anterior, pero con distinto valor
        --el nuevo valor esta dado por lo que queria vender, menos lo que pudo vender, a su vez, tambien se elimino
        --la orden anterior que seteaba la orden como cumplida
        --------------------------------------------------------------------------

        update g9_orden o set valor=(ingreso-suma) where o.id=id_orden;

        --------------------------------------------------------------------------
    end if;
    return (suma);
    end
$$ language plpgsql;


-- ** ACLARACION **
/*

 Al llamarse esta funcion, al momento de realizar el update en el valor de la orden activaria el trigger que ejecuta las ordenes.
 Como se pide no alterar servicios anteriores no llamamos a esta funcion. Pero la dejamos explicita para demostrar los cambios realizados
 sobre la funcion anterior, hecha en el archivo soluciones 3.

 */