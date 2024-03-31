/**
use master;
GO

drop database if exists projet_base;

create database projet_base;
go
**/

use projet_base;
go

drop table if EXISTS Evaluation, Visionnement, AssociationMotClé, SynonymeMotClé, MotClé, AjoutFichier, 
Fichier, Thème, Membre, Administrateur, Utilisateur;
go


-- Création des tables -- 
CREATE TABLE Utilisateur ( -- comprend admin et membre
    id_utilisateur int primary key identity(1,1),
    type VARCHAR(255)
);

CREATE TABLE Administrateur (
    id_admin int NOT NULL primary key,
    nom VARCHAR(255),
    prénom VARCHAR(255)
);

CREATE TABLE Membre (
    id_membre int primary key,
    pseudo VARCHAR(255) not null,
    nom VARCHAR(255),
    prénom VARCHAR(255),
    courriel VARCHAR(255),
    date_naissance DATE,
    id_admin_ajout int
);

CREATE TABLE Thème (
    nom_thème VARCHAR(255) primary key,
    description VARCHAR(255),
    id_admin_ajout int 
);

CREATE TABLE Fichier (
    nom_fichier VARCHAR(255) PRIMARY KEY,
    type VARCHAR(255),
    date_ajout DATE
);

CREATE TABLE AjoutFichier (
    nom_fichier VARCHAR(255) primary key,
    id_utilisateur int
);

CREATE TABLE MotClé (
    mot VARCHAR(255) PRIMARY KEY not null
);

CREATE TABLE SynonymeMotClé (
    id_synonymes int PRIMARY KEY identity(1,1),
    mot_clé VARCHAR(255),
    synonyme VARCHAR(255)
);

CREATE TABLE AssociationMotClé (
    id_association int PRIMARY KEY IDENTITY(1,1),
    mot_clé VARCHAR(255) not null,
    nom_fichier VARCHAR(255)
);

CREATE TABLE Visionnement (
    id INT PRIMARY KEY IDENTITY(1,1),
    nom_fichier VARCHAR(255),
    view_date DATE,
    FOREIGN KEY (nom_fichier) REFERENCES Fichier(nom_fichier)
);

CREATE TABLE Evaluation (
    id INT PRIMARY KEY IDENTITY(1,1),
    nom_fichier VARCHAR(255),
    rating INT,
    id_utilisateur INT,
    rating_date DATE,
    FOREIGN KEY (nom_fichier) REFERENCES Fichier(nom_fichier),
    FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur)
);

ALTER TABLE Administrateur
ADD CONSTRAINT fk_id_admin
FOREIGN KEY (id_admin) REFERENCES Utilisateur(id_utilisateur);

ALTER TABLE Thème
ADD CONSTRAINT fk_id_admin_ajout_thème
FOREIGN KEY (id_admin_ajout) REFERENCES Administrateur(id_admin);

ALTER TABLE Membre
ADD CONSTRAINT fk_id_membre
FOREIGN KEY (id_membre) REFERENCES Utilisateur(id_utilisateur);

ALTER TABLE Membre 
ADD CONSTRAINT fk_id_admin_ajout_membre
FOREIGN KEY (id_admin_ajout) REFERENCES Administrateur(id_admin);

ALTER TABLE AjoutFichier
ADD CONSTRAINT fk_id_utilisateur_fichier
FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur(id_utilisateur);

ALTER TABLE AjoutFichier
ADD CONSTRAINT fk_id_nom_ficher_ajout
FOREIGN KEY (nom_fichier) REFERENCES Fichier(nom_fichier);

ALTER TABLE SynonymeMotClé
ADD CONSTRAINT fk_mot_clé_synonyme
FOREIGN KEY (mot_clé) REFERENCES MotClé(mot);

ALTER TABLE AssociationMotClé
ADD CONSTRAINT fk_mot_clé_association
FOREIGN KEY (mot_clé) REFERENCES MotClé(mot);

ALTER TABLE AssociationMotClé
ADD CONSTRAINT fk_nom_fichier_association
FOREIGN KEY (nom_fichier) REFERENCES Fichier(nom_fichier);

-- Enregistrements -- 
INSERT INTO Utilisateur (type) VALUES 
('Admin'),
('Membre'),
('Admin'),
('Membre'),
('Admin'),
('Membre'),
('Admin'),
('Membre'),
('Admin'),
('Membre');

