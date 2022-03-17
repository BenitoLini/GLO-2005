from flask import Flask, render_template, request
from Boomer import Boomer
import database

app = Flask(__name__)
GifPaths = {}

sessions = dict()


def add_boomer(boomer):
    cookie = boomer.getCookie()
    sessions[cookie] = boomer
    final_response = app.make_response(render_template("principal.html"))
    final_response.set_cookie("session-id", value=cookie, max_age=60 * 15)  # TODO changer max_age
    return final_response, cookie


def get_boomer_by_cookie(cookie):
    boomer = None

    for _, boomer_ in sessions.items():
        if _ == cookie:
            boomer = boomer_

    return boomer


def remove_boomer_by_cookie(cookie):
    sessions.pop(cookie)


def remove_boomer(boomer):
    for _, _boomer in sessions.items():
        if boomer == _boomer:
            sessions.pop(_)


def redirect_logged_user(not_log_redirect=None, not_log_profile=None):
    if "session-id" in request.cookies.keys():
        cookie = request.cookies["session-id"]

        boomer = get_boomer_by_cookie(cookie)

        if boomer is None:
            return render_template('login.html', message="Session expirée!")

        return render_template("principal.html")

    if not_log_redirect is None:
        return None
    return render_template(not_log_redirect, profile=not_log_profile)


@app.route("/")
def main():
    info = database.select_24_gif_paths()
    global GifPaths
    GifPaths["paths"] = info
    GifPaths["long"] = len(info)

    return redirect_logged_user('page1HTML.html', GifPaths)


@app.route("/login")
def login():
    return redirect_logged_user("login.html")


@app.route("/signup")
def signup():
    return redirect_logged_user("signup.html")


@app.route("/principal", methods=['POST'])
def principal():
    email = f'\"{request.form.get("email")}\"'
    hash_ = request.form.get('hash')
    UC = request.form.get('utilisateurcreateur')

    if UC == "utilisateur":
        passeVrai = database.select_hash_utilisateur(email)
    else:
        passeVrai = database.select_hash_createur(email)

    response = redirect_logged_user()

    if response is not None:
        return response

    if (passeVrai is not None) and (hash_ == passeVrai[2]):
        if UC == "utilisateur":
            # Example de l'utilisation de la classe Boomer
            final_response, cookie = add_boomer(Boomer.getUtilisateur(database.connection, email, hash_))

            print(sessions)
            boomer = sessions[cookie]
            print(boomer.getHash(), boomer.getUid(), boomer.getAvatar(), boomer.IS_CREATEUR)

            return final_response  # render_template('principal.html')
        else:
            return render_template('createurs.html')  # TODO faire la meme chose que utilisateur

    return render_template('login.html', message="Informations invalides!")


@app.route("/login2", methods=['POST'])
def login2():
    email = '"' + request.form.get('email') + '"'
    hash_ = '"' + request.form.get('hash') + '"'
    uid = request.form.get('Uid')
    age = request.form.get('age')
    username = f'\"{request.form.get("username")}\"'
    avatar = f'\"{request.form.get("avatar")}\"'
    nom = f'\"{request.form.get("nom")}\"'
    UC = request.form.getlist('utilisateurcreateur')

    if not UC:
        return render_template('signup.html')

    if UC == ['utilisateur']:
        database.insert_utilisateur(uid, avatar, hash_, email, age, username, nom)
    elif UC == ['createur']:
        database.insert_createur(uid, avatar, hash_, email, age, username, nom)
    elif UC == ['utilisateur', 'createur']:
        database.insert_utilisateur(uid, avatar, hash_, email, age, username, nom)
        database.insert_createur(uid, avatar, hash_, email, age, username, nom)

    return render_template('login.html')


if __name__ == '__main__':
    app.run()
