from flask import Flask, render_template, request
import pymysql, pymysql.cursors
from test import *
import random

app = Flask(__name__)
ProfileUtilisateur = {}

@app.route("/")
def main():
    conn = pymysql.connect(host='localhost', user='root', password='sql0219', db='projetglo2005')
    cmd = 'SELECT path FROM Gifs'
    cur = conn.cursor()
    cur.execute(cmd)
    info = cur.fetchall()
    info = list(info)
    random.shuffle(info)
    global ProfileUtilisateur
    if len(info) <= 24:
        ProfileUtilisateur["paths"] = info
    else:
        ProfileUtilisateur["paths"] = info[0:24]
    ProfileUtilisateur["long"] = len(info)
    print(len(info))
    return render_template('page1HTML.html', profile=ProfileUtilisateur)

@app.route("/login")
def login():
    return render_template('login.html')

@app.route("/signup")
def signup():
    return render_template('signup.html')

@app.route("/principal", methods=['POST'])
def principal():

    email = '"'+request.form.get('email')+'"'
    passe = hachage(request.form.get('hash'))
    UC = request.form.get('utilisateurcreateur')

    conn= pymysql.connect(host='localhost',user='root', password='sql0219',db='projetglo2005')

    if UC == "utilisateur":
        cmd='SELECT hash FROM utilisateurs WHERE email='+email+';'
    else:
        cmd='SELECT hash FROM createurs WHERE email='+email+';'
    cur=conn.cursor()
    cur.execute(cmd)
    passeVrai = cur.fetchone()
    print(passe)
    print(passeVrai)

    if (passeVrai!=None) and (passe==passeVrai[0]):

        if UC == "utilisateur":
            cmd='SELECT * FROM utilisateurs WHERE Email='+email+';'
        else:
            cmd = 'SELECT * FROM createurs WHERE Email=' + email + ';'
        cur=conn.cursor()
        cur.execute(cmd)
        info = cur.fetchone()

        global ProfileUtilisateur
        ProfileUtilisateur["Uid"]=info[0]
        ProfileUtilisateur["avatar"]=info[1]
        ProfileUtilisateur["hash"]=info[2]
        ProfileUtilisateur["Email"] = info[3]
        ProfileUtilisateur["age"] = info[4]
        ProfileUtilisateur["username"] = info[5]
        ProfileUtilisateur["name"] = info[6]

        if UC == "utilisateur":
            return render_template('principal.html', profile=ProfileUtilisateur)
        else:
            #cmd = f'CREATE TEMPORARY TABLE OeuvresCreateur AS Createurs WHERE Createur.nom = {ProfileUtilisateur["nom"]}'
            return render_template('createurs.html', profile=ProfileUtilisateur)

    return render_template('login.html', message="Informations invalides!")

@app.route("/login2", methods=['POST'])
def login2():

    email = '"'+request.form.get('email')+'"'
    passe = '"'+request.form.get('hash')+'"'
    passe = hachage(passe)
    Uid = request.form.get('Uid')
    age = request.form.get('age')
    username = '"'+request.form.get('username')+'"'
    avatar = '"'+request.form.get('avatar')+'"'
    nom = '"'+request.form.get('nom')+'"'
    UC = request.form.getlist('utilisateurcreateur')

    if UC == []:
        return render_template('signup.html')

    conn= pymysql.connect(host='localhost', user='root', password='sql0219', db='projetglo2005')
    cur=conn.cursor()
    if UC == ['utilisateur']:
        cmd='INSERT INTO utilisateurs VALUE('+Uid+', '+avatar+', '+passe+', '+email+', '+age+', '+username+', '+nom+');'
    elif UC == ['createur']:
        cmd='INSERT INTO createurs VALUE('+Uid+', '+avatar+', '+passe+', '+email+', '+age+', '+username+', '+nom+');'
    elif UC == ['utilisateur', 'createur']:
        cmd='INSERT INTO utilisateurs VALUE('+Uid+', '+avatar+', '+passe+', '+email+', '+age+', '+username+', '+nom+');'
        cmd2='INSERT INTO createurs VALUE('+Uid+', '+avatar+', '+passe+', '+email+', '+age+', '+username+', '+nom+');'
        cur.execute(cmd2)
    cur.execute(cmd)
    conn.commit()

    return render_template('login.html', profile=ProfileUtilisateur)



