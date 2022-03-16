import pymysql


class Boomer:
    COOKIE_ID = ""
    UID = None
    IS_CREATEUR = False

    def __init__(self, connection: pymysql.Connection, uid, is_createur=False):
        self.connection = connection
        self.UID = uid
        self.IS_CREATEUR = is_createur

    def post(self):
        if not self.IS_CREATEUR:
            return False

    def getUid(self):
        return self.UID

    def getAvatar(self):
        self.connection.cursor().execute(f'SELECT avatar FROM utilisateurs WHERE uid={self.UID};')
        return self.connection.cursor().fetchone()[0]

    def getHash(self):
        self.connection.cursor().execute(f'SELECT hash FROM utilisateurs WHERE uid={self.UID};')
        return self.connection.cursor().fetchone()[0]

    def getUsername(self):
        self.connection.cursor().execute(f'SELECT username FROM utilisateurs WHERE uid={self.UID};')
        return self.connection.cursor().fetchone()[0]

    def setAvatar(self):
        # 1) Upload File dossier avatars
        # 2) static\\avatars\\<uuid>.gif/png/jpg/jpeg
        # 3) Ajouter dans bd le path /\ et commit
        pass

    @staticmethod
    def getUtilisateur(connection: pymysql.Connection, email, hash):
        uid = connection.cursor().execute(f'SELECT uid FROM utilisateurs WHERE email={email} AND hash={hash};')
        return Boomer(connection, uid)