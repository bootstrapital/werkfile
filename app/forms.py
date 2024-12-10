from flask_wtf import FlaskForm
from wtforms import StringField, SubmitField
from wtforms.validators import DataRequired, Length

class CompanyForm(FlaskForm):
    name = StringField('Company Name', validators=[DataRequired(), Length(max=100)])
    industry = StringField('Industry', validators=[Length(max=100)])
    location = StringField('Location', validators=[Length(max=100)])
    submit = SubmitField('Save')
