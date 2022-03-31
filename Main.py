from flask import Flask, render_template, request, jsonify
from lib.boomer import Boomer
from lib import database
from hashlib import sha256

app = Flask("BoomBird", template_folder="web", static_folder="web\\css")  # Création de l'application FLASK
Gif = {}  # ?
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
        print(database.verifierHash(email, hash_))
        # TODO continuer la séquence de login

        if database.verifierHash(email, hash_):

            return render_template("utilisateur.html")
            # TODO Deux cas possibles 1) Bon login -> index.html 2) Mauvais login
                                              # TODO -> login.html + erreur
        else:
            return render_template('login.html', message="Informations invalides!")
    else:
        return render_template("login.html")


@app.route("/signup.html", methods=["GET", "POST"])
def signup():  # Rendu de la page signup (signup.html)  # TODO ajouter un bouton dans index.html -> signup.html
    if request.method == "POST":

        email = '"' + request.form.get('email') + '"'
        hash_ = request.form.get('hash')
        hash_ = '"' + sha256(hash_.encode()).hexdigest() + '"'
        age = request.form.get('age')
        username = f'\"{request.form.get("username")}\"'
        avatar = f'\"{request.form.get("avatar")}\"'
        nom = f'\"{request.form.get("nom")}\"'
        database.insert_utilisateur(avatar, hash_, email, age, username, nom)

        # TODO continuer la séquence de signup
        return render_template('login.html')
    else:
        return render_template("signup.html")

@app.route("/utilisateur.html", methods=["GET", "POST"])
def utilisateur():  # Rendu de la page signup (signup.html)  # TODO ajouter un bouton dans index.html -> signup.html

    email = f'\"{request.form.get("email")}\"'
    hash_ = sha256(request.form.get('hash').encode()).hexdigest()

    if database.verifierHash(email, hash_):
        global Profile
        info = database.select_7_gif_paths()
        Profile["paths"] = info
        return render_template("utilisateur.html", profile=Profile)

    else:
        return render_template('login.html', message="Informations invalides!")

@app.route("/gif.html", methods=["GET", "POST"])
def gif():  # Rendu de la page principale (index.html)
    Gid = request.args.get("Gid", default=None, type=str)
    if request.method == "POST":
         commentaire = '"' + request.form.get('commentaire') + '"'
         database.insert_commentaire(commentaire, 1, Gid)
    global Gif
    path = database.getGifPath(Gid)
    nom = database.getGifNom(Gid)
    nblike = database.getGifLike(Gid)
    nbdislike = database.getGifDislike(Gid)
    commentaires = database.get10Commentaires(Gid)
    Gif["path"] = path
    Gif["Gid"] = Gid
    Gif["nom"] = nom
    Gif["like"] = nblike
    Gif["dislike"] = nbdislike
    Gif["commentaires"] = commentaires

    return render_template("gif.html", profile = Gif)




if __name__ == "__main__":
    app.run()  # Lancement de l'application Flask
