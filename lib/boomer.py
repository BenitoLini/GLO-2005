import pymysql
import hashlib
import random
import string


class Boomer:
    COOKIE = ""
    UID = None
    IS_CREATEUR = False
    CURSOR = None

    def __init__(self, connection: pymysql.Connection, uid, is_createur=False):
        self.connection = connection
        self.CURSOR = connection.cursor()
        self.UID = uid
        self.IS_CREATEUR = is_createur
        self.COOKIE = Boomer.generate_cookie(uid)

    def post(self):
        if not self.IS_CREATEUR:
            return False

    def getUid(self):
        return self.UID

    def getCookie(self):
        return self.COOKIE

    def getAvatar(self):
        self.CURSOR.execute(f'SELECT avatar FROM utilisateurs WHERE uid={self.UID};')
        return self.CURSOR.fetchone()[0]

    def getHash(self):
        self.CURSOR.execute(f'SELECT hash FROM utilisateurs WHERE uid={self.UID};')
        return self.CURSOR.fetchone()[0]

    def getUsername(self):
        self.CURSOR.execute(f'SELECT username FROM utilisateurs WHERE uid={self.UID};')
        return self.CURSOR.fetchone()[0]

    def setAvatar(self):
        # 1) Upload File dossier avatars
        # 2) static\\avatars\\<uuid>.gif/png/jpg/jpeg
        # 3) Ajouter dans bd le path /\ et commit
        pass

    @staticmethod
    def generate_cookie(uid):
        fill = "".join(random.choice(string.ascii_lowercase) for i in range(20))
        return hashlib.sha256(f"{uid}{fill}".encode()).hexdigest()

    @staticmethod
    def getUtilisateur(connection: pymysql.Connection, email):
        cursor = connection.cursor()
        cursor.execute(f'SELECT uid FROM utilisateurs WHERE email={email};')
        uid = cursor.fetchone()[0]
        return Boomer(connection, uid)