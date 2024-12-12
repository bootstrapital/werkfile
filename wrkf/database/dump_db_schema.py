import sqlite3
import os

def export_sqlite_schema(db_path, output_file):
    """
    Export the complete schema of a SQLite database to a single file.
    
    :param db_path: Path to the SQLite database file
    :param output_file: Path to the output schema file
    """
    # Connect to the database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Open the output file
    with open(output_file, 'w') as f:
        # Write file header
        f.write("-- SQLite Database Schema Export\n")
        f.write(f"-- Exported on: {os.popen('date').read().strip()}\n\n")
        f.write("PRAGMA foreign_keys=OFF;\n")
        f.write("BEGIN TRANSACTION;\n\n")

        # Function to get create statements
        def get_create_statement(type, name):
            """Retrieve the CREATE statement for various database objects"""
            try:
                cursor.execute(f"SELECT sql FROM sqlite_master WHERE type=? AND name=?", (type, name))
                result = cursor.fetchone()
                return result[0] + ";\n\n" if result and result[0] else ""
            except Exception as e:
                print(f"Error retrieving {type} {name}: {e}")
                return ""

        # Retrieve and write table schemas
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;")
        tables = cursor.fetchall()
        
        f.write("-- TABLES\n")
        for table in tables:
            table_name = table[0]
            # Skip sqlite internal tables
            if table_name.startswith('sqlite_'):
                continue
            
            # Get table creation SQL
            create_table_sql = get_create_statement('table', table_name)
            f.write(create_table_sql)

        # Retrieve and write view schemas
        cursor.execute("SELECT name FROM sqlite_master WHERE type='view' ORDER BY name;")
        views = cursor.fetchall()
        
        f.write("\n-- VIEWS\n")
        for view in views:
            view_name = view[0]
            create_view_sql = get_create_statement('view', view_name)
            f.write(create_view_sql)

        # Retrieve and write index schemas
        cursor.execute("SELECT name FROM sqlite_master WHERE type='index' ORDER BY name;")
        indices = cursor.fetchall()
        
        f.write("\n-- INDICES\n")
        for index in indices:
            index_name = index[0]
            # Skip internal sqlite indices
            if index_name.startswith('sqlite_'):
                continue
            
            create_index_sql = get_create_statement('index', index_name)
            f.write(create_index_sql)

        # Retrieve and write trigger schemas
        cursor.execute("SELECT name FROM sqlite_master WHERE type='trigger' ORDER BY name;")
        triggers = cursor.fetchall()
        
        f.write("\n-- TRIGGERS\n")
        for trigger in triggers:
            trigger_name = trigger[0]
            create_trigger_sql = get_create_statement('trigger', trigger_name)
            f.write(create_trigger_sql)

        # Close transaction
        f.write("\nCOMMIT;\n")
        f.write("PRAGMA foreign_keys=ON;\n")

    # Close database connection
    conn.close()

    print(f"Database schema exported to {output_file}")

# Example usage
if __name__ == "__main__":
    export_sqlite_schema('werkfile.db', 'werkfile_schema.sql')