INSERT INTO Administrateur (id_admin, nom, prénom) VALUES 
(1, 'Durand', 'Alice'),
(3, 'Lefebvre', 'Bob'),
(5, 'Moreau', 'Charlie'),
(7, 'Simon', 'Danielle'),
(9, 'Laurent', 'Eve');

INSERT INTO Membre (id_membre, pseudo, nom, prénom, courriel, date_naissance, id_admin_ajout) VALUES 
(2, 'jdoe', 'Doe', 'John', 'jdoe@example.com', '1990-01-01', 1),
(4, 'msmith', 'Smith', 'Mary', 'msmith@example.com', '1985-02-02', 1),
(6, 'bwong', 'Wong', 'Bobby', 'bwong@example.com', '1992-03-03', 3),
(8, 'lchen', 'Chen', 'Linda', 'lchen@example.com', '1988-04-04', 3),
(10, 'tjones', 'Jones', 'Tom', 'tjones@example.com', '1987-05-05', 5);

INSERT INTO Thème (nom_thème, description, id_admin_ajout) VALUES 
('Science', 'Everything about science', 1),
('Art', 'Different forms of art', 3),
('History', 'Historical events and figures', 5),
('Technology', 'The latest in tech', 7),
('Cooking', 'Recipes and cooking techniques', 9);

INSERT INTO Fichier (nom_fichier, type, date_ajout) VALUES 
('recette_chocolat.jpg', 'Image', '2024-03-01'),
('cuisine_italienne.mp4', 'Video', '2024-03-02'),
('routine_cardio.mp4', 'Video', '2024-03-03'),
('yoga_matinale.jpg', 'Image', '2024-03-04'),
('tutoriel_python.mp4', 'Video', '2024-03-05'),
('guide_jardinage.jpg', 'Image', '2024-03-06'),
('sketch_comique.mp4', 'Video', '2024-03-07'),
('affiche_film_comedie.jpg', 'Image', '2024-03-08'),
('documentaire_nature.mp4', 'Video', '2024-03-09'),
('histoire_ancienne.jpg', 'Image', '2024-03-10'),
('dessin_anime_enfant.mp4', 'Video', '2024-03-11'),
('personnage_cartoon.jpg', 'Image', '2024-03-12'),
('voyage_asie.mp4', 'Video', '2024-03-13'),
('paysage_montagne.jpg', 'Image', '2024-03-14'),
('concert_live.mp4', 'Video', '2024-03-15'),
('guitare_acoustique.jpg', 'Image', '2024-03-16'),
('seance_yoga.mp4', 'Video', '2024-03-17'),
('posture_meditation.jpg', 'Image', '2024-03-18'),
('cours_mathematiques.mp4', 'Video', '2024-03-19'),
('salle_classe.jpg', 'Image', '2024-03-20');


INSERT INTO AjoutFichier (nom_fichier, id_utilisateur) VALUES 
('recette_chocolat.jpg', 6),
('cuisine_italienne.mp4', 2),
('routine_cardio.mp4', 5),
('yoga_matinale.jpg', 3),
('tutoriel_python.mp4', 4),
('guide_jardinage.jpg', 8),
('sketch_comique.mp4', 1),
('affiche_film_comedie.jpg', 7),
('documentaire_nature.mp4', 9),
('histoire_ancienne.jpg', 7),
('dessin_anime_enfant.mp4', 2),
('personnage_cartoon.jpg', 6),
('voyage_asie.mp4', 3),
('paysage_montagne.jpg', 4),
('concert_live.mp4', 8),
('guitare_acoustique.jpg', 1),
('seance_yoga.mp4', 7),
('posture_meditation.jpg', 9),
('cours_mathematiques.mp4', 5),
('salle_classe.jpg', 3);

INSERT INTO MotClé (mot) VALUES
('Recette'),
('Exercice'),
('Tutoriel'),
('Comédie'),
('Documentaire'),
('Animation'),
('Voyage'),
('Musique'),
('Yoga'),
('Education');

