use projet_base;
go

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
GO