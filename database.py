import pymysql
import random

connection = pymysql.connect(
    host="localhost",
    user="root",
    password="Glo2005$$",
    db="projetglo2005",
    autocommit=True
)

cursor = connection.cursor()


def insert_utilisateur(Uid, avatar, hash, email, age, username, nom):
    request = f"""INSERT INTO utilisateurs VALUE({Uid}, {avatar}, {hash}, {email}, {age}, {username}, {nom});"""
    cursor.execute(request)


def insert_createur(Uid, avatar, hash, email, age, username, nom):
    request = f"""INSERT INTO createurs VALUE({Uid}, {avatar}, {hash}, {email}, {age}, {username}, {nom});"""
    cursor.execute(request)


def select_hash_utilisateur(email):
    request = f"""SELECT * FROM utilisateurs WHERE email={email};"""
    cursor.execute(request)
    user = cursor.fetchone()
    return user


def select_hash_createur(email):
    request = f"""SELECT * FROM createurs WHERE email={email};"""
    cursor.execute(request)
    user = cursor.fetchone()
    return user


def select_24_gif_paths():
    request = 'SELECT path FROM Gifs'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    if len(info) > 24:
        info = info[0:24]
    random.shuffle(info)
    return info


if __name__ == "__main__":
    print(select_24_gif_paths())
    print(select_hash_utilisateur("gabrieljeanson@outlook.fr"))
    print(select_hash_createur("w42342"))