INSERT INTO SynonymeMotClé (mot_clé, synonyme) VALUES 
('Recette', 'Cuisine'),
('Recette', 'Gastronomie'),
('Exercice', 'Entraînement'),
('Exercice', 'Fitness'),
('Tutoriel', 'Guide'),
('Tutoriel', 'How-To'),
('Comédie', 'Humour'),
('Comédie', 'Sketch'),
('Documentaire', 'Reportage'),
('Documentaire', 'Docu-film'),
('Animation', 'Dessin animé'),
('Animation', 'Cartoon'),
('Voyage', 'Aventure'),
('Voyage', 'Expédition'),
('Musique', 'Mélodie'),
('Musique', 'Chanson'),
('Yoga', 'Méditation'),
('Yoga', 'Pilates'),
('Education', 'Apprentissage'),
('Education', 'Enseignement');

INSERT INTO AssociationMotClé (mot_clé, nom_fichier) VALUES 
('Recette', 'recette_chocolat.jpg'),
('Recette', 'cuisine_italienne.mp4'),
('Exercice', 'routine_cardio.mp4'),
('Exercice', 'yoga_matinale.jpg'),
('Tutoriel', 'tutoriel_python.mp4'),
('Tutoriel', 'guide_jardinage.jpg'),
('Comédie', 'sketch_comique.mp4'),
('Comédie', 'affiche_film_comedie.jpg'),
('Documentaire', 'documentaire_nature.mp4'),
('Documentaire', 'histoire_ancienne.jpg'),
('Animation', 'dessin_anime_enfant.mp4'),
('Animation', 'personnage_cartoon.jpg'),
('Voyage', 'voyage_asie.mp4'),
('Voyage', 'paysage_montagne.jpg'),
('Musique', 'concert_live.mp4'),
('Musique', 'guitare_acoustique.jpg'),
('Yoga', 'seance_yoga.mp4'),
('Yoga', 'posture_meditation.jpg'),
('Education', 'cours_mathematiques.mp4'),
('Education', 'salle_classe.jpg');

INSERT INTO Visionnement (nom_fichier, view_date) VALUES 
('recette_chocolat.jpg', '2024-03-05'),
('recette_chocolat.jpg', '2024-03-07'),
('recette_chocolat.jpg', '2024-03-08'),
('cuisine_italienne.mp4', '2024-03-10'),
('cuisine_italienne.mp4', '2024-03-12'),
('routine_cardio.mp4', '2024-03-07'),
('routine_cardio.mp4', '2024-03-10'),
('yoga_matinale.jpg', '2024-03-10'),
('yoga_matinale.jpg', '2024-03-15'),
('tutoriel_python.mp4', '2024-03-10'),
('tutoriel_python.mp4', '2024-03-12'),
('tutoriel_python.mp4', '2024-03-14'),
('tutoriel_python.mp4', '2024-03-15'),
('guide_jardinage.jpg', '2024-03-10'),
('guide_jardinage.jpg', '2024-03-15'),
('sketch_comique.mp4', '2024-03-10'),
('sketch_comique.mp4', '2024-03-15'),
('affiche_film_comedie.jpg', '2024-03-17'),
('documentaire_nature.mp4', '2024-03-12'),
('documentaire_nature.mp4', '2024-03-17'),
('histoire_ancienne.jpg', '2024-03-14'),
('histoire_ancienne.jpg', '2024-03-18'),
('histoire_ancienne.jpg', '2024-03-21'),
('dessin_anime_enfant.mp4', '2024-03-15'),
('dessin_anime_enfant.mp4', '2024-03-18'),
('personnage_cartoon.jpg', '2024-03-15'),
('personnage_cartoon.jpg', '2024-03-18'),
('voyage_asie.mp4', '2024-03-16'),
('voyage_asie.mp4', '2024-03-18'),
('voyage_asie.mp4', '2024-03-18'),
('voyage_asie.mp4', '2024-03-19'),
('voyage_asie.mp4', '2024-03-19'),
('paysage_montagne.jpg', '2024-03-20'),
('concert_live.mp4', '2024-03-22'),
('guitare_acoustique.jpg', '2024-03-20'),
('guitare_acoustique.jpg', '2024-03-22'),
('seance_yoga.mp4', '2024-03-20'),
('seance_yoga.mp4', '2024-03-22'),
('seance_yoga.mp4', '2024-03-25'),
('seance_yoga.mp4', '2024-03-28'),
('posture_meditation.jpg', '2024-03-22'),
('posture_meditation.jpg', '2024-03-24'),
('cours_mathematiques.mp4', '2024-03-22'),
('cours_mathematiques.mp4', '2024-03-25'),
('salle_classe.jpg', '2024-03-25'),
('salle_classe.jpg', '2024-03-28');

