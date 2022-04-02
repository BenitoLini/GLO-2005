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
    gid = request.args.get("Gid", default=None, type=int)
    fav = request.args.get("fav", default=None, type=int)
    like = request.args.get("like", default=None, type=int)
    dislike = request.args.get("dislike", default=None, type=int)
    commentaire = request.args.get("commentaire", default=None, type=int)
    comid = request.args.get("comid", default=None, type=int)

    cookie = ""
    for key in sessions:
        cookie = key
    boomer = getBoomer(cookie)
    uid = boomer.getUid()
    if fav == 1:
        if not database.isFavoris(uid, gid):
            database.ajouterFavoris(uid, gid)
        else:
            database.retirerFavoris(uid, gid)

    if like == 1:
        database.ajouterLike(uid, gid)

    if dislike == 1:
        database.ajouterDislike(uid, gid)

    if commentaire == 1:
        commentaire = '"' + request.form.get('commentaire') + '"'
        if commentaire != '""':
            database.insert_commentaire(commentaire, getBoomer(request.cookies.get("cid")).getUid(), gid)



    Gif["path"] = database.getGifPath(gid)
    Gif["Gid"] = gid
    Gif["comid"] = comid
    if database.isFavoris(uid, gid):
        Gif["nom"] = database.getGifNom(gid)[0] + "**"
    else:
        Gif["nom"] = database.getGifNom(gid)[0]

    Gif["like"] = database.getGifLike(gid)
    Gif["dislike"] = database.getGifDislike(gid)

    liste = []
    for i in database.getCommentaires(gid):
        liste += (database.getReponses(i[2]))

    if comid != None:
        if request.method == "POST":
            reponse = '"' + request.form.get('reponse') + '"'
            if reponse != '""':
                database.insert_response(reponse, uid, comid)
        else:
            return render_template("response.html", profile=Gif)

    commentaires = database.getCommentaires(gid)
    commentairesreponses = []
    for i in commentaires:
        commentairesreponses.append(i + (database.getReponses(i[2]),))
    Gif["commentaires"] = commentairesreponses

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