if __name__ == '__main__':
    app.run()




from flask import Flask, render_template, request, make_response, redirect, url_for
from lib.boomer import Boomer
from lib import database
from hashlib import sha256
from functools import wraps

app = Flask("BoomBird", template_folder="web", static_folder="web\\css")  # Création de l'application FLASK
Gif = {}  # ?

sessions = dict()  # Dictionnaire qui stoque les sessions des utilisateurs


def redirect_if_logged(f):
    @wraps(f)
    def decorator():
        if is_a_logged_user():
            return redirect(url_for("utilisateur"))
        else:
            return f()

    return decorator


def redirect_if_not_logged(f):
    @wraps(f)
    def decorator():
        if is_a_logged_user():
            return f()
        else:
            return redirect(url_for("login"))

    return decorator


def is_a_logged_user():
    return request.cookies.get("cid") in sessions


def addBoomer(email):
    boomer = Boomer.getUtilisateur(database.getConnection(), email)
    sessions[boomer.getCookie()] = boomer

    response = make_response(redirect(url_for("utilisateur")))
    response.set_cookie("cid", boomer.getCookie(), max_age=60 * 15)  # 15 minutes?
    return response


def removeBoomer(cookie):
    sessions.pop(cookie)
    response = make_response(redirect(url_for("page_principale")))
    response.delete_cookie("cid")
    return response


def getBoomer(cookie) -> Boomer:
    return sessions[cookie]


@app.route("/")
def page_principale():  # Rendu de la page principale (index.html)
    return render_template("index.html")


@app.route("/login.html", methods=["GET", "POST"])
@redirect_if_logged
def login():  # Rendu de la page login (login.html)
    if request.method == "POST":
        email = f'\"{request.form.get("email")}\"'
        hash_ = sha256(request.form.get('hash').encode()).hexdigest()

        if database.verifierHash(email, hash_):
            return addBoomer(email)
        else:
            return render_template('login.html', message="Informations de connexion invalides!")

    return render_template("login.html")


@app.route("/signup.html", methods=["GET", "POST"])
@redirect_if_logged
def signup():  # Rendu de la page signup (signup.html)  # TODO ajouter un bouton dans index.html -> signup.html
    if request.method == "POST":

        email = '"' + request.form.get('email') + '"'
        hash_ = request.form.get('hash')
        hash_ = '"' + sha256(hash_.encode()).hexdigest() + '"'
        age = request.form.get('age')
        username = f'\"{request.form.get("username")}\"'
        avatar = f'\"{request.form.get("avatar")}\"'
        nom = f'\"{request.form.get("nom")}\"'

        # TODO Ajouter check voir si email existe deja, un champ vide, etc.

        database.insert_utilisateur(avatar, hash_, email, age, username, nom)

        return render_template('login.html')
    else:
        return render_template("signup.html")


@app.route("/utilisateur.html", methods=["GET"])
@redirect_if_not_logged
def utilisateur():  # Rendu de la page utilisateur (utilisateur.html)
    temp_profile = dict()
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    avatar = boomer.getAvatar()
    uid = boomer.getUid()


    info = database.select_7_gif_paths()
    temp_profile["paths"] = info
    temp_profile["avatar"] = avatar
    temp_profile["uid"] = uid
    return render_template("utilisateur.html", profile=temp_profile)


@app.route("/gif.html", methods=["GET", "POST"])
@redirect_if_not_logged
def gif():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()


    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    if database.isFavoris(uid, Gid):
        Gif["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]

    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)
    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))
    Gif["reponses"] = listeReponses

    return render_template("gif.html", profile=Gif)




