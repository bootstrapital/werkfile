# templates/work_experience.py
from fasthtml.common import *
from datetime import datetime
from typing import List, Optional
from .base import BasePage, Header
from .components import (
    Card, ButtonLink, FormField, FormGrid, FormSection, 
    Badge, EmptyState, COMPONENT_STYLES
)
from models import WorkExperience, Company, Technology

def format_date_range(start_date: str, end_date: Optional[str], is_current: bool) -> str:
    """Format date range for display"""
    start = datetime.strptime(start_date, '%Y-%m-%d').strftime('%B %Y')
    if is_current:
        return f"{start} - Present"
    elif end_date:
        end = datetime.strptime(end_date, '%Y-%m-%d').strftime('%B %Y')
        return f"{start} - {end}"
    return start

def TechnologyBadge(tech: dict):
    """Display technology with proficiency level"""
    level_colors = {
        'beginner': 'secondary',
        'intermediate': 'primary',
        'advanced': 'contrast',
        'expert': 'success'
    }
    return Badge(
        f"{tech['name']} ({tech['level'].title()})", 
        variant=level_colors.get(tech['level'].lower(), 'primary')
    )

def ExperienceCard(experience: WorkExperience):
    """Card component for work experience summary"""
    content = Div(
        P(
            Strong(experience.company.name),
            Span(" • "),
            Span(experience.employment_type),
            cls="text-lg"
        ),
        P(
            format_date_range(
                experience.start_date,
                experience.end_date,
                experience.is_current
            ),
            cls="text-sm"
        ),
        P(experience.location) if experience.location else None,
        Div(
            *(TechnologyBadge(tech) for tech in experience.technologies[:3]),
            Span(f"+{len(experience.technologies) - 3}") if len(experience.technologies) > 3 else None,
            cls="tech-badges"
        ) if experience.technologies else None
    )
    
    actions = [
        ButtonLink("View", href=f"/experiences/{experience.id}", cls="outline"),
        ButtonLink("Edit", href=f"/experiences/{experience.id}/edit", cls="outline"),
        ButtonLink(
            "Delete",
            href=f"/experiences/{experience.id}/delete",
            cls="outline contrast",
            confirm="Are you sure you want to delete this experience?"
        )
    ]
    
    return Card(content, title=experience.title, actions=actions)

def TechnologySelect(tech: Technology, selected_level: Optional[str] = None):
    """Form component for selecting technology proficiency"""
    return FormField(
        f"tech_{tech.id}",
        tech.name,
        field_type="select",
        options=[
            ("", "Not Used"),
            ("beginner", "Beginner"),
            ("intermediate", "Intermediate"),
            ("advanced", "Advanced"),
            ("expert", "Expert")
        ],
        value=selected_level or ""
    )

def render_experience_list(experiences: List[WorkExperience]):
    """Render the work experience listing page"""
    actions = ButtonLink("Add Experience", href="/experiences/new", cls="primary")
    
    content = Div(
        Header("Work Experience", actions),
        Div(
            *(ExperienceCard(exp) for exp in experiences),
            cls="grid"
        ) if experiences else EmptyState(
            "No work experiences found.",
            ButtonLink("Add your first experience", href="/experiences/new", cls="primary")
        ),
        Style("""
            .tech-badges {
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
                margin-top: 0.5rem;
            }
            .text-lg { font-size: 1.125rem; }
            .text-sm { font-size: 0.875rem; }
        """),
        COMPONENT_STYLES
    )
    
    return BasePage(content)

