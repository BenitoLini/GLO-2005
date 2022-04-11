import pymysql
import random
from datetime import datetime

connection = pymysql.connect(
    host="localhost",
    user="root",
    password="Glo2005$$",
    db="projetglo2005",
    autocommit=True
)

cursor = connection.cursor()


def getConnection():
    global connection
    return connection


def getCursos():
    global cursor
    return cursor


def insert_utilisateur(avatar, hash, email, age, username, nom):
    request = f"""INSERT INTO utilisateurs (avatar, hash, email, age, username, nom) VALUE({avatar}, {hash}, {email}, {age}, {username}, {nom});"""
    cursor.execute(request)


def ajouter_avatar(uid,gid):
    Avatar=getGifPath(gid)[0]
    request = f"""UPDATE utilisateurs SET Avatar="{Avatar}" WHERE uid={uid} """
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


def select_Artiste():
    request = 'SELECT avatar, uid, nom FROM utilisateurs'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    random.shuffle(info)
    if len(info) > 6:
        info = info[0:6]
    return info

def select_Story():

    date = str(datetime.now().year) + "-" + str(datetime.now().month) + "-" + str(datetime.now().day-1)
    request = f"DELETE FROM gifs WHERE story=true AND date<'{date}'"
    cursor.execute(request)

    # select LES stories
    request = f'SELECT path, gid FROM gifs WHERE story=true'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    random.shuffle(info)
    return info

def select_6_gif_paths_Click():
    request = 'SELECT path, Gid FROM Gifs ORDER BY NbClick DESC'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    if len(info) > 6:
        info = info[0:6]
    return info

def select_6_gif_paths_Like():
    request = 'SELECT path, Gid FROM Gifs ORDER BY NbLike DESC'
    cursor.execute(request)
    info = cursor.fetchall()
    info = list(info)
    if len(info) > 6:
        info = info[0:6]
    return info


def select_all_gif_paths():
    request = 'SELECT Gid, path FROM Gifs'
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


def getCommentaires(id):
    request = f"""SELECT DISTINCT C.texte, U.username, C.comid FROM Utilisateurs U INNER JOIN Commentaire C ON U.uid = C.uid WHERE C.Gid = {id};"""
    cursor.execute(request)
    commentaires = cursor.fetchall()
    return commentaires


def insert_commentaire(texte, uid, gid):
    request = f"""INSERT INTO commentaire (texte, uid, gid) VALUES({texte}, {uid}, {gid});"""
    cursor.execute(request)


def like(gid, uid, dislike):
    request = f"""INSERT INTO note (Dislike, Uid, Gid) VALUES ({dislike}, {uid}, {gid})"""
    cursor.execute(request)


def getUserGifs(uid):
    request = f"""SELECT G.path, G.Gid FROM gifs G, cree C WHERE G.gid = C.gid AND C.uid = {uid};"""
    cursor.execute(request)
    gifs = cursor.fetchall()
    return gifs


def getFavorisGifs(uid):
    request = f"""SELECT G.path, G.Gid FROM gifs G, favoris F WHERE G.gid = F.gid AND F.uid = {uid};"""
    cursor.execute(request)
    gifs = cursor.fetchall()
    return gifs


def isFavoris(uid, gid):
    request = f"""SELECT F.favid FROM favoris F WHERE F.gid = {gid} AND F.uid = {uid};"""
    cursor.execute(request)
    fav = cursor.fetchone()
    return fav is not None


def ajouterFavoris(uid, gid):
    request = f"""INSERT INTO favoris (Uid, Gid) VALUES ({uid}, {gid})"""
    cursor.execute(request)


def retirerFavoris(uid, gid):
    request = f"""DELETE FROM favoris WHERE uid={uid} AND gid={gid}"""
    cursor.execute(request)


def isCreated(uid, gid):
    request = f"""SELECT C.Creationid FROM cree C WHERE C.gid = {gid} AND C.uid = {uid};"""
    cursor.execute(request)
    create = cursor.fetchone()
    return create is not None


def isLiked(uid, gid):
    request = f"""SELECT N.Noteid FROM Note N WHERE N.gid = {gid} AND N.uid = {uid} AND N.dislike = false;"""
    cursor.execute(request)
    like = cursor.fetchone()
    return like is not None


def isDisliked(uid, gid):
    request = f"""SELECT N.Noteid FROM Note N WHERE N.gid = {gid} AND N.uid = {uid} AND N.dislike = true;"""
    cursor.execute(request)
    dislike = cursor.fetchone()
    return dislike is not None


