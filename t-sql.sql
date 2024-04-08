use projet_base;
go

-- Procédures, fonctions, déclencheurs et curseurs --

CREATE OR ALTER PROCEDURE ViewCount
AS
BEGIN
    SELECT f.nom_fichier, COUNT(DISTINCT v.id) AS nombre_visionnement
    FROM Fichier f
    LEFT JOIN Visionnement v ON f.nom_fichier = v.nom_fichier
    GROUP BY f.nom_fichier
END;
GO

CREATE OR ALTER FUNCTION GetAverageRating(@VideoName VARCHAR(255))
RETURNS DECIMAL(3, 2)
AS
BEGIN
    DECLARE @AverageRating DECIMAL(3, 2);

    SELECT @AverageRating = AVG(CAST(rating AS DECIMAL(10,2)))
    FROM Evaluation
    WHERE nom_fichier = @VideoName;

    RETURN @AverageRating;
END;
GO

SELECT dbo.GetAverageRating('sketch_comique.mp4') AS AverageRating;
GO

CREATE OR ALTER PROCEDURE GetAverageVideoRatings
AS
BEGIN
    SELECT 
        nom_fichier AS VideoName,
        AVG(rating) AS AverageRating
    FROM Evaluation
    GROUP BY nom_fichier
    ORDER BY AverageRating DESC;
END;
GO

EXEC GetAverageVideoRatings;
GO

CREATE OR ALTER PROCEDURE GetUserActivity
AS
BEGIN
    SELECT 
        u.pseudo AS Username,
        COUNT(e.id) AS RatingsCount,
        COUNT(a.nom_fichier) AS UploadsCount
    FROM Membre u
    LEFT JOIN Evaluation e ON u.id_membre = e.id_utilisateur
    LEFT JOIN AjoutFichier a ON u.id_membre = a.id_utilisateur
    GROUP BY u.pseudo;
END;
GO

EXEC GetUserActivity;
GO