def render_experience_form(
    companies: List[Company],
    technologies: List[Technology],
    experience: Optional[WorkExperience] = None
):
    """Render the work experience creation/edit form"""
    is_edit = experience is not None
    title = "Edit Experience" if is_edit else "New Experience"
    
    employment_types = [
        ("full-time", "Full-time"),
        ("part-time", "Part-time"),
        ("contract", "Contract"),
        ("internship", "Internship"),
        ("freelance", "Freelance")
    ]

    # Get current technology levels if editing
    tech_levels = {
        tech['id']: tech['level'] 
        for tech in experience.technologies
    } if experience else {}
    
    form_content = Form(
        # Basic Information
        FormSection([
            FormGrid([
                FormField("title", "Job Title", required=True,
                         value=experience.title if experience else ""),
                FormField("company_id", "Company", field_type="select",
                         options=[(str(c.id), c.name) for c in companies],
                         value=str(experience.company_id) if experience else "",
                         required=True)
            ]),
            FormGrid([
                FormField("employment_type", "Employment Type", field_type="select",
                         options=employment_types,
                         value=experience.employment_type if experience else "",
                         required=True),
                FormField("department", "Department",
                         value=experience.department if experience else "")
            ]),
            FormField("location", "Location",
                     value=experience.location if experience else "")
        ], title="Basic Information"),
        
        # Dates
        FormSection([
            FormGrid([
                FormField("start_date", "Start Date", field_type="date",
                         required=True,
                         value=experience.start_date if experience else ""),
                FormField("end_date", "End Date", field_type="date",
                         value=experience.end_date if experience else "")
            ]),
            FormField("is_current", "Current Position", field_type="checkbox",
                     value="true",
                     checked=experience.is_current if experience else False)
        ], title="Dates"),
        
        # Technologies
        FormSection([
            Div(
                *(TechnologySelect(
                    tech,
                    tech_levels.get(tech.id)
                ) for tech in technologies),
                cls="tech-grid"
            )
        ], title="Technologies Used"),
        
        # Responsibilities
        FormSection([
            FormField("responsibilities", "Responsibilities", field_type="textarea",
                     value="\n".join(experience.responsibilities) if experience and experience.responsibilities else "",
                     placeholder="Enter each responsibility on a new line")
        ], title="Responsibilities"),
        
        # Hidden field for edit mode
        Input(type="hidden", name="experience_id",
              value=str(experience.id)) if is_edit else None,
        
        # Form actions
        Div(
            ButtonLink("Cancel", href="/", cls="outline"),
            Button("Save Experience", type="submit", cls="primary"),
            cls="grid"
        ),
        
        action="/experiences/save",
        method="POST"
    )
    
    content = Div(
        Header(title),
        form_content,
        Style("""
            .tech-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 1rem;
            }
        """),
        COMPONENT_STYLES
    )
    
    return BasePage(content)

def render_experience_detail(experience: WorkExperience):
    """Render the work experience detail view"""
    actions = [
        ButtonLink("Edit", href=f"/experiences/{experience.id}/edit", cls="outline"),
        ButtonLink(
            "Delete",
            href=f"/experiences/{experience.id}/delete",
            cls="outline contrast",
            confirm="Are you sure you want to delete this experience?"
        )
    ]
    
    content = Div(
        Header(experience.title, actions),
        Article(
            # Company and basic info
            H3(experience.company.name),
            P(
                Strong(experience.employment_type),
                Span(" • "),
                Span(format_date_range(
                    experience.start_date,
                    experience.end_date,
                    experience.is_current
                )),
                cls="text-lg"
            ),
            P(experience.location) if experience.location else None,
            P(experience.department) if experience.department else None,
            
            # Technologies
            H4("Technologies Used"),
            Div(
                *(TechnologyBadge(tech) for tech in experience.technologies),
                cls="tech-badges"
            ) if experience.technologies else P("No technologies specified"),
            
            # Responsibilities
            H4("Responsibilities"),
            Ul(
                *(Li(resp) for resp in experience.responsibilities)
            ) if experience.responsibilities else P("No responsibilities specified"),
            
            cls="experience-detail"
        ),
        Style("""
            .experience-detail {
                max-width: 800px;
            }
            .tech-badges {
                display: flex;
                gap: 0.5rem;
                flex-wrap: wrap;
                margin: 1rem 0;
            }
            .text-lg {
                font-size: 1.125rem;
            }
        """),
        COMPONENT_STYLES
    )
    
    return BasePage(content)