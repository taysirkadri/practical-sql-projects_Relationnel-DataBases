-- ============================================
-- TP1 : Système de Gestion Universitaire
-- Base de données relationnelle
-- ============================================

-- Création de la base de données
CREATE DATABASE IF NOT EXISTS universite_db;
USE universite_db;

-- Table : Départements
CREATE TABLE departements (
    id_departement INT PRIMARY KEY AUTO_INCREMENT,
    nom_departement VARCHAR(100) NOT NULL,
    batiment VARCHAR(50),
    budget DECIMAL(12, 2),
    chef_departement VARCHAR(100),
    date_creation DATE
);

-- Table : Professeurs
CREATE TABLE professeurs (
    id_professeur INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    id_departement INT,
    date_embauche DATE,
    salaire DECIMAL(10, 2),
    specialite VARCHAR(100),
    FOREIGN KEY (id_departement) REFERENCES departements(id_departement)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table : Étudiants
CREATE TABLE etudiants (
    id_etudiant INT PRIMARY KEY AUTO_INCREMENT,
    matricule VARCHAR(20) UNIQUE NOT NULL,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    adresse TEXT,
    id_departement INT,
    niveau VARCHAR(20) CHECK (niveau IN ('L1', 'L2', 'L3', 'M1', 'M2')),
    date_inscription DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (id_departement) REFERENCES departements(id_departement)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table : Cours
CREATE TABLE cours (
    id_cours INT PRIMARY KEY AUTO_INCREMENT,
    code_cours VARCHAR(10) UNIQUE NOT NULL,
    nom_cours VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0),
    semestre INT CHECK (semestre BETWEEN 1 AND 2),
    id_departement INT,
    id_professeur INT,
    capacite_max INT DEFAULT 30,
    FOREIGN KEY (id_departement) REFERENCES departements(id_departement)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_professeur) REFERENCES professeurs(id_professeur)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table : Inscriptions
CREATE TABLE inscriptions (
    id_inscription INT PRIMARY KEY AUTO_INCREMENT,
    id_etudiant INT NOT NULL,
    id_cours INT NOT NULL,
    date_inscription DATE DEFAULT CURRENT_DATE,
    annee_academique VARCHAR(9) NOT NULL,
    statut VARCHAR(20) DEFAULT 'En cours' CHECK (statut IN ('En cours', 'Validé', 'Échoué', 'Abandonné')),
    FOREIGN KEY (id_etudiant) REFERENCES etudiants(id_etudiant)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_cours) REFERENCES cours(id_cours)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE KEY unique_inscription (id_etudiant, id_cours, annee_academique)
);

-- Table : Notes
CREATE TABLE notes (
    id_note INT PRIMARY KEY AUTO_INCREMENT,
    id_inscription INT NOT NULL,
    type_evaluation VARCHAR(30) CHECK (type_evaluation IN ('Devoir', 'TP', 'Examen', 'Projet')),
    note DECIMAL(5, 2) CHECK (note BETWEEN 0 AND 20),
    coefficient DECIMAL(3, 2) DEFAULT 1.00,
    date_evaluation DATE,
    commentaire TEXT,
    FOREIGN KEY (id_inscription) REFERENCES inscriptions(id_inscription)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Index pour améliorer les performances
CREATE INDEX idx_etudiant_departement ON etudiants(id_departement);
CREATE INDEX idx_cours_professeur ON cours(id_professeur);
CREATE INDEX idx_inscription_etudiant ON inscriptions(id_etudiant);
CREATE INDEX idx_inscription_cours ON inscriptions(id_cours);
CREATE INDEX idx_notes_inscription ON notes(id_inscription);

