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

CREATE TABLE Utilisateurs(Uid integer NOT NULL AUTO_INCREMENT, Avatar varchar(200), Hash varchar(100), Email varchar(100), Age integer, Username varchar(50), nom varchar(100), PRIMARY KEY(Uid), UNIQUE(Username), UNIQUE(Email));
CREATE TABLE Gifs(Gid integer not null AUTO_INCREMENT, Nom varchar(100), story boolean, Date date, Path varchar(200), type varchar(50), NbLike integer DEFAULT 0, NbClics integer DEFAULT 0, PRIMARY KEY(Gid));
CREATE TABLE Cree(Creationid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Creationid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(uid));
CREATE TABLE Commentaire(Comid integer NOT NULL AUTO_INCREMENT, texte varchar(500), Uid integer, Gid integer, PRIMARY KEY(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Reponse(Repid integer NOT NULL AUTO_INCREMENT, Comid integer, texte varchar(500), Uid integer, PRIMARY KEY(Repid), FOREIGN KEY(Comid) REFERENCES Commentaire(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid));
CREATE TABLE Note(Noteid integer NOT NULL AUTO_INCREMENT, Dislike boolean, Uid integer, Gid integer, PRIMARY KEY(Noteid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Favoris(Favid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Favid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
ALTER TABLE Gifs ADD NbClick integer DEFAULT 0 AFTER NbLike;


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

CREATE TRIGGER NombreLike
    AFTER INSERT ON  Note
    FOR EACH ROW
    BEGIN
        IF NEW.Dislike = False THEN
            call AugmenterLike(NEW.Gid);
        end if ;
    end //

DELIMITER ;


insert into gifs value(4, "oiseau4", FALSE, '2022-03-16', "https://media.giphy.com/media/hSjOP9Isvq8oWYQiVS/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(5, "oiseau5", FALSE, '2022-03-16', "https://media.giphy.com/media/B81XkL3dtnWTe/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(6, "oiseau6", FALSE, '2022-03-16', "https://media.giphy.com/media/9PwxaMmfh1wfS/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(7, "oiseau7", FALSE, '2022-03-16', "https://media.giphy.com/media/oFI7FttD0iC8V2Iqmy/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(8, "oiseau8", FALSE, '2022-03-16', "https://media.giphy.com/media/LZElUsjl1Bu6c/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(9, "oiseau9", FALSE, '2022-03-16', "https://media.giphy.com/media/Ex1w4IdYJDfa0/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(10, "oiseau10", FALSE, '2022-03-16', "https://media.giphy.com/media/2jKdye2KWy3XiDUq2E/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(11, "oiseau11", FALSE, '2022-03-16', "https://media.giphy.com/media/11nJ3kaAXETWQo/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(12, "oiseau12", FALSE, '2022-03-16', "https://media.giphy.com/media/OUuwn1HCfQjIY/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(13, "oiseau13", FALSE, '2022-03-16', "https://media.giphy.com/media/wH8s0Ntwgh5YI/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(14, "oiseau14", FALSE, '2022-03-16', "https://media.giphy.com/media/FO4lgeCgKkC2I/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(15, "oiseau15", FALSE, '2022-03-16', "https://media.giphy.com/media/l0MrFrxo1nTTRwoko/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(16, "oiseau16", FALSE, '2022-03-16', "https://media.giphy.com/media/SQ1nUXwCpki4g/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(17, "oiseau17", FALSE, '2022-03-16', "https://media.giphy.com/media/VBVY9IJKDxwHK/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(18, "oiseau18", FALSE, '2022-03-16', "https://media.giphy.com/media/zlVf2eSgXIFFuTnEhz/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(19, "oiseau19", FALSE, '2022-03-16', "https://media.giphy.com/media/ceHKRKMR6Ojao/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(20, "oiseau20", FALSE, '2022-03-16', "https://media.giphy.com/media/vVWUEFDUVItxu/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(21, "oiseau21", FALSE, '2022-03-16', "https://media.giphy.com/media/8DMcPUczc3cze/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(22, "oiseau22", FALSE, '2022-03-16', "https://media.giphy.com/media/5pYss15Th6gkCvZhw7/giphy-downsized-large.gif", 'Gifs', 0, 0);
insert into gifs value(23, "oiseau23", FALSE, '2022-03-16', "https://media.giphy.com/media/W5YVAfSttCqre/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(24, "oiseau24", FALSE, '2022-03-16', "https://media.giphy.com/media/TQoap3ycHL25a/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(25, "oiseau25", FALSE, '2022-03-16', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);

insert into gifs value(77, "oiseau77", TRUE, '2022-04-10', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);
insert into gifs value(88, "oiseau88", TRUE, '2022-03-16', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0, 0);




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


INSERT INTO commentaire value(1, 'allo', 1, 18);
INSERT INTO commentaire value(2, 'bel oiseau', 1, 18);
INSERT INTO commentaire value(3, 'djshfalshdf', 1, 18);
INSERT INTO commentaire value(4, 'adsakfdjklhasfdasf', 1, 18);
INSERT INTO commentaire value(5, 'adsdfgsdfgdsfgsdgfdsgakfdjklhasfdasf', 2, 18);


INSERT INTO Note(dislike, uid, gid) VALUES (false, 4, 5), (false, 5, 5), (false, 6, 5),(false, 7, 5), (false, 8, 5),(false, 9, 5), (false, 10, 5),(false, 11, 5), (false, 12, 5),(false, 13, 5), (false, 14, 5),(false, 18, 5), (false, 15, 5),(false, 16, 5), (false, 17, 5),(false, 19, 5), (false, 20, 5),(false, 21, 5), (false, 22, 5),(false, 23, 5), (false, 24, 5),(false, 25, 5), (false, 26, 5),(false, 27, 5), (false, 28, 5);
INSERT INTO Note(dislike, uid, gid) VALUES (false, 1, 5);

select * from note;


SELECT C.texte FROM Commentaire C, Gifs G WHERE G.Gid=18 AND C.Gid = G.gid;
select * from utilisateurs;

select * from gifs;

delete from gifs where path = 'https://media.giphy.com/media/KpNyL9LpxTTnq/giphy.gif';

INSERT INTO cree (uid, gid) VALUES (1, 5), (2, 6), (1, 7), (1, 8);
select * from cree;

delete from utilisateurs where uid != 1 and uid != 2;
select * from note;
delete from note where uid!=1;
delete from favoris where uid!=1 or uid != 2;

select * from favoris;
select * from commentaire;
select * from reponse;
select * from utilisateurs;
select * from gifs;



ALTER TABLE gifs ADD NbClick int AFTER NbLike;
/*UPDATE gifs SET NbClick=1 WHERE Nom LIKE '%1%' */
 UPDATE gifs SET story=1 WHERE Nom LIKE '%bleu%'

insert into gifs (Nom, story, Date, Path, type, NbLike) VALUES ("bleu", TRUE, '2022-04-10', "https://media.giphy.com/media/wMrDQG1xeCPe/giphy.gif", 'Gifs', 0);
