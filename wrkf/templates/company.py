# templates/company.py
from fasthtml.common import *
from .base import BasePage, Header
from .components import (
    Card, ButtonLink, FormField, FormGrid, FormSection, 
    EmptyState, COMPONENT_STYLES
)
from typing import Optional, List
from models import Company

def CompanyCard(company: Company):
    """Individual company card component"""
    content = Div(
        P(Strong("Industry: "), Span(company.industry)),
        P(Strong("Location: "), Span(company.headquarters_location)) if company.headquarters_location else None,
        P(Strong("Size: "), Span(company.company_size_range)) if company.company_size_range else None,
        P(
            Strong("Website: "), 
            A(company.website, href=company.website, target="_blank")
        ) if company.website else None,
    )
    
    actions = [
        ButtonLink("Edit", href=f"/companies/{company.id}/edit", cls="outline"),
        ButtonLink(
            "Delete", 
            href=f"/companies/{company.id}/delete",
            cls="outline contrast",
            confirm="Are you sure you want to delete this company?"
        )
    ]
    
    return Card(content, title=company.name, actions=actions)

def render_company_list(companies: List[Company]):
    """Render the company listing page"""
    actions = ButtonLink("Add Company", href="/companies/new", cls="primary")
    
    content = Div(
        Header("Companies", actions),
        Div(
            *(CompanyCard(company) for company in companies),
            cls="grid"
        ) if companies else EmptyState(
            "No companies found.",
            ButtonLink("Add your first company", href="/companies/new", cls="primary")
        ),
        COMPONENT_STYLES
    )
    
    return BasePage(content)

def render_company_form(company: Optional[Company] = None):
    """Render the company creation/edit form"""
    is_edit = company is not None
    title = "Edit Company" if is_edit else "New Company"
    
    size_options = [
        ("1-10", "1-10 employees"),
        ("11-50", "11-50 employees"),
        ("51-200", "51-200 employees"),
        ("201-500", "201-500 employees"),
        ("501-1000", "501-1000 employees"),
        ("1001+", "1001+ employees"),
    ]
    
    form_content = Form(
        FormSection([
            FormGrid([
                FormField("name", "Company Name", required=True, 
                         value=company.name if company else ""),
                FormField("industry", "Industry", required=True, 
                         value=company.industry if company else ""),
            ]),
            FormGrid([
                FormField("website", "Website", field_type="url", 
                         value=company.website if company else "",
                         placeholder="https://example.com"),
                FormField("headquarters_location", "Headquarters Location",
                         value=company.headquarters_location if company else ""),
            ]),
            FormField("company_size_range", "Company Size Range", 
                     field_type="select",
                     options=size_options,
                     value=company.company_size_range if company else "")
        ]),
        Input(type="hidden", name="company_id", 
              value=str(company.id)) if is_edit else None,
        Div(
            ButtonLink("Cancel", href="/companies", cls="outline"),
            Button("Save Company", type="submit", cls="primary"),
            cls="grid"
        ),
        action="/companies/save",
        method="POST"
    )
    
    content = Div(
        Header(title),
        form_content,
        COMPONENT_STYLES
    )
    
    return BasePage(content)