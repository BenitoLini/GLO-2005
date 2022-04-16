import pymysql
import hashlib
import random
import string


class Boomer:
    COOKIE = ""
    UID = None
    CURSOR = None

    def __init__(self, connection: pymysql.Connection, uid):
        self.connection = connection
        self.CURSOR = connection.cursor()
        self.UID = uid
        self.COOKIE = Boomer.generate_cookie(uid)

    def getUid(self):
        return self.UID

    def getCookie(self):
        return self.COOKIE

    def getAvatar(self):
        self.CURSOR.execute(f'SELECT avatar FROM utilisateurs WHERE uid={self.UID};')
        avatar = self.CURSOR.fetchone()[0]
        if avatar is None:
            avatar = "https://i.stack.imgur.com/YaL3s.jpg"
        return avatar

    def getHash(self):
        self.CURSOR.execute(f'SELECT hash FROM utilisateurs WHERE uid={self.UID};')
        return self.CURSOR.fetchone()[0]

    def getUsername(self):
        self.CURSOR.execute(f'SELECT username FROM utilisateurs WHERE uid={self.UID};')
        return self.CURSOR.fetchone()[0]

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