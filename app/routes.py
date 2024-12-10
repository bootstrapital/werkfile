from flask import Blueprint, render_template, request, jsonify
from app.extensions import db
from app.models import Company
from app.forms import CompanyForm

main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    companies = Company.query.all()
    return render_template('index.html', companies=companies)

# ------------------------------------------------------------------------------
# Company Routes
# ------------------------------------------------------------------------------

@main_bp.route("/company/new", methods=["GET", "POST"])
def new_company():
    form = CompanyForm()
    if form.validate_on_submit():
        # Save form data to the database
        new_company = Company(
            name=form.name.data,
            industry=form.industry.data,
            location=form.location.data,
        )
        db.session.add(new_company)
        db.session.commit()

        # Return the updated company list or a success response
        companies = Company.query.all()
        return render_template("partials/company_list.html", companies=companies)

    # For GET requests or form errors
    return render_template("partials/company_form.html", form=form)

@main_bp.route('/company/<int:id>')
def company_detail(id):
    company = Company.query.get_or_404(id)
    return render_template('company_detail.html', company=company)
