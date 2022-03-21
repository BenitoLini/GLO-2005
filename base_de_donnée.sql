CREATE DATABASE projetGlo2005;
Use projetGlo2005;
CREATE TABLE Utilisateurs(Uid integer, Avatar varchar(200), Hash varchar(100), Email varchar(100), Age integer, Username varchar(50), nom varchar(100), PRIMARY KEY(Uid), UNIQUE(Username), UNIQUE(Email));
CREATE TABLE Createurs(Cid integer, Avatar varchar(200), Hash varchar(100), Email varchar(100), Age integer, Username varchar(50), nom varchar(100), PRIMARY KEY(Cid), UNIQUE(Username), UNIQUE(Email));
CREATE TABLE Gifs(Gid integer, Nom varchar(100), story boolean, Date date, Path varchar(200), type varchar(50), NbLike integer, PRIMARY KEY(Gid));
CREATE TABLE Cree(Creationid integer, Cid integer, Gid integer, PRIMARY KEY(Creationid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid), FOREIGN KEY(Cid) REFERENCES Createurs(Cid));
CREATE TABLE Commentaire(Comid integer, texte varchar(500), Uid integer, Gid integer, PRIMARY KEY(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Reponse(Repid integer, Comid integer, texte varchar(500), Uid integer, PRIMARY KEY(Repid), FOREIGN KEY(Comid) REFERENCES Commentaire(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid));
CREATE TABLE Note(Noteid integer, Dislike boolean, Uid integer, Gid integer, PRIMARY KEY(Noteid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Favoris(Favid integer, Uid integer, Gid integer, PRIMARY KEY(Favid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));



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

CREATE TRIGGER AgeCreateurs
    BEFORE INSERT ON Createurs
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

insert into gifs value(4, "oiseau4", FALSE, '2022-03-16', "https://media.giphy.com/media/hSjOP9Isvq8oWYQiVS/giphy.gif", 'Gifs', 0);
insert into gifs value(5, "oiseau5", FALSE, '2022-03-16', "https://media.giphy.com/media/B81XkL3dtnWTe/giphy.gif", 'Gifs', 0);
insert into gifs value(6, "oiseau6", FALSE, '2022-03-16', "https://media.giphy.com/media/9PwxaMmfh1wfS/giphy.gif", 'Gifs', 0);
insert into gifs value(7, "oiseau7", FALSE, '2022-03-16', "https://media.giphy.com/media/oFI7FttD0iC8V2Iqmy/giphy.gif", 'Gifs', 0);
insert into gifs value(8, "oiseau8", FALSE, '2022-03-16', "https://media.giphy.com/media/LZElUsjl1Bu6c/giphy.gif", 'Gifs', 0);
insert into gifs value(9, "oiseau9", FALSE, '2022-03-16', "https://media.giphy.com/media/Ex1w4IdYJDfa0/giphy.gif", 'Gifs', 0);
insert into gifs value(10, "oiseau10", FALSE, '2022-03-16', "https://media.giphy.com/media/2jKdye2KWy3XiDUq2E/giphy.gif", 'Gifs', 0);
insert into gifs value(11, "oiseau11", FALSE, '2022-03-16', "https://media.giphy.com/media/11nJ3kaAXETWQo/giphy.gif", 'Gifs', 0);
insert into gifs value(12, "oiseau12", FALSE, '2022-03-16', "https://media.giphy.com/media/OUuwn1HCfQjIY/giphy.gif", 'Gifs', 0);
insert into gifs value(13, "oiseau13", FALSE, '2022-03-16', "https://media.giphy.com/media/wH8s0Ntwgh5YI/giphy.gif", 'Gifs', 0);
insert into gifs value(14, "oiseau14", FALSE, '2022-03-16', "https://media.giphy.com/media/FO4lgeCgKkC2I/giphy.gif", 'Gifs', 0);
insert into gifs value(15, "oiseau15", FALSE, '2022-03-16', "https://media.giphy.com/media/l0MrFrxo1nTTRwoko/giphy.gif", 'Gifs', 0);
insert into gifs value(16, "oiseau16", FALSE, '2022-03-16', "https://media.giphy.com/media/SQ1nUXwCpki4g/giphy.gif", 'Gifs', 0);
insert into gifs value(17, "oiseau17", FALSE, '2022-03-16', "https://media.giphy.com/media/VBVY9IJKDxwHK/giphy.gif", 'Gifs', 0);
insert into gifs value(18, "oiseau18", FALSE, '2022-03-16', "https://media.giphy.com/media/zlVf2eSgXIFFuTnEhz/giphy.gif", 'Gifs', 0);
insert into gifs value(19, "oiseau19", FALSE, '2022-03-16', "https://media.giphy.com/media/ceHKRKMR6Ojao/giphy.gif", 'Gifs', 0);
insert into gifs value(20, "oiseau20", FALSE, '2022-03-16', "https://media.giphy.com/media/vVWUEFDUVItxu/giphy.gif", 'Gifs', 0);
insert into gifs value(21, "oiseau21", FALSE, '2022-03-16', "https://media.giphy.com/media/8DMcPUczc3cze/giphy.gif", 'Gifs', 0);
insert into gifs value(22, "oiseau22", FALSE, '2022-03-16', "https://media.giphy.com/media/5pYss15Th6gkCvZhw7/giphy-downsized-large.gif", 'Gifs', 0);
insert into gifs value(23, "oiseau23", FALSE, '2022-03-16', "https://media.giphy.com/media/W5YVAfSttCqre/giphy.gif", 'Gifs', 0);
insert into gifs value(24, "oiseau24", FALSE, '2022-03-16', "https://media.giphy.com/media/TQoap3ycHL25a/giphy.gif", 'Gifs', 0);
insert into gifs value(25, "oiseau25", FALSE, '2022-03-16', "https://media.giphy.com/media/PsLIN8YlKy4rS/giphy.gif", 'Gifs', 0);