@app.route("/upload.html", methods=["GET", "POST"])
@redirect_if_not_logged
def upload():
    if request.method == "POST":

        return render_template("upload.html")
    return render_template("upload.html")

@app.route("/profileUser.html", methods=["GET", "POST"])
@redirect_if_not_logged
def profileUser():
    uid = request.args.get("uid", default=None, type=str)
    temp_profile = dict()
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    temp_profile["avatar"] = boomer.getAvatar()
    temp_profile["uid"] = uid
    temp_profile["pathsgifsuser"] = database.getUserGifs(uid)
    temp_profile["pathsgifsfavoris"] = database.getFavorisGifs(uid)
    temp_profile["username"] = boomer.getUsername()

    if request.method == "POST":

        return render_template("profileUser.html", profile = temp_profile)
    return render_template("profileUser.html", profile = temp_profile)


@app.route("/gifcom.html", methods=["GET", "POST"])
@redirect_if_not_logged
def gifcom():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()

    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))
    Gif["reponses"] = listeReponses

    commentaire = '"' + request.form.get('commentaire') + '"'
    if commentaire != '""':
        database.insert_commentaire(commentaire, getBoomer(request.cookies.get("cid")).getUid(), Gid)

    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    if database.isFavoris(uid, Gid):
        Gif["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]

    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)

    return render_template("gif.html", profile=Gif)

@app.route("/giffav.html", methods=["GET", "POST"])
@redirect_if_not_logged
def giffav():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()

    if not database.isFavoris(uid, Gid):
        database.ajouterFavoris(uid, Gid)
    else:
        database.retirerFavoris(uid,Gid)

    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))
    Gif["reponses"] = listeReponses

    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    if database.isFavoris(uid, Gid):
        Gif["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]

    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)

    return render_template("gif.html", profile=Gif)


@app.route("/giflike.html", methods=["GET", "POST"])
@redirect_if_not_logged
def giflike():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()

    database.ajouterLike(uid, Gid)

    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))
    Gif["reponses"] = listeReponses

    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    if database.isFavoris(uid, Gid):
        Gif["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]
    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)

    return render_template("gif.html", profile=Gif)


@app.route("/gifdislike.html", methods=["GET", "POST"])
@redirect_if_not_logged
def gifdislike():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()

    database.ajouterDislike(uid, Gid)

    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))
    Gif["reponses"] = listeReponses

    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    if database.isFavoris(uid, Gid):
        Gif["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]
    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)

    return render_template("gif.html", profile=Gif)

@app.route("/gifresponse.html", methods=["GET", "POST"])
@redirect_if_not_logged
def gifresponse():
    comid = request.args.get("comid", default=None, type=int)
    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()
    Gid = database.getGidByCommentaire(comid)

    listeReponses = []
    for i in range(len(database.get10Commentaires(Gid))):
        listeReponses.append(database.getReponses(database.get10Commentaires(Gid)[i][2]))


    temp_profile = {}
    temp_profile["reponses"] = listeReponses
    temp_profile["comid"] = comid
    temp_profile["commentaire"] = database.getTextByComid(comid)
    temp_profile["path"] = database.getGifPath(Gid)
    if database.isFavoris(uid, Gid):
        temp_profile["nom"] = database.getGifNom(Gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(Gid)[0]
    temp_profile["Gid"] = Gid
    temp_profile["path"] = database.getGifPath(Gid)
    temp_profile["like"] = database.getGifLike(Gid)
    temp_profile["dislike"] = database.getGifDislike(Gid)
    temp_profile["commentaires"] = database.get10Commentaires(Gid)
    if request.method == "POST":
        reponse = '"' + request.form.get('reponse') + '"'
        if reponse != '""':
            database.insert_response(reponse, uid, comid)
        return render_template("gif.html", profile=temp_profile)
    return render_template("response.html", profile=temp_profile)

if __name__ == "__main__":
    app.run()  # Lancement de l'application Flask