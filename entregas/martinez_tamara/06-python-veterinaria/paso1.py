import psycopg2

# Datos de conexión
conn = psycopg2.connect(
    host="localhost",
    database="veterinariadb",
    user="postgres",
    password="1904"
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

# Conteo por especie
cursor.execute("SELECT especie, COUNT(*) FROM mascotas GROUP BY especie ORDER BY COUNT(*) DESC;")
especies = cursor.fetchall()

print("\n=== Mascotas por especie ===")
for especie in especies:
    nombre_especie, cantidad = especie
    print(f"  {nombre_especie}: {cantidad}")
# Cierra la conexión
cursor.close()
conn.close()
