# app.py
from fasthtml.common import *
from wrkf.routes import register_routes

app, rt = fast_app()
register_routes(rt)

if __name__ == "__main__":
    serve()