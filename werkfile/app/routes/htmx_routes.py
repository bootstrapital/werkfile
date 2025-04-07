# werkfile/werkfile/routes/htmx_routes.py - Routes serving HTMX fragments
from flask import Blueprint, render_template, request, jsonify, make_response
# from kinde_sdk.decorators import login_required
# from .page_routes import get_kinde_user_id # Or centralize user fetching
# from ..services import experience_service

bp = Blueprint('htmx', __name__, url_prefix='/htmx')

# --- Experience List ---
@bp.route('/experiences', methods=['GET'])
# @login_required
def get_experience_list():
    """Return the HTML fragment for the experience list."""
    # user_id = get_kinde_user_id()
    user_id = 'user123' # Placeholder
    # experiences = experience_service.get_experiences(user_id)
    experiences = [{'id': '1', 'entryName': 'Sample Project'}, {'id': '2', 'entryName': 'Another Role'}] # Placeholder
    return render_template('partials/experience_list.html', experiences=experiences)

# --- Experience Editor ---
@bp.route('/experiences/<entry_id>/edit', methods=['GET'])
# @login_required
def get_experience_editor(entry_id):
    """Return the HTML fragment for the editor for a specific entry."""
    # user_id = get_kinde_user_id()
    user_id = 'user123' # Placeholder
    # experience = experience_service.get_experience(user_id, entry_id)
    experience = {'id': entry_id, 'entryName': 'Sample Project', 'experienceData': 'key: value\nanother_key: another_value'} # Placeholder
    if not experience:
        return ('Entry not found or not authorized', 404)
    return render_template('partials/experience_editor.html', experience=experience)

@bp.route('/experiences/new/edit', methods=['GET'])
# @login_required
def get_new_experience_editor():
    """Return the HTML fragment for the editor for a new entry."""
    return render_template('partials/experience_editor.html', experience=None) # Pass None or empty dict

# --- Experience CRUD Operations (triggered by editor form submissions) ---
@bp.route('/experiences', methods=['POST'])
# @login_required
def create_experience_entry():
    """Handle creation of a new experience entry."""
    # user_id = get_kinde_user_id()
    user_id = 'user123' # Placeholder
    entry_name = request.form.get('entryName', 'New Entry')
    yaml_data = request.form.get('experienceData', '')

    # new_experience = experience_service.create_experience(user_id, entry_name, yaml_data)
    new_experience = {'id': 'new123', 'entryName': entry_name} # Placeholder

    if new_experience:
        # Respond with updated list item fragment and potentially trigger other updates
        # Fetch the newly created item to render it
        # experience_for_render = experience_service.get_experience(user_id, new_experience['id'])
        experience_for_render = new_experience # Placeholder
        response = make_response(render_template('partials/experience_list_item.html', experience=experience_for_render))
        # Add HX-Trigger header to tell HTMX to reload the list, select the new item, load editor etc.
        response.headers['HX-Trigger'] = '{"experienceListChanged": null, "loadEditor": "' + new_experience['id'] + '"}'
        return response
    else:
        # Handle error (e.g., invalid YAML)
        return ('Failed to create entry', 400)

@bp.route('/experiences/<entry_id>', methods=['PUT', 'POST']) # Use PUT or POST from form
# @login_required
def update_experience_entry(entry_id):
    """Handle updating an existing experience entry."""
    # user_id = get_kinde_user_id()
    user_id = 'user123' # Placeholder
    entry_name = request.form.get('entryName')
    yaml_data = request.form.get('experienceData')

    # updated_experience = experience_service.update_experience(user_id, entry_id, entry_name, yaml_data)
    updated_experience = {'id': entry_id, 'entryName': entry_name} # Placeholder

    if updated_experience:
        # Respond potentially with updated list item or just confirmation/trigger
        # Fetch the updated item to render it in the list
        # experience_for_render = experience_service.get_experience(user_id, updated_experience['id'])
        experience_for_render = updated_experience # Placeholder
        response = make_response(render_template('partials/experience_list_item.html', experience=experience_for_render))
        # Trigger list item update (oob swap) and maybe preview update
        response.headers['HX-Trigger'] = '{"previewNeedsUpdate": "' + entry_id + '"}' # Assuming list item updates itself via oob swap
        # If list item isn't OOB swapped, trigger full list reload: 'experienceListChanged': null
        return response
    else:
        return ('Failed to update entry or not authorized', 400) # Or 404

@bp.route('/experiences/<entry_id>', methods=['DELETE'])
# @login_required
def delete_experience_entry(entry_id):
    """Handle deletion of an experience entry."""
    # user_id = get_kinde_user_id()
    user_id = 'user123' # Placeholder
    # success = experience_service.delete_experience(user_id, entry_id)
    success = True # Placeholder

    if success:
        # Respond with empty content, trigger list update and potentially clear editor/preview
        response = make_response('', 200)
        response.headers['HX-Trigger'] = '{"experienceListChanged": null, "clearEditorPreview": null}'
        return response
    else:
        return ('Failed to delete entry or not authorized', 400) # Or 404

# --- Live Preview ---
@bp.route('/preview', methods=['POST'])
# @login_required
def update_preview():
    """Generate and return the HTML fragment for the live preview based on submitted YAML."""
    yaml_data = request.form.get('experienceData', '')
    # parsed_data = experience_service.parse_yaml_safely(yaml_data)
    parsed_data = {'preview_key': 'preview_value'} if yaml_data else {} # Placeholder parsing

    # Render a preview partial template with the parsed data
    return render_template('partials/experience_preview.html', data=parsed_data)

