DROP DATABASE IF EXISTS projetglo2005;

CREATE DATABASE projetglo2005;
use projetglo2005;


DROP TABLE IF EXISTS Favoris;
DROP TABLE IF EXISTS Note;
DROP TABLE IF EXISTS Reponse;
DROP TABLE IF EXISTS Commentaire;
DROP TABLE IF EXISTS Cree;
DROP TABLE IF EXISTS Gifs;
DROP TABLE IF EXISTS utilisateurs;
DROP TABLE IF EXISTS Createurs;

CREATE TABLE Utilisateurs(Uid integer NOT NULL AUTO_INCREMENT, Avatar varchar(200) default "https://i.stack.imgur.com/YaL3s.jpg", Hash varchar(100), Email varchar(100), Age integer, Username varchar(50), nom varchar(100), PRIMARY KEY(Uid), UNIQUE(Username), UNIQUE(Email));
CREATE TABLE Gifs(Gid integer not null AUTO_INCREMENT, Nom varchar(100), story boolean DEFAULT FALSE, clip boolean DEFAULT FALSE, Date date, Path varchar(200), type varchar(50), NbLike integer DEFAULT 0, NbDislike integer DEFAULT 0, NbClicK integer DEFAULT 0, PRIMARY KEY(Gid));
CREATE TABLE Cree(Creationid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Creationid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid) ON DELETE CASCADE, FOREIGN KEY(Uid) REFERENCES Utilisateurs(uid));
CREATE TABLE Commentaire(Comid integer NOT NULL AUTO_INCREMENT, texte varchar(500), Uid integer, Gid integer, PRIMARY KEY(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid) on delete cascade);
CREATE TABLE Reponse(Repid integer NOT NULL AUTO_INCREMENT, Comid integer, texte varchar(500), Uid integer, PRIMARY KEY(Repid), FOREIGN KEY(Comid) REFERENCES Commentaire(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid));
CREATE TABLE Note(Noteid integer NOT NULL AUTO_INCREMENT, Dislike boolean, Uid integer, Gid integer, PRIMARY KEY(Noteid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid) ON DELETE CASCADE);
CREATE TABLE Favoris(Favid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Favid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid) ON DELETE CASCADE);



DELIMITER //

CREATE TRIGGER AgeUtilisateur
    BEFORE INSERT ON Utilisateurs
    FOR EACH ROW
    BEGIN
        IF NEW.Age < 18 THEN
            SIGNAL SQLSTATE '45000';
        end if ;
    end //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE AugmenterLike(Gifsid integer)
BEGIN
    UPDATE Gifs G SET G.NbLike = G.NbLike + 1 WHERE G.Gid = Gifsid;
end //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DiminuerLike(Gifsid integer)
BEGIN
    UPDATE Gifs G SET G.NbLike = G.NbLike - 1 WHERE G.Gid = Gifsid;
end //


DELIMITER //

CREATE PROCEDURE AugmenterDislike(Gifsid integer)
BEGIN
    UPDATE Gifs G SET G.NbDislike = G.NbDislike + 1 WHERE G.Gid = Gifsid;
end //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DiminuerDislike(Gifsid integer)
BEGIN
    UPDATE Gifs G SET G.NbDislike = G.NbDislike - 1 WHERE G.Gid = Gifsid;
end //

DELIMITER ;

DELIMITER //

CREATE TRIGGER NombreLike
    AFTER INSERT ON  Note
    FOR EACH ROW
    BEGIN
        IF NEW.Dislike = False THEN
            call AugmenterLike(NEW.Gid);
        ELSE
            call AugmenterDislike(NEW.gid);
        end if ;
    end //

DELIMITER ;

DELIMITER //

CREATE TRIGGER DiminuerNombreLikeDislike
    AFTER DELETE ON  Note
    FOR EACH ROW
    BEGIN
        IF OLD.Dislike = FALSE THEN
        call DiminuerLike(OLD.Gid);
        ELSE
            call diminuerDislike(OLD.Gid);
        END IF;
    end //

