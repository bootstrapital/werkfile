-- SQLite Database Schema Export
-- Exported on: Thu Dec 12 12:10:27 EST 2024

PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;

-- TABLES
CREATE TABLE business_impacts (
    impact_id INTEGER PRIMARY KEY AUTOINCREMENT,
    experience_id INTEGER NOT NULL,
    metric_description TEXT NOT NULL,
    metric_value TEXT,
    metric_type TEXT, -- Percentage, Currency, Quantity
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (experience_id) REFERENCES work_experiences(experience_id)
);

CREATE TABLE certifications (
    certification_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    issuing_organization TEXT NOT NULL,
    issue_date DATE,
    expiration_date DATE,
    credential_id TEXT,
    credential_url TEXT,
    skills_tags TEXT, -- Comma-separated skills related to certification
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE companies (
    company_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    industry TEXT,
    website TEXT,
    headquarters_location TEXT,
    company_size_range TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE education (
    education_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    institution TEXT NOT NULL,
    degree TEXT NOT NULL,
    field_of_study TEXT,
    start_date DATE,
    end_date DATE,
    is_current BOOLEAN DEFAULT FALSE,
    gpa REAL,
    honors TEXT,
    additional_details TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE experience_technologies (
    experience_id INTEGER NOT NULL,
    technology_id INTEGER NOT NULL,
    proficiency_level TEXT, -- Beginner, Intermediate, Advanced
    PRIMARY KEY (experience_id, technology_id),
    FOREIGN KEY (experience_id) REFERENCES work_experiences(experience_id),
    FOREIGN KEY (technology_id) REFERENCES technologies(technology_id)
);

CREATE TABLE responsibilities (
    responsibility_id INTEGER PRIMARY KEY AUTOINCREMENT,
    experience_id INTEGER NOT NULL,
    description TEXT NOT NULL,
    tags TEXT, -- Comma-separated tags for search optimization
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (experience_id) REFERENCES work_experiences(experience_id)
);

CREATE TABLE technologies (
    technology_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    category TEXT
);

CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    is_active BOOLEAN DEFAULT TRUE
, personal_summary TEXT);

CREATE TABLE work_experiences (
    experience_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    company_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    employment_type TEXT, -- Full-time, Part-time, Contract, etc.
    start_date DATE NOT NULL,
    end_date DATE,
    is_current BOOLEAN DEFAULT FALSE,
    department TEXT,
    location TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (company_id) REFERENCES companies(company_id)
);


-- VIEWS
CREATE VIEW werkfile AS
WITH 
    ResponsibilitiesCTE AS (
        SELECT 
            experience_id, 
            GROUP_CONCAT(description, ' | ') AS responsibilities_summary
        FROM responsibilities
        GROUP BY experience_id
    ),
    TechnologiesCTE AS (
        SELECT 
            experience_id, 
            GROUP_CONCAT(t.name || ' (' || et.proficiency_level || ')', ', ') AS technologies_used
        FROM experience_technologies et
        JOIN technologies t ON et.technology_id = t.technology_id
        GROUP BY experience_id
    ),
    BusinessImpactsCTE AS (
        SELECT 
            experience_id, 
            GROUP_CONCAT(
                metric_description || ': ' || 
                COALESCE(metric_value, 'N/A') || 
                ' (' || COALESCE(metric_type, '') || ')', 
                ' | '
            ) AS business_impacts
        FROM business_impacts
        GROUP BY experience_id
    ),
    EducationCTE AS (
        SELECT 
            user_id, 
            GROUP_CONCAT(
                institution || ': ' || 
                degree || ' in ' || 
                COALESCE(field_of_study, 'N/A') || 
                ' (' || 
                CASE 
                    WHEN is_current THEN 'Current' 
                    ELSE 'Graduated ' || COALESCE(end_date, 'N/A') 
                END || 
                ')', 
                ' | '
            ) AS education_summary
        FROM education
        GROUP BY user_id
    ),
    CertificationsCTE AS (
        SELECT 
            user_id, 
            GROUP_CONCAT(
                name || ' from ' || 
                issuing_organization || 
                ' (Issued: ' || 
                COALESCE(issue_date, 'N/A') || 
                ', Expiration: ' || 
                COALESCE(expiration_date, 'N/A') || 
                ')', 
                ' | '
            ) AS certifications_summary
        FROM certifications
        GROUP BY user_id
    )
SELECT 
    -- User and Personal Information
    u.user_id,
    u.username,
    u.email,
    u.personal_summary,
    
    -- Education Summary
    ec.education_summary,
    
    -- Certifications Summary
    cc.certifications_summary,
    
    -- Work Experience Details
    we.experience_id,
    c.company_id,
    c.name AS company_name,
    c.industry AS company_industry,
    
    we.title,
    we.employment_type,
    we.start_date,
    we.end_date,
    we.is_current,
    we.department,
    we.location,
    
    -- Responsibilities
    r.responsibilities_summary,
    
    -- Technologies
    t.technologies_used,
    
    -- Business Impacts
    bi.business_impacts,
    
    -- Metadata
    we.created_at AS experience_created_at,
    we.updated_at AS experience_updated_at
FROM 
    users u
LEFT JOIN 
    work_experiences we ON u.user_id = we.user_id
LEFT JOIN 
    companies c ON we.company_id = c.company_id
LEFT JOIN 
    ResponsibilitiesCTE r ON we.experience_id = r.experience_id
LEFT JOIN 
    TechnologiesCTE t ON we.experience_id = t.experience_id
LEFT JOIN 
    BusinessImpactsCTE bi ON we.experience_id = bi.experience_id
LEFT JOIN 
    EducationCTE ec ON u.user_id = ec.user_id
LEFT JOIN 
    CertificationsCTE cc ON u.user_id = cc.user_id
ORDER BY 
    we.start_date DESC;


-- INDICES
CREATE INDEX idx_certifications_user ON certifications(user_id);

CREATE INDEX idx_company_experiences ON work_experiences(company_id);

CREATE INDEX idx_education_user ON education(user_id);

CREATE INDEX idx_experience_responsibilities ON responsibilities(experience_id);

CREATE INDEX idx_user_experiences ON work_experiences(user_id);


-- TRIGGERS

COMMIT;
PRAGMA foreign_keys=ON;
