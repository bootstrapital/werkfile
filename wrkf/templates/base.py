# templates/base.py
from fasthtml.common import *

def SideNav():
    """Navigation sidebar component"""
    return Div(
        H3('Werkfile'),
        Nav(
            Ul(
                Li(A('Dashboard', href='/', cls='nav-link')),
                Li(A('Add Experience', href='/experiences/new', cls='nav-link')),
                Li(A('Companies', href='/companies', cls='nav-link')),
                Li(A('Technologies', href='/technologies', cls='nav-link')),
            ),
            cls='nav-menu'
        ),
        cls='sidenav'
    )

def Header(title: str, actions=None):
    """Page header component with optional action buttons"""
    return Section(
        Div(
            H1(title, cls='page-title'),
            Div(actions, cls='header-actions') if actions else None,
            cls='header-content'
        ),
        cls='page-header'
    )

def BasePage(content, title: str = "Work Experience Manager"):
    """Base page template with consistent layout and styling"""
    return Html(
        Head(
            Meta(charset='UTF-8'),
            Meta(name='viewport', content='width=device-width, initial-scale=1.0'),
            Title(title),
            # Base CSS framework
            Link(rel='stylesheet', href='https://unpkg.com/@picocss/pico@latest/css/pico.min.css'),
            # Custom styles
            Style('''
                /* Layout */
                .site-layout {
                    display: flex;
                    min-height: 100vh;
                }
                
                /* Sidebar */
                .sidenav {
                    width: 250px;
                    height: 100vh;
                    position: fixed;
                    top: 0;
                    left: 0;
                    background: var(--background-color);
                    border-right: 1px solid var(--border-color);
                    padding: 1rem;
                    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
                    overflow-y: auto;
                }
                
                .sidenav h3 {
                    margin-bottom: 1.5rem;
                    padding-bottom: 0.5rem;
                    border-bottom: 1px solid var(--border-color);
                }
                
                .nav-menu {
                    padding: 0;
                }
                
                .nav-menu ul {
                    list-style: none;
                    padding: 0;
                }
                
                .nav-menu li {
                    margin: 0.5rem 0;
                }
                
                .nav-link {
                    display: block;
                    padding: 0.5rem 1rem;
                    color: var(--color);
                    text-decoration: none;
                    border-radius: 4px;
                    transition: background-color 0.2s;
                }
                
                .nav-link:hover {
                    background-color: var(--secondary);
                    color: var(--secondary-inverse);
                }
                
                /* Main Content */
                .main-content {
                    flex: 1;
                    margin-left: 250px;
                    padding: 2rem;
                    max-width: 1200px;
                    width: 100%;
                }
                
                /* Header */
                .page-header {
                    margin-bottom: 2rem;
                }
                
                .header-content {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding-bottom: 1rem;
                    border-bottom: 1px solid var(--border-color);
                }
                
                .page-title {
                    margin: 0;
                }
                
                .header-actions {
                    display: flex;
                    gap: 1rem;
                }
                
                /* Cards */
                .card {
                    background: var(--background-color);
                    border: 1px solid var(--border-color);
                    border-radius: 4px;
                    padding: 1rem;
                    margin-bottom: 1rem;
                }
                
                /* Forms */
                .form-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 1rem;
                }
                
                .form-section {
                    background: var(--background-color);
                    border: 1px solid var(--border-color);
                    border-radius: 4px;
                    padding: 1rem;
                    margin-bottom: 1rem;
                }
                
                /* Utilities */
                .text-small {
                    font-size: 0.875rem;
                }
                
                .text-muted {
                    color: var(--muted-color);
                }
                
                .badge {
                    display: inline-block;
                    padding: 0.25rem 0.5rem;
                    border-radius: 999px;
                    font-size: 0.75rem;
                    font-weight: 600;
                }
                
                .badge-primary {
                    background: var(--primary);
                    color: var(--primary-inverse);
                }
                
                .badge-secondary {
                    background: var(--secondary);
                    color: var(--secondary-inverse);
                }
                
                /* Responsive */
                @media (max-width: 768px) {
                    .sidenav {
                        width: 100%;
                        height: auto;
                        position: relative;
                    }
                    
                    .main-content {
                        margin-left: 0;
                    }
                    
                    .site-layout {
                        flex-direction: column;
                    }
                    
                    .header-content {
                        flex-direction: column;
                        gap: 1rem;
                    }
                    
                    .header-actions {
                        width: 100%;
                        justify-content: flex-start;
                    }
                }
            ''')
        ),
        Body(
            Div(
                SideNav(),
                Main(content, cls='main-content'),
                cls='site-layout'
            )
        ),
        lang='en'
    )