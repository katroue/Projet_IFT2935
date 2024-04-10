use projet_base;
GO

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


CREATE OR ALTER TRIGGER trg_Membre_PreventEmailChange
ON Membre
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1
               FROM inserted i
               INNER JOIN deleted d ON i.id_membre = d.id_membre
               WHERE i.courriel <> d.courriel)
    BEGIN
        RAISERROR ('Modification of email (courriel) is not allowed.', 16, 1);
        RETURN;
    END
    ELSE
    BEGIN
        UPDATE Membre
        SET pseudo = i.pseudo,
            nom = i.nom,
            prénom = i.prénom,
            courriel = i.courriel,
            date_naissance = i.date_naissance,
            id_admin_ajout = i.id_admin_ajout
        FROM inserted i
        WHERE Membre.id_membre = i.id_membre;
    END
END
GO

CREATE OR ALTER PROCEDURE FetchMemberDetails
AS
BEGIN
    DECLARE @id_membre INT, 
            @pseudo VARCHAR(255), 
            @nom VARCHAR(255), 
            @prenom VARCHAR(255), 
            @courriel VARCHAR(255), 
            @date_naissance DATE;

    DECLARE membre_cursor CURSOR FOR
        SELECT id_membre, pseudo, nom, prénom, courriel, date_naissance
        FROM Membre;

    OPEN membre_cursor;
    FETCH NEXT FROM membre_cursor INTO @id_membre, @pseudo, @nom, @prenom, @courriel, @date_naissance;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT 
            'ID du membre: ' + CAST(@id_membre AS VARCHAR(10)) + CHAR(13) +
            'Pseudo: ' + @pseudo + CHAR(13) +
            'Nom: ' + ISNULL(@nom, 'Non spécifié') + CHAR(13) +
            'Prénom: ' + ISNULL(@prenom, 'Non spécifié') + CHAR(13) +
            'Courriel: ' + ISNULL(@courriel, 'Non spécifié') + CHAR(13) +
            'Date de naissance: ' + CONVERT(VARCHAR, @date_naissance, 103) + CHAR(13) + 
            '--------'
        AS MemberDetails;

        FETCH NEXT FROM membre_cursor INTO @id_membre, @pseudo, @nom, @prenom, @courriel, @date_naissance;
    END;

    CLOSE membre_cursor;
    DEALLOCATE membre_cursor;
END;
GO

SELECT * FROM Fichier;

SELECT * FROM MotClé;

SELECT * FROM AssociationMotClé;