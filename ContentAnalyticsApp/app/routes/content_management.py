from flask import Blueprint, render_template, request, redirect, url_for, flash
from app.models import fetch_content, remove_content, add_content, add_content_keyword

content = Blueprint('content_management', __name__)

@content.route('/content-management', methods=['GET', 'POST'])
def content_management():
    search_query = request.args.get('search', '') 
    print(search_query)
    contents = fetch_content()

    if search_query:
        filtered_contents = [content for content in contents if search_query.lower() in content["file_name"].lower()]
    else:
        filtered_contents = contents
    return render_template('manage_content.html', contents=filtered_contents)


@content.route('/remove-file/<file_id>', methods=['POST'])
def remove_file(file_id):
    if file_id:
        remove_content(file_id)
    return redirect(url_for('content_management.content_management')) 


@content.route('/add-file', methods=['POST'])
def add_file():
    file_name = request.form['fileName']
    file_type = request.form['fileType']
    keywords = request.form['fileKeywords'].split(',')

    
    success = add_content(file_name, file_type)
    if success:
        for keyword in keywords:
            keyword = keyword.strip()
            if keyword:
                add_content_keyword(file_name, keyword)
        flash('File and keywords successfully added!', 'success')
    else:
        flash('An error occurred while adding the file.', 'danger')

    return redirect(url_for('content_management.content_management'))