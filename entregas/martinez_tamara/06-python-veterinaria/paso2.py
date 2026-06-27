import psycopg2

conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1904"
)
cursor = conn.cursor()

print("=== Buscador de tutores (versión segura) ===")
nombre = input("Nombre del tutor: ")

cursor.execute(
    "SELECT id_tutor, nombre, telefono FROM tutores WHERE nombre = %s",
    (nombre,)
)

resultados = cursor.fetchall()

if resultados:
    for fila in resultados:
        print(f"  id={fila[0]}  nombre={fila[1]}  tel={fila[2]}")
else:
    print("Ningún tutor encontrado.")

# Resumen de un tutor con fetchone()
tutor_id = 1

cursor.execute("""
    SELECT t.nombre,
           COUNT(cv.id_consulta)          AS consultas,
           COALESCE(SUM(cv.costo), 0)     AS total_gastado
    FROM tutores t
    LEFT JOIN consultas_veterinarias cv ON cv.tutor_id = t.id_tutor
    WHERE t.id_tutor = %s
    GROUP BY t.nombre;
""", (tutor_id,))

fila = cursor.fetchone()

if fila:
    nombre, consultas, total = fila
    print(f"\nTutor:     {nombre}")
    print(f"Consultas: {consultas}")
    print(f"Total:     ${total:.2f}")
else:
    print("Tutor no encontrado")

# Historial completo de consultas del tutor
cursor.execute("""
    SELECT m.nombre, cv.fecha_consulta, cv.motivo, cv.costo, v.nombre
    FROM consultas_veterinarias cv
    JOIN mascotas m ON m.id_mascota = cv.mascota_id
    JOIN veterinarios v ON v.id_veterinario = cv.veterinario_id
    WHERE cv.tutor_id = %s
    ORDER BY cv.fecha_consulta DESC;
""", (tutor_id,))

historial = cursor.fetchall()

print(f"\n=== Historial de consultas de {nombre} ===")
for fila in historial:
    mascota, fecha, motivo, costo, veterinario = fila
    print(f"  {fecha} | {mascota} | {motivo} | ${costo} | {veterinario}")

# Cierra al final
cursor.close()
conn.close()
