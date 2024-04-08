from flask import Blueprint, render_template, request
from app.models import fetch_content, remove_content

content = Blueprint('content_management', __name__)

@content.route('/content-management', methods=['GET', 'POST'])
def content_management():
    search_query = request.args.get('search', '')  # Get the search query from the URL parameters
    print(search_query)
    # Assume contents is a list of dictionaries representing your files
    contents = fetch_content()

    if search_query:
        # Filter contents based on the search query
        filtered_contents = [content for content in contents if search_query.lower() in content["file_name"].lower()]
    else:
        filtered_contents = contents
    return render_template('manage_content.html', contents=filtered_contents)


@content.route('/remove-file/<file_id>', methods=['POST'])
def remove_file(file_id):
    if file_id:
        remove_content(file_id)
    return redirect(url_for('content_management.content_management')) 
# @content.route('/videos')
# def show_videos():
#     videos = fetch_videos()
#     print(videos)

#     return str(videos)