INSERT INTO Evaluation (nom_fichier, rating, id_utilisateur, rating_date) VALUES 
('recette_chocolat.jpg', 4, 5, '2024-03-05'),
('recette_chocolat.jpg', 1, 7, '2024-03-05'),
('recette_chocolat.jpg', 3, 6, '2024-03-08'),
('cuisine_italienne.mp4', 5, 2, '2024-03-10'),
('cuisine_italienne.mp4', 2, 4, '2024-03-12'),
('routine_cardio.mp4', 5, 7, '2024-03-07'),
('routine_cardio.mp4', 5, 1, '2024-03-10'),
('yoga_matinale.jpg', 5, 3, '2024-03-10'),
('yoga_matinale.jpg', 3, 10, '2024-03-15'),
('tutoriel_python.mp4', 4, 9, '2024-03-10'),
('tutoriel_python.mp4', 5, 8, '2024-03-15'),
('guide_jardinage.jpg', 3, 5, '2024-03-10'),
('guide_jardinage.jpg', 2, 7, '2024-03-15'),
('sketch_comique.mp4', 4, 2, '2024-03-10'),
('sketch_comique.mp4', 5, 1, '2024-03-15'),
('affiche_film_comedie.jpg', 4, 8, '2024-03-12'),
('affiche_film_comedie.jpg', 2, 6, '2024-03-17'),
('documentaire_nature.mp4', 5, 4, '2024-03-12'),
('documentaire_nature.mp4', 3, 2, '2024-03-17'),
('histoire_ancienne.jpg', 3, 10, '2024-03-14'),
('histoire_ancienne.jpg', 2, 9, '2024-03-18'),
('dessin_anime_enfant.mp4', 1, 2, '2024-03-15'),
('dessin_anime_enfant.mp4', 1, 3, '2024-03-18'),
('personnage_cartoon.jpg', 3, 5, '2024-03-15'),
('personnage_cartoon.jpg', 2, 4, '2024-03-18'),
('voyage_asie.mp4', 5, 1, '2024-03-16'),
('voyage_asie.mp4', 4, 2, '2024-03-19'),
('paysage_montagne.jpg', 5, 8, '2024-03-18'),
('paysage_montagne.jpg', 5, 7, '2024-03-20'),
('concert_live.mp4', 4, 6, '2024-03-20'),
('concert_live.mp4', 5, 5, '2024-03-22'),
('guitare_acoustique.jpg', 3, 4, '2024-03-20'),
('guitare_acoustique.jpg', 2, 3, '2024-03-22'),
('seance_yoga.mp4', 4, 2, '2024-03-20'),
('seance_yoga.mp4', 5, 1, '2024-03-22'),
('posture_meditation.jpg', 1, 10, '2024-03-22'),
('posture_meditation.jpg', 1, 9, '2024-03-24'),
('cours_mathematiques.mp4', 5, 8, '2024-03-22'),
('cours_mathematiques.mp4', 4, 7, '2024-03-25'),
('salle_classe.jpg', 3, 6, '2024-03-25'),
('salle_classe.jpg', 2, 5, '2024-03-28');


-- Requêtes -- 

-- Donner le nom et le prénom et le nombre de fichiers ajoutés de tous les admins qui ont ajouté au moins 1 fichier vidéo
SELECT a.nom, a.prénom, COUNT(*) AS NombreDeVideos
FROM Administrateur a
JOIN AjoutFichier j ON a.id_admin = j.id_utilisateur
JOIN Fichier f ON j.nom_fichier = f.nom_fichier
WHERE f.type = 'Video'
GROUP BY a.id_admin, a.nom, a.prénom
HAVING COUNT(*) > 1;

-- Donner le nom des fichiers et le(s) nom et prénoms de l'utilisateur qui a ajouté le/les fichiers qui sont associé au mot clé 'Musique'
SELECT u.id_utilisateur, aj.nom_fichier
FROM MotClé m
JOIN AssociationMotClé am ON m.mot = am.mot_clé
JOIN AjoutFichier aj ON am.nom_fichier = aj.nom_fichier
JOIN Utilisateur u ON aj.id_utilisateur = u.id_utilisateur
WHERE m.mot = 'Musique'
GROUP BY u.id_utilisateur, aj.nom_fichier;

