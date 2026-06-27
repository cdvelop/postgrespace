import psycopg2

def agendar_consulta(conn, fecha, motivo, costo, tutor_id, mascota_id, veterinario_id, servicio_id):
    cursor = conn.cursor()
    try:
        cursor.execute("""
            INSERT INTO consultas_veterinarias
                   (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING id_consulta;
        """, (fecha, motivo, costo, tutor_id, mascota_id, veterinario_id))
        id_consulta = cursor.fetchone()[0]

        cursor.execute("""
            INSERT INTO consulta_servicios (consulta_id, servicio_id)
            VALUES (%s, %s);
        """, (id_consulta, servicio_id))

        conn.commit()
        print(f"Consulta {id_consulta} agendada correctamente")
        return id_consulta

    except psycopg2.Error as e:
        conn.rollback()
        print(f"Error: {e} → no se guardó nada")
        return None
    finally:
        cursor.close()

conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1904"
)
cursor = conn.cursor()

cursor.execute("""
    INSERT INTO mascotas (nombre, especie, edad_meses, tutor_id)
    VALUES (%s, %s, %s, %s)
    RETURNING id_mascota;
""", ("Thor", "Perro", 6, 2))
id_nuevo = cursor.fetchone()[0]
conn.commit()
print(f"Mascota registrada con id: {id_nuevo}")

cursor.execute("""
    UPDATE mascotas SET edad_meses = %s WHERE id_mascota = %s;
""", (8, id_nuevo))
filas_afectadas = cursor.rowcount
conn.commit()
print(f"Actualización: {filas_afectadas} fila(s) modificada(s)")

cursor.execute("""
    SELECT id_mascota, nombre, especie, edad_meses FROM mascotas WHERE id_mascota = %s;
""", (id_nuevo,))
mascota = cursor.fetchone()
print(f"\nVerificación: {mascota}")

cursor.execute("DELETE FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
conn.commit()
print(f"Mascota id {id_nuevo} eliminada")
cursor.execute("SELECT COUNT(*) FROM mascotas WHERE id_mascota = %s;", (id_nuevo,))
conteo = cursor.fetchone()[0]
print(f"Filas con ese id después del DELETE: {conteo}")

try:
    cursor.execute("""
        INSERT INTO consultas_veterinarias
               (fecha_consulta, motivo, costo, tutor_id, mascota_id, veterinario_id)
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING id_consulta;
    """, ("2026-06-22", "Control anual", 25.00, 1, 1, 1))
    id_consulta = cursor.fetchone()[0]
    cursor.execute("""
        INSERT INTO consulta_servicios (consulta_id, servicio_id)
        VALUES (%s, %s);
    """, (id_consulta, 1))
    conn.commit()
    print(f"\nConsulta {id_consulta} y su servicio registrados juntos")
except psycopg2.Error as e:
    conn.rollback()
    print(f"Error: {e} → no se guardó nada")

agendar_consulta(conn, "2026-06-25", "Revisión general", 30.00, 2, 3, 2, 2)

cursor.close()
conn.close()
