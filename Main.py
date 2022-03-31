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
    info = database.select_7_gif_paths()
    temp_profile["paths"] = info
    return render_template("utilisateur.html", profile=temp_profile)


@app.route("/gif.html", methods=["GET", "POST"])
@redirect_if_not_logged
def gif():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    if request.method == "POST":
        commentaire = '"' + request.form.get('commentaire') + '"'
        database.insert_commentaire(commentaire, getBoomer(request.cookies.get("cid")).getUid(), Gid)

    Gif["path"] = database.getGifPath(Gid)
    Gif["Gid"] = Gid
    Gif["nom"] = database.getGifNom(Gid)
    Gif["like"] = database.getGifLike(Gid)
    Gif["dislike"] = database.getGifDislike(Gid)
    Gif["commentaires"] = database.get10Commentaires(Gid)

    return render_template("gif.html", profile=Gif)


if __name__ == "__main__":
    app.run()  # Lancement de l'application Flask
