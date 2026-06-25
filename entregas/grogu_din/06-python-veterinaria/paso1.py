import psycopg2

# Datos de conexión
conn = psycopg2.connect(
    host="postgres",
    database="veterinariadb",
    user="postgres",
    password="1234"
)

# Cursor: el objeto que ejecuta SQL
cursor = conn.cursor()

# Ejecuta una consulta
cursor.execute("SELECT nombre, especie FROM mascotas ORDER BY nombre;")

# Obtén todos los resultados
mascotas = cursor.fetchall()

# Muéstralos
print("=== Mascotas registradas ===")
for mascota in mascotas:
    nombre, especie = mascota
    print(f"  {nombre} ({especie})")

print(f"\nTotal: {len(mascotas)} mascotas")

# Cierra la conexión
cursor.close()
conn.close()