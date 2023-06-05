import csv
import psycopg2
from config import host, user, password, db_name
from datetime import datetime

# Подключение к базе данных
conn = psycopg2.connect(
    host=host,
    user=user,
    password=password,
    database=db_name
)

# Создание объекта курсора
cur = conn.cursor()

# Создание таблицы
create_table_query = """
    CREATE TABLE IF NOT EXISTS Game_data (
        user_id uuid,
        created_at timestamp,
        revenue numeric,
        event_name text
    )
"""
cur.execute(create_table_query)

# Загрузка данных из файлов
for i in range(1, 11):
    filename = f'D:/Helen71.github.io/Desktop/ANALYTIC/test/file_{i:02}.csv'
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile)
        next(reader)  # Пропуск заголовка, если есть
        for row in reader:
            # Преобразование строки с датой и временем в объект datetime
            timestamp = datetime.strptime(row[1], '%Y-%m-%d %H:%M:%S')
            insert_query = "INSERT INTO Game_data (user_id, created_at, revenue, event_name) VALUES (%s, %s, %s, %s)"
            cur.execute(insert_query, (row[0], timestamp, row[2], row[3]))

    print(f"File {filename} uploaded.")

# Фиксация изменений и закрытие соединения
conn.commit()
cur.close()
conn.close()