def ajouterLike(uid, gid):
    if not isCreated(uid, gid):
        if isDisliked(uid, gid):
            request = f"""DELETE FROM note WHERE uid={uid} AND gid={gid}"""
            cursor.execute(request)
            request = f"""INSERT INTO note (Uid, Gid, dislike) VALUES ({uid}, {gid}, false)"""
            cursor.execute(request)
        elif isLiked(uid, gid):
            request = f"""DELETE FROM note WHERE uid={uid} AND gid={gid}"""
            cursor.execute(request)
        else:
            request = f"""INSERT INTO note (Uid, Gid, dislike) VALUES ({uid}, {gid}, false)"""
            cursor.execute(request)


def ajouterDislike(uid, gid):
    if not isCreated(uid, gid):
        if isLiked(uid, gid):
            request = f"""DELETE FROM note WHERE uid={uid} AND gid={gid}"""
            cursor.execute(request)
            request = f"""INSERT INTO note (Uid, Gid, dislike) VALUES ({uid}, {gid}, true)"""
            cursor.execute(request)
        elif isDisliked(uid, gid):
            request = f"""DELETE FROM note WHERE uid={uid} AND gid={gid}"""
            cursor.execute(request)
        else:
            request = f"""INSERT INTO note (Uid, Gid, dislike) VALUES ({uid}, {gid}, true)"""
            cursor.execute(request)


def getGidByCommentaire(commentaire):
    request = f"""SELECT Gid FROM commentaire WHERE comid = {commentaire};"""
    cursor.execute(request)
    Gid = cursor.fetchone()
    return Gid[0]


def getTextByComid(comid):
    request = f"""SELECT texte FROM commentaire WHERE comid = {comid};"""
    cursor.execute(request)
    text = cursor.fetchone()
    return text[0]


def insert_response(texte, uid, comid):
    request = f"""INSERT INTO reponse (texte, uid, comid) VALUES({texte}, {uid}, {comid});"""
    cursor.execute(request)


def getReponses(comid):
    request = f"""SELECT R.texte, U.username FROM Reponse R, utilisateurs U WHERE R.comid = {comid} AND U.uid = R.uid;"""
    cursor.execute(request)
    commentaires = cursor.fetchall()
    return commentaires


def getProfileUserByUid(uid):
    temp_profile = {}
    request = f'SELECT avatar FROM utilisateurs WHERE uid={uid};'
    cursor.execute(request)
    avatar = cursor.fetchone()[0]
    if avatar is None:
        avatar = "https://i.stack.imgur.com/YaL3s.jpg"
    temp_profile["avatar"] = avatar
    request = f'SELECT username FROM utilisateurs WHERE uid={uid};'
    cursor.execute(request)
    temp_profile["username"] = cursor.fetchone()[0]
    temp_profile["pathsgifsuser"] = getUserGifs(uid)
    temp_profile["pathsgifsfavoris"] = getFavorisGifs(uid)
    temp_profile["uid"] = uid
    return temp_profile


def fonctionRecherche(recherche):
    request = f"SELECT Gid, Path FROM gifs WHERE Nom LIKE '%{recherche}%';"
    cursor.execute(request)
    Gifrecherche = list(cursor.fetchall())
    return Gifrecherche


def getGid(nom, story, path, type):
    request = f"SELECT Gid FROM gifs WHERE Nom='{nom}' AND story='{story}' AND Path='{path}' AND type='{type}';"
    cursor.execute(request)
    return cursor.fetchone()[0]


def ajouterGifCree(nom, story, path, type, uid):
    date = f"{datetime.now().year}-{('0' if datetime.now().month < 10 else '') + str(datetime.now().month)}-" \
           f"{('0' if datetime.now().day < 10 else '') + str(datetime.now().day)}"

    path = path.replace("web\\", "").replace("\\", "/")
    ajout_gif = f"""INSERT INTO gifs (Nom, story, Date, Path, type, NbLike) VALUES ('{nom}', {1 if story else 0}, '{date}', {repr(path)}, '{type}', 0);"""
    cursor.execute(ajout_gif)

    request = f"INSERT INTO cree(Uid, Gid) VALUES ({uid}, {getGid(nom, story, path, type)});"
    cursor.execute(request)


def ajouterClick(Gid):
    request = f"UPDATE gifs SET Nbclick = Nbclick + 1 WHERE gid='{Gid}';"
    cursor.execute(request)


if __name__ == "__main__":
    print(fonctionRecherche('oiseau'))

