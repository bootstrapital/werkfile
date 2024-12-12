# templates/components.py
from fasthtml.common import *
from typing import Optional, Union, List, Callable

def Card(content, title: Optional[str] = None, actions: Optional[Union[str, List]] = None, cls: str = ""):
    """
    A general purpose card component using PicoCSS article styling
    """
    return Article(
        H3(title) if title else None,
        Div(content),
        Div(actions, cls="grid") if actions else None,
        cls=f"card {cls}"
    )

def ButtonLink(
    text: str, 
    href: str, 
    cls: str = "", 
    confirm: Optional[str] = None,
    **attrs
):
    """
    A link styled as a button using PicoCSS
    """
    if confirm:
        attrs['onclick'] = f"return confirm('{confirm}')"
    
    return A(text, href=href, role="button", cls=cls, **attrs)

def FormField(
    name: str,
    label: str,
    field_type: str = "text",
    required: bool = False,
    value: str = "",
    placeholder: str = "",
    options: List[tuple] = None,
    **attrs
):
    """
    A form field component using PicoCSS styling
    """
    field_id = attrs.pop('id', name)
    
    if field_type == "select" and options:
        input_element = Select(
            Option(placeholder or "Select...", value="") if placeholder else None,
            *[Option(label, value=val) for val, label in options],
            name=name,
            id=field_id,
            value=value,
            required=required,
            **attrs
        )
    elif field_type == "textarea":
        input_element = Textarea(
            value,
            name=name,
            id=field_id,
            required=required,
            placeholder=placeholder,
            **attrs
        )
    else:
        input_element = Input(
            type=field_type,
            name=name,
            id=field_id,
            value=value,
            required=required,
            placeholder=placeholder,
            **attrs
        )
    
    return Div(
        Label(f"{label}{'*' if required else ''}", For=field_id),
        input_element
    )

def FormGrid(fields: List, cols: int = 2):
    """
    A grid of form fields using PicoCSS grid
    """
    return Div(fields, cls=f"grid grid-cols-{cols}")

def FormSection(
    fields: List,
    title: Optional[str] = None,
    cls: str = ""
):
    """
    A grouped section of form fields
    """
    return Article(
        H4(title) if title else None,
        fields,
        cls=cls
    )

def Table(
    headers: List[str],
    rows: List[List],
    row_actions: Optional[Callable] = None,
    cls: str = ""
):
    """
    A table component using PicoCSS styling
    """
    return Tag("table")(
        Thead(
            Tr(
                *(Th(header) for header in headers),
                Th("Actions") if row_actions else None
            )
        ),
        Tbody(
            *(Tr(
                *(Td(cell) for cell in row),
                Td(row_actions(row)) if row_actions else None
            ) for row in rows)
        ),
        role="grid",
        cls=cls
    )

def Badge(text: str, variant: str = "primary"):
    """
    A badge component using PicoCSS colors
    """
    return Small(text, cls=f"badge {variant}")

def EmptyState(
    message: str = "No items found",
    action: Optional[Union[str, List]] = None
):
    """
    Empty state component
    """
    return Article(
        P(message, cls="text-center"),
        Div(action, cls="grid") if action else None,
        cls="empty-state"
    )

# Minimal additional styles to complement PicoCSS
COMPONENT_STYLES = Style("""
    /* Cards */
    article.card {
        margin-bottom: var(--spacing);
        padding: var(--spacing);
    }
    
    /* Badges */
    .badge {
        display: inline-block;
        padding: 0.25rem 0.5rem;
        font-size: 0.75rem;
        font-weight: 600;
        border-radius: 999px;
    }
    
    /* Empty State */
    .empty-state {
        text-align: center;
        padding: var(--spacing);
    }
    
    /* Grid Utilities */
    .grid-cols-2 { grid-template-columns: repeat(2, 1fr); }
    .grid-cols-3 { grid-template-columns: repeat(3, 1fr); }
    .grid-cols-4 { grid-template-columns: repeat(4, 1fr); }
    
    @media (max-width: 768px) {
        .grid-cols-2,
        .grid-cols-3,
        .grid-cols-4 {
            grid-template-columns: 1fr;
        }
    }
""")