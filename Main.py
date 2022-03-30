from flask import Flask, render_template, request
from lib.boomer import Boomer
from lib import database
from hashlib import sha256

app = Flask("BoomBird", template_folder="web", static_folder="web\\css")  # Création de l'application FLASK
GifPaths = {}  # ?
Profile = {}  # ?

sessions = dict()  # Dictionnaire qui stoque les sessions des utilisateurs


@app.route("/")
def page_principale():  # Rendu de la page principale (index.html)
    return render_template("index.html")


@app.route("/login.html", methods=["GET", "POST"])
def login():  # Rendu de la page login (login.html)
    if request.method == "POST":
        email = f'\"{request.form.get("email")}\"'
        hash_ = sha256(request.form.get('hash').encode()).hexdigest()

        # TODO continuer la séquence de login

        return render_template("login.html")  # TODO Deux cas possibles 1) Bon login -> index.html 2) Mauvais login
                                              # TODO -> login.html + erreur
    else:
        return render_template("login.html")


@app.route("/signup.html", methods=["GET", "POST"])
def signup():  # Rendu de la page signup (signup.html)  # TODO ajouter un bouton dans index.html -> signup.html
    if request.method == "POST":

        # TODO continuer la séquence de signup

        return render_template("signup.html")  # TODO Deux cas possibles 1) Bon signup -> index.html 2) Mauvais
                                               # TODO signup -> signup.html + erreur
    else:
        return render_template("signup.html")


if __name__ == "__main__":
    app.run()  # Lancement de l'application Flask