DELIMITER ;




insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau4", FALSE, '2022-03-16', "https://media.giphy.com/media/hSjOP9Isvq8oWYQiVS/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau5", FALSE, '2022-03-16', "https://media.giphy.com/media/B81XkL3dtnWTe/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau6", FALSE, '2022-03-16', "https://media.giphy.com/media/9PwxaMmfh1wfS/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau7", FALSE, '2022-03-16', "https://media.giphy.com/media/oFI7FttD0iC8V2Iqmy/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau8", FALSE, '2022-03-16', "https://media.giphy.com/media/LZElUsjl1Bu6c/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau9", FALSE, '2022-03-16', "https://media.giphy.com/media/Ex1w4IdYJDfa0/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau10", FALSE, '2022-03-16', "https://media.giphy.com/media/2jKdye2KWy3XiDUq2E/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau11", FALSE, '2022-03-16', "https://media.giphy.com/media/11nJ3kaAXETWQo/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau12", FALSE, '2022-03-16', "https://media.giphy.com/media/OUuwn1HCfQjIY/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau13", FALSE, '2022-03-16', "https://media.giphy.com/media/wH8s0Ntwgh5YI/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau14", FALSE, '2022-03-16', "https://media.giphy.com/media/FO4lgeCgKkC2I/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau15", FALSE, '2022-03-16', "https://media.giphy.com/media/l0MrFrxo1nTTRwoko/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau16", FALSE, '2022-03-16', "https://media.giphy.com/media/SQ1nUXwCpki4g/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau17", FALSE, '2022-03-16', "https://media.giphy.com/media/VBVY9IJKDxwHK/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau18", FALSE, '2022-03-16', "https://media.giphy.com/media/zlVf2eSgXIFFuTnEhz/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau19", FALSE, '2022-03-16', "https://media.giphy.com/media/ceHKRKMR6Ojao/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau20", FALSE, '2022-03-16', "https://media.giphy.com/media/vVWUEFDUVItxu/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau21", FALSE, '2022-03-16', "https://media.giphy.com/media/8DMcPUczc3cze/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau22", FALSE, '2022-03-16', "https://media.giphy.com/media/5pYss15Th6gkCvZhw7/giphy-downsized-large.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau23", FALSE, '2022-03-16', "https://media.giphy.com/media/W5YVAfSttCqre/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau24", FALSE, '2022-03-16', "https://media.giphy.com/media/TQoap3ycHL25a/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau25", FALSE, '2022-03-16', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau77", TRUE, '2022-04-10', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike, NbDislike) value("oiseau88", TRUE, '2022-03-16', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bird", FALSE, '2022-03-23', "https://media.giphy.com/media/MB6nc19nH5ERy/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("blue bird", FALSE, '2022-03-23', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("red bird", FALSE, '2022-03-23', "https://media.giphy.com/media/gl8UGPXe4hlOSDhLYl/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("yellow bird", FALSE, '2022-03-23', "https://media.giphy.com/media/nYSHbwGjFqZi7QnY8A/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("perroquet", FALSE, '2022-03-23', "https://media.giphy.com/media/vsGnvQD0ZcQco/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("colibris", FALSE, '2022-03-23', "https://media.giphy.com/media/nQZVy7bYWEKK4/giphy-downsized-large.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("cigogne", FALSE, '2022-03-23', "https://media.giphy.com/media/enSdDnhpN8gq4/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("manchot", FALSE, '2022-03-23', "https://media.giphy.com/media/QOwv9PMbslvq/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("grue", FALSE, '2022-03-23', "https://media.giphy.com/media/VYoRYiE4XSdX2/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("canaris", FALSE, '2022-03-23', "https://media.giphy.com/media/Dhxh6ADBP7c2Y/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bird", FALSE, '2022-03-23', "https://media.giphy.com/media/34yAoB0v7EWhG/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("purple", FALSE, '2022-03-23', "https://media.giphy.com/media/M0jGKAV3yaKLS/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("oiseau rouge", FALSE, '2022-03-23', "https://media.giphy.com/media/fR5dEe1OzrSV2/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("oiseau bleu", FALSE, '2022-03-23', "https://media.giphy.com/media/dTC204ha6c1wY/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("oiseau jaune", FALSE, '2022-03-23', "https://media.giphy.com/media/MpGWxMQ5S8kda/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("oiseau mauve", FALSE, '2022-03-23', "https://media.giphy.com/media/YOkVtQYKrP900bWdoC/giphy-downsized-large.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("rouge", FALSE, '2022-03-23', "https://media.giphy.com/media/TFPra0W11fUnIQeQMG/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bleu", FALSE, '2022-03-23', "https://media.giphy.com/media/dv7K4FEfgSm2Y/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("mauve", FALSE, '2022-03-23', "https://media.giphy.com/media/JyOsEVxu2Nk8E/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("turquoise", FALSE, '2022-03-23', "https://media.giphy.com/media/6mr2y6RGPcEU0/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("rouge3", FALSE, '2022-03-23', "https://media.giphy.com/media/l0HlIo3bPNiMUABt6/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bleu rouge", FALSE, '2022-03-23', "https://media.giphy.com/media/EECy1Cp6nyV9e/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("oiseau77", FALSE, '2022-03-23', "https://media.giphy.com/media/xwy9AbBlXlIFW/giphy.gif", 'Gifs', 0);
insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bird", FALSE, '2022-03-23', "https://media.giphy.com/media/wMrDQG1xeCPe/giphy.gif", 'Gifs', 0);

insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email1@gamail.com", 22, "User1", "Utilisateur1");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email2@gamail.com", 22, "User2", "Utilisateur2");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email3@gamail.com", 22, "User3", "Utilisateur3");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email4@gamail.com", 22, "User4", "Utilisateur4");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email5@gamail.com", 22, "User5", "Utilisateur5");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email6@gamail.com", 22, "User6", "Utilisateur6");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email7@gamail.com", 22, "User7", "Utilisateur7");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email8@gamail.com", 22, "User8", "Utilisateur8");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email9@gamail.com", 22, "User9", "Utilisateur9");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email10@gamail.com", 22, "User10", "Utilisateur10");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email11@gamail.com", 22, "User11", "Utilisateur11");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email12@gamail.com", 22, "User12", "Utilisateur12");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email13@gamail.com", 22, "User13", "Utilisateur13");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email14@gamail.com", 22, "User14", "Utilisateur14");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email15@gamail.com", 22, "User15", "Utilisateur15");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email16@gamail.com", 22, "User16", "Utilisateur16");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email17@gamail.com", 22, "User17", "Utilisateur17");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email18@gamail.com", 22, "User18", "Utilisateur18");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email19@gamail.com", 22, "User19", "Utilisateur19");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email111@gamail.com", 22, "User111", "Utilisateur111");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email112@gamail.com", 22, "User112", "Utilisateur112");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email113@gamail.com", 22, "User113", "Utilisateur113");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email114@gamail.com", 22, "User114", "Utilisateur114");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email115@gamail.com", 22, "User115", "Utilisateur115");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email116@gamail.com", 22, "User116", "Utilisateur116");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email117@gamail.com", 22, "User117", "Utilisateur117");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email118@gamail.com", 22, "User118", "Utilisateur118");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email119@gamail.com", 22, "User119", "Utilisateur119");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email121@gamail.com", 22, "User121", "Utilisateur121");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email122@gamail.com", 22, "User122", "Utilisateur122");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email123@gamail.com", 22, "User123", "Utilisateur123");
insert into utilisateurs (Hash, Email, Age, Username, nom) VALUES ("123", "email124@gamail.com", 22, "User124", "Utilisateur124");


