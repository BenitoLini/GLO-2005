from flask import Flask, render_template, request
import pymysql, pymysql.cursors
import random
from Boomer import Boomer
import database

app = Flask(__name__)
GifPaths = {}

@app.route("/")
def main():
    info = database.select_24_gif_paths()
    global GifPaths
    GifPaths["paths"] = info
    GifPaths["long"] = len(info)
    return render_template('page1HTML.html', profile=GifPaths)

@app.route("/login")
def login():
    return render_template('login.html')

@app.route("/signup")
def signup():
    return render_template('signup.html')

@app.route("/principal", methods=['POST'])
def principal():
    email = '"'+request.form.get('email')+'"'
    passe = request.form.get('hash')
    UC = request.form.get('utilisateurcreateur')

    if UC == "utilisateur":
        passeVrai = database.select_hash_utilisateur(email)
    else:
        passeVrai = database.select_hash_createur(email)

    if (passeVrai is not None) and (passe == passeVrai[2]):

        if UC == "utilisateur":
            return render_template('principal.html')
        else:
            return render_template('createurs.html')

    return render_template('login.html', message="Informations invalides!")

@app.route("/login2", methods=['POST'])
def login2():
    email = '"'+request.form.get('email')+'"'
    hash = '"'+request.form.get('hash')+'"'
    Uid = request.form.get('Uid')
    age = request.form.get('age')
    username = '"'+request.form.get('username')+'"'
    avatar = '"'+request.form.get('avatar')+'"'
    nom = '"'+request.form.get('nom')+'"'
    UC = request.form.getlist('utilisateurcreateur')

    if not UC:
        return render_template('signup.html')

    if UC == ['utilisateur']:
        database.insert_utilisateur(Uid, avatar, hash, email, age, username, nom)
    elif UC == ['createur']:
        database.insert_createur(Uid, avatar, hash, email, age, username, nom)
    elif UC == ['utilisateur', 'createur']:
        database.insert_utilisateur(Uid, avatar, hash, email, age, username, nom)
        database.insert_createur(Uid, avatar, hash, email, age, username, nom)

    return render_template('login.html')


if __name__ == '__main__':
    app.run()