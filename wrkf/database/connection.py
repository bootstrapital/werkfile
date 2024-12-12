# database/connection.py
from fastlite import Database
from config import DATABASE_PATH

db = Database(DATABASE_PATH)

# Get table references
t = db.t  # This gives us access to all tables
work_experiences = t.work_experiences
companies = t.companies
technologies = t.technologies
experience_technologies = t.experience_technologies
responsibilities = t.responsibilities
business_impacts = t.business_impacts
users = t.users

# Create dataclasses for our tables
WorkExperienceDB = work_experiences.dataclass()
CompanyDB = companies.dataclass()
TechnologyDB = technologies.dataclass()
UserDB = users.dataclass()