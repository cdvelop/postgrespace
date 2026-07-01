## Paso 3.1
SELECT
    c.id_consulta      AS "N°",
    m.nombre           AS "Mascota",
    c.motivo           AS "Motivo",
    s.nombre           AS "Servicio",
    s.precio           AS "Precio"
FROM consultas_veterinarias c
INNER JOIN mascotas           m  ON c.mascota_id  = m.id_mascota
INNER JOIN consulta_servicios cs ON c.id_consulta = cs.consulta_id
INNER JOIN servicios          s  ON cs.servicio_id = s.id_servicio
ORDER BY c.id_consulta;

## Paso 3.2
SELECT
    s.nombre              AS servicio,
    COUNT(*)              AS veces_usado,
    SUM(s.precio)         AS ingreso_total
FROM servicios s
INNER JOIN consulta_servicios cs ON s.id_servicio = cs.servicio_id
GROUP BY s.nombre
ORDER BY ingreso_total DESC;

**Cuantos servicios incluyó cada consulta y el precio total**
SELECT
    cs.consulta_id        AS consulta,
    COUNT(*)              AS num_servicios,
    SUM(s.precio)         AS total_servicios
FROM consulta_servicios cs
INNER JOIN servicios s ON cs.servicio_id = s.id_servicio
GROUP BY cs.consulta_id
ORDER BY cs.consulta_id;

## Paso 3.3
SELECT
    v.nombre              AS veterinario,
    v.especialidad,
    COUNT(c.id_consulta)  AS consultas_atendidas
FROM veterinarios v
INNER JOIN consultas_veterinarias c ON v.id_veterinario = c.veterinario_id
GROUP BY v.nombre, v.especialidad
ORDER BY consultas_atendidas DESC;

## Paso 3.4
SELECT
    c.fecha_consulta AS "Fecha",
    t.nombre         AS "Tutor",
    m.nombre         AS "Mascota",
    v.nombre         AS "Veterinario",
    s.nombre         AS "Servicio",
    s.precio         AS "Precio"
FROM consultas_veterinarias c
INNER JOIN tutores            t  ON c.tutor_id      = t.id_tutor
INNER JOIN mascotas           m  ON c.mascota_id    = m.id_mascota
INNER JOIN veterinarios       v  ON c.veterinario_id = v.id_veterinario
INNER JOIN consulta_servicios cs ON c.id_consulta   = cs.consulta_id
INNER JOIN servicios          s  ON cs.servicio_id  = s.id_servicio
ORDER BY c.fecha_consulta, m.nombre;