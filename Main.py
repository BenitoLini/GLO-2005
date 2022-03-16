from flask import Flask, render_template, request
import pymysql, pymysql.cursors
import random
from Boomer import Boomer

app = Flask(__name__)
ProfileUtilisateur = {}

connection = pymysql.connect(host='localhost', user='root', password='Glo2005$$', db='projetglo2005')

@app.route("/")
def main():
    cmd = 'SELECT path FROM Gifs'
    cur = connection.cursor()
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
    passe = request.form.get('hash')
    UC = request.form.get('utilisateurcreateur')

    if UC == "utilisateur":
        cmd='SELECT hash FROM utilisateurs WHERE email='+email+';'
    else:
        cmd='SELECT hash FROM createurs WHERE email='+email+';'
    cur = connection.cursor()
    cur.execute(cmd)
    passeVrai = cur.fetchone()

    if (passeVrai is not None) and (passe == passeVrai[0]):

        if UC == "utilisateur":
            cmd='SELECT * FROM utilisateurs WHERE Email='+email+';'
        else:
            cmd = 'SELECT * FROM createurs WHERE Email=' + email + ';'
        cur=connection.cursor()
        cur.execute(cmd)

        if UC == "utilisateur":
            return render_template('principal.html', profile=ProfileUtilisateur)
        else:
            return render_template('createurs.html', profile=ProfileUtilisateur)

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

    conn= pymysql.connect(host='localhost',user='root', password='Glo2005$$',db='projetglo2005')
    cur=conn.cursor()
    if UC == ['utilisateur']:
        cmd='INSERT INTO utilisateurs VALUE('+Uid+', '+avatar+', '+hash+', '+email+', '+age+', '+username+', '+nom+');'
    elif UC == ['createur']:
        cmd='INSERT INTO createurs VALUE('+Uid+', '+avatar+', '+hash+', '+email+', '+age+', '+username+', '+nom+');'
    elif UC == ['utilisateur', 'createur']:
        cmd='INSERT INTO utilisateurs VALUE('+Uid+', '+avatar+', '+hash+', '+email+', '+age+', '+username+', '+nom+');'
        cmd2='INSERT INTO createurs VALUE('+Uid+', '+avatar+', '+hash+', '+email+', '+age+', '+username+', '+nom+');'
        cur.execute(cmd2)
    cur.execute(cmd)
    conn.commit()

    return render_template('login.html', profile=ProfileUtilisateur)


if __name__ == '__main__':
    app.run()