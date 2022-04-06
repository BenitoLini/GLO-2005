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
CREATE TABLE Gifs(Gid integer not null AUTO_INCREMENT, Nom varchar(100), story boolean, Date date, Path varchar(200), type varchar(50), NbLike integer DEFAULT 0, PRIMARY KEY(Gid));
CREATE TABLE Cree(Creationid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Creationid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(uid));
CREATE TABLE Commentaire(Comid integer NOT NULL AUTO_INCREMENT, texte varchar(500), Uid integer, Gid integer, PRIMARY KEY(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Reponse(Repid integer NOT NULL AUTO_INCREMENT, Comid integer, texte varchar(500), Uid integer, PRIMARY KEY(Repid), FOREIGN KEY(Comid) REFERENCES Commentaire(Comid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid));
CREATE TABLE Note(Noteid integer NOT NULL AUTO_INCREMENT, Dislike boolean, Uid integer, Gid integer, PRIMARY KEY(Noteid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));
CREATE TABLE Favoris(Favid integer NOT NULL AUTO_INCREMENT, Uid integer, Gid integer, PRIMARY KEY(Favid), UNIQUE(Uid, Gid), FOREIGN KEY(Uid) REFERENCES Utilisateurs(Uid), FOREIGN KEY(Gid) REFERENCES Gifs(Gid));



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


INSERT INTO Utilisateurs VALUES (4,NULL,'cb27e20fb3dd3f6a4f7422abffdc7f945411e0de','nathaniel05@example.net',26,'jmarvin','Pinkie'),(5,NULL,'aa604e9d8879dd7d82d3ddf71c25fd77266f8a47','xprice@example.net',20,'grodriguez','Krystal'),(6,NULL,'0dbd74e0dba3d4a9bf76fe3befd06b4dc2c38949','gorczany.ebony@example.com',41,'bailey.melyssa','Carley'),(7,NULL,'fa12d3a6cc5a70b1444ae6a6d614dd57eab9c37d','shana.mitchell@example.org',77,'lura.dicki','Zola'),(8,NULL,'81c1be2c1e7affa174c6ef1f5b736cd828c1a35b','alex.runolfsson@example.net',32,'xkihn','Mac'),(9,NULL,'4763466c22180dec9ffe436b90b4ea8a5efa5816','alessandra.kunde@example.com',100,'okreiger','Ernestina'),(10,NULL,'47ad8bc526939c7258eed36c2b46851440b4e98b','melody53@example.com',77,'owill','Jeramy'),(11,NULL,'34958ea6d8f90e020dea54504508e2fcc7e13360','phirthe@example.net',80,'parisian.mikayla','Elmer'),(12,NULL,'816bcee12cd516ca478ca93e56c2aad99ecb51ce','bbins@example.com',59,'angus.rutherford','Elwyn'),(13,NULL,'da39956a03a809ddbf2555208abe68dd6a05fc8f','vincenzo25@example.net',67,'kris.abelardo','Kieran'),(14,NULL,'343e2848bea05b262d44bf6c637718fa3d4cc950','michelle.grimes@example.org',20,'tyson51','Ona'),(15,NULL,'59abbbbe5db237c8507d19c73c6b64d544e52e85','wstiedemann@example.com',22,'beier.john','Ally'),(16,NULL,'b1a8595be03a41d562625f85f341fc800099c21c','ddaniel@example.net',52,'vwintheiser','Loyal'),(17,NULL,'12a75560d8cb159912f3ac0840130f5087e223ad','izboncak@example.com',45,'mbruen','Jeramy'),(18,NULL,'4678cfff4a0c256c2ebc0ba97cc9ea12dbc06342','ashlynn.mclaughlin@example.org',72,'fredrick.gottlieb','Carmen'),(19,NULL,'e4ae8f469d7c2bc2544b065c111a76dba51dbb01','gkuphal@example.org',64,'brennan12','Lonie'),(20,NULL,'022aa2649511e2b897802b2e05c679ee881bfa04','oleta04@example.com',114,'karina28','Alphonso'),(21,NULL,'1a13a4e0ac911a837bb23fc47e3a76e5fd391c95','lbogisich@example.org',70,'malcolm58','Loy'),(22,NULL,'7f19142a493bcfd98b3df7c8fe40e54f147ab68d','cleta38@example.net',112,'heaney.jude','Aaliyah'),(23,NULL,'c1309d568c521b89461c08f4b6d328f7092deec0','scot.huel@example.net',103,'leannon.raina','Chester'),(24,NULL,'10ae37c3bd7246bd09594c11006969b003368820','konopelski.chandler@example.net',45,'gerlach.abe','Jovani'),(25,NULL,'9f989ac2a68fe6c59b5fd87c82f37b541d233f57','marcelle01@example.com',104,'haley.shad','Dolores'),(26,NULL,'5ab53dc1811888e9a2e90add2e78b9c8d6b7033a','diamond74@example.net',81,'okohler','Agnes'),(27,NULL,'9ee7dcd0368289e3b7b40ee400b7a3d5258cad1c','qharvey@example.com',68,'jakubowski.walton','Harmon'),(28,NULL,'b97a397c6f45a559378346948ea4cd94dd6d9106','howe.adrain@example.com',86,'johnson72','Sylvan'),(29,NULL,'869173b24b762364ab72566bd912978a8cc2875e','clittle@example.org',110,'athena.hahn','Arjun'),(30,NULL,'b6c9f91eb0f23bd64ad9d9578d86d95dff092e3b','xkuphal@example.org',104,'parker.cleveland','Jany'),(31,NULL,'d689d27ea4f1ee02ff6e7870b022f07002ef9c05','kale.stark@example.net',113,'vkirlin','Salvador'),(32,NULL,'d2b6e3425fd7360cdef9139212d95348f54fc0a6','kgusikowski@example.org',87,'enoch.lindgren','Marlon'),(33,NULL,'5c4e401f29789d6b05b2832787228c0694a61aa1','rosenbaum.melissa@example.com',71,'delbert14','Dennis'),(34,NULL,'3ffc0c96b9f2825cc448ba910d49b6118927f236','yschroeder@example.org',113,'jerry13','Jose'),(35,NULL,'93f67349bd37758acb3b6a864db4c8cc6dfff6d2','jcasper@example.net',55,'veffertz','Edwardo'),(36,NULL,'e0ba0d3b57d83a91e68c6ffc861d0d5094b8a98a','jupton@example.com',118,'jlueilwitz','Johnny'),(37,NULL,'bd7a643946e5814d4151ccdf20f49ec131dfd6e4','hillary.block@example.com',31,'bashirian.darren','Khalil'),(38,NULL,'e4189f092412599ad4e97c572bfa9e1f575c4f6a','parisian.rogelio@example.com',80,'monroe.o\'conner','Malinda'),(39,NULL,'41d61395f0e68295ae6d07ef767943a6b3cb3062','mcdermott.jewel@example.org',99,'serena.botsford','Stan'),(40,NULL,'d3ff9957499ebc1c46c5b7617e2ab942c85638be','helena.gerhold@example.com',70,'sonya95','Peggie'),(41,NULL,'85469329133c6af1a40a22abbd0ba49cb9e86555','strosin.lenore@example.net',37,'iturner','Elwin'),(42,NULL,'d0a9d9df0eb88d926427b856831930001cd62b85','cormier.zola@example.net',112,'dboehm','Carissa'),(43,NULL,'db62f00e24183cdabda6fb7a309257d9b79cfd6d','rath.salvatore@example.org',41,'gleichner.bill','Maye'),(44,NULL,'dceddcf863598fded60e03b1b84aa781a2405273','leland69@example.org',38,'ted.cassin','Wilhelm'),(45,NULL,'7e601626c4f0e227f7460ab846d03113301d5fc9','wullrich@example.org',116,'tre95','Brooke'),(46,NULL,'cc02a2bd9cf1af839428e2899b63ad63ccc6a5de','ekub@example.org',21,'haag.ian','Seth'),(47,NULL,'5160c0895e2ef90316742302a488d83a150e412c','duncan58@example.com',72,'mccullough.jeromy','Rae'),(48,NULL,'392fface44ad136a3097ae0378fba6eea23c67fb','tara09@example.net',71,'logan.smith','Beulah'),(49,NULL,'7387d627b2d59d67c950378393dd53ef1dd5bc10','arlo.mann@example.com',46,'marlee84','Lucius'),(50,NULL,'a6f04799cffdd58f7ff95143df59babf39e1d8f2','johan.jacobs@example.net',75,'reuben.cruickshank','Kristian'),(51,NULL,'acd59198e68d2f2b7c1cc3bee43a0764eafeaa60','jarvis.doyle@example.net',30,'dickinson.jamal','Dax'),(52,NULL,'480117857c8aa0b11483dbee95818fe40b2ba773','lbatz@example.org',38,'tharvey','Dalton'),(53,NULL,'c5acf685b8f6c1249a4d6b1d2c2e17de5c07e666','o\'reilly.nathanael@example.com',92,'alberta55','Cornelius'),(54,NULL,'f8c59ec6cc45d0e9dd49513fad06194873a0a7ab','nicola11@example.com',19,'madge89','Haylie'),(55,NULL,'adb4591d4f477b4122414da49a636eb7bb86d3f8','jayne.ward@example.org',62,'kschamberger','Fatima'),(56,NULL,'24534a8de2a6e3afbbded9aa4f2a634830a6aa51','schaefer.lavina@example.com',92,'aklocko','Evangeline'),(57,NULL,'34a86dd2471f92410284f68bf9d153e215c6b5e7','reynolds.adele@example.com',114,'schaefer.wayne','Kristy'),(58,NULL,'00a94bdc15776e7fcdb55a976cf6d52ef088845d','keely.medhurst@example.org',34,'nona.pacocha','Josh'),(59,NULL,'600940e51bfd8de61b71d487db2c5999f4189134','sammie.muller@example.org',82,'gregg30','Jerrold'),(60,NULL,'3a7b896e0ab6fae2493a7438af6eb86e3e06ee88','gutkowski.linwood@example.net',94,'kmiller','Mylene'),(61,NULL,'eaf6ea28fab3c15206854344ce34d8315abfba2f','borer.lane@example.net',80,'sidney.schmidt','Hiram'),(62,NULL,'c3450a203082721dc16ce366cab22e0fc33f9c9b','hwaters@example.org',115,'alyce.purdy','Shana'),(63,NULL,'b30ed9182def810815958d2c53e001d31f23616f','candace.stiedemann@example.org',77,'afritsch','Briana'),(64,NULL,'be6aa18899b1169fd8a99d4c958d56791ef1aa3d','howe.karlee@example.net',114,'iwyman','Derek'),(65,NULL,'2750efc865de6fd783df5d41400f6b1e6f12f0dd','keara65@example.org',114,'zdoyle','Tre'),(66,NULL,'043bfb9e86ece261b13a579d499e2968117f7b87','johnathon48@example.org',76,'susana.kub','Ayla'),(67,NULL,'2f128416f73791fdd401c0932b63da14a4e8a6d9','ryleigh.stanton@example.net',86,'cathy74','Federico'),(68,NULL,'31a05c9b6861d3fca92a4a7a40aa80ff62d8baca','fadel.dayana@example.com',80,'lawson53','Billy'),(69,NULL,'5e070a540eb1972c1e5b4b4fae5ffd745602488e','epowlowski@example.net',44,'jwiza','Ansley'),(70,NULL,'1886ce5df6b84d16dbc90c608717b11e21bc5150','johnathan.hane@example.net',69,'gage.kozey','Marlen'),(71,NULL,'81b10942a56c556f58662cce108941c3d16b493e','clang@example.com',61,'itzel.boyer','Wiley'),(72,NULL,'76750bc5374a9c40f629487da5b99b748116bc50','effertz.haley@example.com',78,'gerhold.lane','Steve'),(73,NULL,'474fbf410e62447717763ef7daad578ffd6527cd','sterling.ruecker@example.net',100,'fwuckert','Naomi'),(74,NULL,'23c775d645e413266761fe6dfd72def7a737c27f','kenny22@example.com',77,'sharber','Carissa'),(75,NULL,'e2aba57adbc708d7a26ce8c77b0e2237586e3e91','thad06@example.org',58,'swaniawski.keagan','Ross'),(76,NULL,'44f642bcf82b209488fefcdba18accd9538dbc30','balistreri.d\'angelo@example.net',105,'szulauf','Elwin'),(77,NULL,'cddd66ce820f33def287d45a58cb2283e573e048','urice@example.org',87,'madaline87','Abagail'),(78,NULL,'6b51e3e69f3b647f5f49cbb585a2ed7c10ab0452','hoeger.itzel@example.com',52,'eliane.hirthe','Dane'),(79,NULL,'561a9d07b3b01664d077a75dfc721a61d52265fe','francisco.abbott@example.net',92,'corkery.cordia','Aubree'),(80,NULL,'452e35b6adcce85cfa1f6893189cca7a20862033','hanna70@example.com',41,'monte32','Lizeth'),(81,NULL,'2a5d9fd889d043caf17e4e6c4c0b8baa8875bd69','twilkinson@example.org',70,'jackeline76','Logan'),(82,NULL,'8ea24ab6ce5c2bf6c257e869a6382ea7f6a45d90','daryl.abshire@example.com',30,'barney61','Cooper'),(83,NULL,'3b9c5a98d1f8b7b6c596655128397ea343ea25d8','garry.mayer@example.net',18,'wokuneva','Wilhelm'),(84,NULL,'fe3a168dc95443a41e938acd70ef1b624eca2f6d','nward@example.com',18,'mellie20','Lauriane'),(85,NULL,'cd62d000a940f6ea3221eedf5541f02af95feab9','max96@example.net',93,'jwill','Katelin'),(86,NULL,'9a5261ba59011f5fd5bbc084314855b559531527','yshields@example.org',28,'dicki.lauren','Opal'),(87,NULL,'e74eec7f228de6d72582a783cbb5323f05cd52ce','pfannerstill.cristobal@example.net',40,'mozelle45','Richard'),(88,NULL,'74c0110f9960f5d91bc1be64c4432af782f2893d','silas.funk@example.com',43,'hamill.jarod','Humberto'),(89,NULL,'c5036790eef7014235a3b7d7afdb9fbaca23f865','jada.stanton@example.net',62,'zbernier','Johnathan'),(90,NULL,'4d85f7c56989849636904040b9ee16e915a4c5ba','larkin.louie@example.org',85,'tremblay.yadira','Tierra'),(91,NULL,'e9fbe699bcb0ba6032e6c88214689310ccb2fe4a','jarod.armstrong@example.net',38,'mueller.hunter','John'),(92,NULL,'5538793f8b78276514c13c8cc404fce651f22e22','ralph.roberts@example.org',57,'rice.moshe','Hadley'),(93,NULL,'f1a353504f92f6d790fa2b339bed3e5c4bd49314','jeromy70@example.com',110,'monahan.jaqueline','Elsie'),(94,NULL,'f226953a1b15d1ac2c948902455ab780454142d9','dannie15@example.com',72,'jedediah10','Johanna'),(95,NULL,'22b92317b8f3adcc1f94285cee179dd40d28b3a2','calista.friesen@example.net',113,'clement.braun','Nelson'),(96,NULL,'478401b87b5c49e09ea0ca4e09ba7af3a50332e6','deckow.jeanie@example.net',51,'vkozey','Anahi'),(97,NULL,'2eb99eb89c57f9a758bebd8505a136c5ce284ffb','icorwin@example.com',76,'shirley19','Jacklyn'),(98,NULL,'8c1d8965dd2773c06d2b0b22a4b8887dc803cf15','vlind@example.net',23,'darrel.muller','Stanton'),(99,NULL,'348ae2849f774f345788cf3317d0681ed60d8719','zcasper@example.org',46,'nkuvalis','Elijah'),(100,NULL,'5bc7af66be58b6457c88ab4d049d86a52583b7c8','avery97@example.com',42,'miller.lindsey','Tevin');

INSERT INTO Note(dislike, uid, gid) VALUES (false, 4, 5), (false, 5, 5), (false, 6, 5),(false, 7, 5), (false, 8, 5),(false, 9, 5), (false, 10, 5),(false, 11, 5), (false, 12, 5),(false, 13, 5), (false, 14, 5),(false, 18, 5), (false, 15, 5),(false, 16, 5), (false, 17, 5),(false, 19, 5), (false, 20, 5),(false, 21, 5), (false, 22, 5),(false, 23, 5), (false, 24, 5),(false, 25, 5), (false, 26, 5),(false, 27, 5), (false, 28, 5);
INSERT INTO Note(dislike, uid, gid) VALUES (false, 1, 5);

select * from note;


SELECT C.texte FROM Commentaire C, Gifs G WHERE G.Gid=18 AND C.Gid = G.gid;
select * from utilisateurs;

select * from gifs;

delete from gifs where path = 'https://media.giphy.com/media/KpNyL9LpxTTnq/giphy.gif';

INSERT INTO cree (uid, gid) VALUES (1, 5), (2, 6), (1, 7), (1, 8);
select * from cree;

select * from favoris;
select * from commentaire;
select * from reponse;
select * from utilisateurs;