-- Donner le nom des fichiers, leurs date d'ajout, leurs date de visionnement, et les utilisateurs qui les ont ajoutés, des fichiers qui ont été visionnés entre le 2024-03-09 et le 2024-03-15
SELECT v.view_date, f.nom_fichier, f.date_ajout, u.id_utilisateur
FROM Visionnement v
JOIN Fichier f ON f.nom_fichier = v.nom_fichier
JOIN AjoutFichier aj ON aj.nom_fichier = f.nom_fichier
JOIN Utilisateur u ON u.id_utilisateur = aj.id_utilisateur
WHERE v.view_date BETWEEN '2024-03-09' AND '2024-03-15'
GROUP BY f.nom_fichier, u.id_utilisateur, v.view_date, f.date_ajout;

-- Donner, pour tous les administrateurs, les noms et prénoms des membres et les noms des fichiers et leurs types qu'ils ont ajoutés
SELECT a.id_admin, m.nom AS nom_membre, m.prénom AS prénom_membre, f.nom_fichier, f.type AS type_fichier
FROM Administrateur a 
JOIN Membre m ON a.id_admin = m.id_admin_ajout
JOIN AjoutFichier af ON a.id_admin = af.id_utilisateur
JOIN Fichier f ON af.nom_fichier = f.nom_fichier
GROUP BY a.id_admin, m.nom, m.prénom, f.nom_fichier, f.type;

-- Donner, pour tous les fichiers, le nombre de visionnement et la moyenne de leurs évaluations et l'id des utilisateurs qui l'a ajouté
SELECT f.nom_fichier, COUNT(DISTINCT v.id) AS nombre_visionnement, AVG(e.rating) AS evaluation_moyenne, aj.id_utilisateur
FROM Fichier f
LEFT JOIN Visionnement v ON f.nom_fichier = v.nom_fichier
LEFT JOIN Evaluation e ON f.nom_fichier = e.nom_fichier
LEFT JOIN AjoutFichier aj ON f.nom_fichier = aj.nom_fichier
GROUP BY f.nom_fichier, aj.id_utilisateur;

-- Donner tous les noms et prénoms des membres qui n'ont pas ajouté de fichiers mais qui ont donné au moins une évaluation à un fichier
SELECT m.nom, m.prénom, COUNT(e.id) AS Nombre_évaluation
FROM Membre m 
LEFT JOIN AjoutFichier aj ON m.id_membre = aj.id_utilisateur
LEFT JOIN Evaluation e ON e.nom_fichier = aj.nom_fichier AND e.id_utilisateur = m.id_membre
WHERE aj.nom_fichier IS NULL
GROUP BY m.nom, m.prénom, aj.nom_fichier;

-- Donner en ordre décroissant les fichiers selon leurs moyennes d'évaluation avec une précision de deux chiffres après la virgule
SELECT e.nom_fichier, ROUND(AVG(CAST(e.rating AS DECIMAL(3,1))), 1) AS Moyenne_Evaluation
FROM Evaluation e 
GROUP BY e.nom_fichier
ORDER BY Moyenne_Evaluation DESC;

-- Donner, pour tous les utilisateurs, leurs types, leurs noms et prénoms
SELECT u.id_utilisateur,u.type,
  CASE WHEN u.type = 'Admin' THEN a.nom ELSE m.nom END AS nom,
  CASE WHEN u.type = 'Admin' THEN a.prénom ELSE m.prénom END AS prénom
FROM Utilisateur u
LEFT JOIN Administrateur a ON u.id_utilisateur = a.id_admin AND u.type = 'Admin'
LEFT JOIN Membre m ON u.id_utilisateur = m.id_membre AND u.type = 'Membre';

-- Donner pour tous les synonymes d'un mot-clé, le mot-clé et le fichier correspondant
SELECT s.synonyme, s.mot_clé, a.nom_fichier
FROM SynonymeMotClé s 
JOIN AssociationMotClé a ON s.mot_clé = a.mot_clé
GROUP BY s.synonyme, s.mot_clé, a.nom_fichier;

-- Donner pour tous les membres, le nom de famille des administrateurs qui les ont ajoutés
SELECT m.id_membre, m.nom, m.prénom, a.nom as Admin_Ajout 
FROM Membre m 
JOIN Administrateur a ON m.id_admin_ajout = a.id_admin
GROUP BY m.id_membre, m.nom, m.prénom, a.nom;