INSERT INTO Cree (Uid, Gid) VALUES (1, 1);
INSERT INTO Cree (Uid, Gid) VALUES (1, 2);
INSERT INTO Cree (Uid, Gid) VALUES (2, 3);
INSERT INTO Cree (Uid, Gid) VALUES (2, 4);
INSERT INTO Cree (Uid, Gid) VALUES (3, 5);
INSERT INTO Cree (Uid, Gid) VALUES (3, 6);
INSERT INTO Cree (Uid, Gid) VALUES (4, 7);
INSERT INTO Cree (Uid, Gid) VALUES (4, 8);
INSERT INTO Cree (Uid, Gid) VALUES (5, 9);
INSERT INTO Cree (Uid, Gid) VALUES (5, 10);
INSERT INTO Cree (Uid, Gid) VALUES (6, 11);
INSERT INTO Cree (Uid, Gid) VALUES (6, 12);
INSERT INTO Cree (Uid, Gid) VALUES (7, 13);
INSERT INTO Cree (Uid, Gid) VALUES (7, 14);
INSERT INTO Cree (Uid, Gid) VALUES (8, 15);
INSERT INTO Cree (Uid, Gid) VALUES (8, 16);
INSERT INTO Cree (Uid, Gid) VALUES (9, 17);
INSERT INTO Cree (Uid, Gid) VALUES (9, 18);
INSERT INTO Cree (Uid, Gid) VALUES (10, 19);
INSERT INTO Cree (Uid, Gid) VALUES (10, 20);
INSERT INTO Cree (Uid, Gid) VALUES (11, 21);
INSERT INTO Cree (Uid, Gid) VALUES (11, 22);
INSERT INTO Cree (Uid, Gid) VALUES (12, 23);
INSERT INTO Cree (Uid, Gid) VALUES (12, 24);
INSERT INTO Cree (Uid, Gid) VALUES (13, 25);
INSERT INTO Cree (Uid, Gid) VALUES (13, 26);
INSERT INTO Cree (Uid, Gid) VALUES (14, 27);
INSERT INTO Cree (Uid, Gid) VALUES (14, 28);
INSERT INTO Cree (Uid, Gid) VALUES (15, 29);
INSERT INTO Cree (Uid, Gid) VALUES (15, 30);
INSERT INTO Cree (Uid, Gid) VALUES (16, 31);
INSERT INTO Cree (Uid, Gid) VALUES (16, 32);
INSERT INTO Cree (Uid, Gid) VALUES (17, 33);
INSERT INTO Cree (Uid, Gid) VALUES (17, 34);
INSERT INTO Cree (Uid, Gid) VALUES (18, 35);
INSERT INTO Cree (Uid, Gid) VALUES (18, 36);
INSERT INTO Cree (Uid, Gid) VALUES (19, 37);
INSERT INTO Cree (Uid, Gid) VALUES (19, 38);
INSERT INTO Cree (Uid, Gid) VALUES (20, 39);
INSERT INTO Cree (Uid, Gid) VALUES (20, 40);
INSERT INTO Cree (Uid, Gid) VALUES (21, 41);
INSERT INTO Cree (Uid, Gid) VALUES (21, 42);
INSERT INTO Cree (Uid, Gid) VALUES (22, 43);
INSERT INTO Cree (Uid, Gid) VALUES (22, 44);
INSERT INTO Cree (Uid, Gid) VALUES (23, 45);
INSERT INTO Cree (Uid, Gid) VALUES (23, 46);
INSERT INTO Cree (Uid, Gid) VALUES (24, 47);
INSERT INTO Cree (Uid, Gid) VALUES (24, 48);

INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 26);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 28);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 30);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 1, 44);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 14);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 16);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 18);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 44);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 6);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 2, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 12);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 18);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 20);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 21);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 23);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 25);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 27);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 31);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 3, 33);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 12);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 14);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 21);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 23);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 35);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 4, 42);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 6);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 16);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 18);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 25);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 26);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 27);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 28);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 35);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 5, 36);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 16);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 29);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 28);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 30);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 6, 41);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 26);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 28);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 30);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (FALSE, 7, 44);

INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 9, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 26);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 28);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 30);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 8, 44);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 14);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 15);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 16);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 17);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 18);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 44);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 10, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 11, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 11, 6);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 11, 7);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 11, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 11, 9);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 8);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 12);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 12, 18);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 19);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 20);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 21);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 23);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 25);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 27);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 31);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 13, 33);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 1);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 2);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 3);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 4);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 5);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 10);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 11);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 12);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 13);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 14);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 21);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 22);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 23);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 24);
INSERT INTO Note (Dislike, Uid, Gid) VALUES (TRUE, 14, 35);

INSERT INTO Favoris (Uid, Gid) VALUES (1, 1);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 2);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 3);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 4);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 5);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 6);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 7);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 8);
INSERT INTO Favoris (Uid, Gid) VALUES (1, 9);
INSERT INTO Favoris (Uid, Gid) VALUES (2, 10);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 11);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 12);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 13);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 14);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 15);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 16);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 17);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 18);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 19);
INSERT INTO Favoris (Uid, Gid) VALUES (21, 10);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 1);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 2);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 3);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 4);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 5);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 6);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 7);
INSERT INTO Favoris (Uid, Gid) VALUES (31, 8);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 1);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 2);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 3);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 4);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 5);
INSERT INTO Favoris (Uid, Gid) VALUES (3, 6);
INSERT INTO Favoris (Uid, Gid) VALUES (4, 7);
INSERT INTO Favoris (Uid, Gid) VALUES (4, 8);
INSERT INTO Favoris (Uid, Gid) VALUES (4, 9);
INSERT INTO Favoris (Uid, Gid) VALUES (4, 10);
INSERT INTO Favoris (Uid, Gid) VALUES (4, 11);
INSERT INTO Favoris (Uid, Gid) VALUES (5, 12);
INSERT INTO Favoris (Uid, Gid) VALUES (5, 13);
INSERT INTO Favoris (Uid, Gid) VALUES (5, 14);
INSERT INTO Favoris (Uid, Gid) VALUES (5, 15);
INSERT INTO Favoris (Uid, Gid) VALUES (6, 16);
INSERT INTO Favoris (Uid, Gid) VALUES (6, 17);
INSERT INTO Favoris (Uid, Gid) VALUES (7, 18);
INSERT INTO Favoris (Uid, Gid) VALUES (7, 19);
INSERT INTO Favoris (Uid, Gid) VALUES (7, 20);
INSERT INTO Favoris (Uid, Gid) VALUES (8, 21);
INSERT INTO Favoris (Uid, Gid) VALUES (9, 22);
INSERT INTO Favoris (Uid, Gid) VALUES (9, 23);
INSERT INTO Favoris (Uid, Gid) VALUES (11, 24);
INSERT INTO Favoris (Uid, Gid) VALUES (12, 25);
INSERT INTO Favoris (Uid, Gid) VALUES (11, 26);
INSERT INTO Favoris (Uid, Gid) VALUES (11, 27);
INSERT INTO Favoris (Uid, Gid) VALUES (12, 28);
INSERT INTO Favoris (Uid, Gid) VALUES (12, 29);
INSERT INTO Favoris (Uid, Gid) VALUES (13, 30);
INSERT INTO Favoris (Uid, Gid) VALUES (14, 31);
INSERT INTO Favoris (Uid, Gid) VALUES (15, 32);
INSERT INTO Favoris (Uid, Gid) VALUES (15, 33);
INSERT INTO Favoris (Uid, Gid) VALUES (15, 34);
INSERT INTO Favoris (Uid, Gid) VALUES (15, 35);
INSERT INTO Favoris (Uid, Gid) VALUES (15, 36);
INSERT INTO Favoris (Uid, Gid) VALUES (16, 37);
INSERT INTO Favoris (Uid, Gid) VALUES (17, 38);
INSERT INTO Favoris (Uid, Gid) VALUES (18, 39);
INSERT INTO Favoris (Uid, Gid) VALUES (19, 40);




