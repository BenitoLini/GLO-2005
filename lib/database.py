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


def insert_utilisateur(avatar, hash, email, age, username, nom):
    request = f"""INSERT INTO utilisateurs (avatar, hash, email, age, username, nom) VALUE({avatar}, {hash}, {email}, {age}, {username}, {nom});"""
    cursor.execute(request)


def select_hash_utilisateur(email):
    request = f"""SELECT * FROM utilisateurs WHERE email={email};"""
    cursor.execute(request)
    user = cursor.fetchone()
    return user


def select_24_gif_paths():
    request = 'SELECT path, Gid FROM Gifs'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    random.shuffle(info)
    if len(info) > 24:
        info = info[0:24]

    return info

def select_7_gif_paths():
    request = 'SELECT path, Gid FROM Gifs'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    random.shuffle(info)
    if len(info) > 7:
        info = info[0:7]

    return info


def select_all_gif_paths():
    request = 'SELECT path, Gid FROM Gifs'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    random.shuffle(info)
    return info

def verifierHash(email, hash):
    vraiHash = select_hash_utilisateur(email)
    if vraiHash is None:
        return False

    if hash == vraiHash[2]:

        return True
    else:
        return False

def getGifNom(id):
    request = f"""SELECT nom FROM gifs WHERE Gid={id};"""
    cursor.execute(request)
    nom = cursor.fetchone()
    return nom

def getGifPath(id):
    request = f"""SELECT path FROM gifs WHERE Gid={id};"""
    cursor.execute(request)
    path = cursor.fetchone()
    return path

def getGifLike(id):
    request = f"""SELECT COUNT(*) FROM Note N, Gifs G WHERE G.Gid={id} AND N.Gid = G.gid AND N.dislike = false;"""
    cursor.execute(request)
    nblike = cursor.fetchone()
    return nblike

def getGifDislike(id):
    request = f"""SELECT COUNT(*) FROM Note N, Gifs G WHERE G.Gid={id} AND N.Gid = G.gid AND N.dislike = true;"""
    cursor.execute(request)
    nbdislike = cursor.fetchone()
    return nbdislike

def get10Commentaires(id):
    request = f"""SELECT C.texte, U.username FROM Commentaire C, Gifs G, Utilisateurs U WHERE G.Gid={id} AND C.Gid = G.gid AND U.uid = C.uid;"""
    cursor.execute(request)
    commentaires = cursor.fetchall()
    return commentaires

def insert_commentaire(texte, uid, gid):
    request = f"""INSERT INTO commentaire (texte, uid, gid) VALUES({texte}, {uid}, {gid});"""
    cursor.execute(request)

if __name__ == "__main__":
    print(verifierHash("'gabrieljeanson@outlook.fr'", 'test123'))




