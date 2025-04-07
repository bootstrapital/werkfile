# werkfile/werkfile/services/experience_service.py
# Handles CRUD operations for experience entries, interacting with Xata.io
# Important: All functions MUST scope queries by the authenticated user ID.

import yaml
# from flask import current_app # To access Xata client if initialized on app

# Placeholder for Xata client initialization
# xata = current_app.xata_client

def get_experiences(user_id):
    """Fetch all experience entries for a given user."""
    print(f'SERVICE: Fetching experiences for user: {user_id}') # Replace with Xata call
    # Example Xata query: 
    # results = xata.data().query('experiences', {
    #     'filter': {'userId': user_id},
    #     'sort': [{'createdAt': 'desc'}]
    # })
    # return results.get('records', [])
    return [] # Placeholder

def get_experience(user_id, entry_id):
    """Fetch a single experience entry by ID for a given user."""
    print(f'SERVICE: Fetching experience {entry_id} for user: {user_id}') # Replace with Xata call
    # Example Xata query:
    # record = xata.records().get('experiences', entry_id)
    # if record and record.get('userId') == user_id:
    #    return record
    return None # Placeholder

def create_experience(user_id, entry_name, yaml_data):
    """Create a new experience entry for a given user."""
    print(f'SERVICE: Creating experience "{entry_name}" for user: {user_id}') # Replace with Xata call
    # Validate YAML?
    # try:
    #     parsed_data = yaml.safe_load(yaml_data)
    # except yaml.YAMLError as e:
    #     print(f'Invalid YAML: {e}')
    #     return None # Or raise error

    # Example Xata insert:
    # record = xata.records().insert('experiences', {
    #    'userId': user_id,
    #    'entryName': entry_name,
    #    'experienceData': yaml_data
    # })
    # return record
    return {'id': 'new123', 'entryName': entry_name} # Placeholder

def update_experience(user_id, entry_id, entry_name, yaml_data):
    """Update an existing experience entry for a given user."""
    print(f'SERVICE: Updating experience {entry_id} for user: {user_id}') # Replace with Xata call
    # First verify ownership (redundant if query below handles it, but good practice)
    # existing = get_experience(user_id, entry_id)
    # if not existing: return None

    # Example Xata update:
    # record = xata.records().update('experiences', entry_id, {
    #    'entryName': entry_name,
    #    'experienceData': yaml_data
    # }) # Note: Need Xata policies or backend check to ensure user_id matches
    # return record
    return {'id': entry_id, 'entryName': entry_name} # Placeholder

def delete_experience(user_id, entry_id):
    """Delete an experience entry for a given user."""
    print(f'SERVICE: Deleting experience {entry_id} for user: {user_id}') # Replace with Xata call
    # First verify ownership
    # existing = get_experience(user_id, entry_id)
    # if not existing: return False

    # Example Xata delete:
    # xata.records().delete('experiences', entry_id)
    # return True
    return True # Placeholder

def parse_yaml_safely(yaml_string):
    """Safely parse YAML string, return data or None if invalid."""
    try:
        data = yaml.safe_load(yaml_string)
        # Basic check if it's a dictionary-like structure
        # You might add more specific validation here based on expected schema
        if isinstance(data, dict):
             return data
        else:
             # Handle cases where YAML is valid but not the expected type (e.g., just a string, list)
             print('Parsed YAML is not a dictionary.')
             return None
    except yaml.YAMLError as e:
        print(f'YAML parsing error: {e}')
        return None
