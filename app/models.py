from .extensions import db

class Company(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(100))
    industry = db.Column(db.String(100))
    roles = db.relationship('Role', backref='company', lazy=True)

class Role(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    start_date = db.Column(db.Date)
    end_date = db.Column(db.Date)
    description = db.Column(db.Text)
    company_id = db.Column(db.Integer, db.ForeignKey('company.id'), nullable=False)
    projects = db.relationship('Project', backref='role', lazy=True)
    achievements = db.relationship('Achievement', backref='role', lazy=True)

class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    tools_used = db.Column(db.String(255))
    impact = db.Column(db.Text)
    role_id = db.Column(db.Integer, db.ForeignKey('role.id'), nullable=False)

class Achievement(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    details = db.Column(db.Text)
    role_id = db.Column(db.Integer, db.ForeignKey('role.id'), nullable=False)
