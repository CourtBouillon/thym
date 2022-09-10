from datetime import date, timedelta
from uuid import uuid4
import sqlite3

from flask import Flask, abort, redirect, render_template, request, url_for

app = Flask(__name__)
app.config.update(
    SECRET_KEY=b'change_me_in_configuration_file',
    DB='db.sqlite')
app.config.from_envvar('THYM_CONFIG', silent=True)


def get_connection():
    connection = sqlite3.connect(app.config['DB'])
    connection.row_factory = sqlite3.Row
    return connection


def check_survey(survey_id, cursor):
    cursor.execute(
        'SELECT name, start, stop FROM survey WHERE id = (?)',
        (survey_id,))
    survey = cursor.fetchone()
    if survey is None:
        return abort(404)

    today = f'{date.today()}'
    start = survey['start'] or '0001-01-01'
    stop = survey['stop'] or '9999-12-31'
    if not (start <= today <= stop):
        return abort(403)

    return survey


@app.route('/<int:survey_id>')
def survey(survey_id):
    cursor = get_connection().cursor()
    survey = check_survey(survey_id, cursor)

    cursor.execute(
        'SELECT page.id AS page_id, '
        '       block.id AS block_id, block.type, block.text, '
        '       choice.id, choice.value '
        'FROM page '
        'JOIN block ON block.page_id = page.id '
        'LEFT OUTER JOIN choice ON choice.block_id = block.id '
        'WHERE survey_id = (?) '
        'ORDER BY page.number, block.number, choice.number ',
        (survey_id,))
    choices = cursor.fetchall()

    if (user := request.cookies.get('user')) is not None:
        cursor.execute(
            'SELECT 1 '
            'FROM answer '
            'JOIN block ON answer.block_id = block.id '
            'JOIN page ON block.page_id = page.id '
            'WHERE survey_id = (?) '
            'AND user = (?)',
            (survey_id, user))
        if cursor.fetchone():
            return abort(403)

    cursor.close()
    return render_template(
        'survey.html', survey=survey, choices=choices)


@app.route('/<int:survey_id>', methods=('POST',))
def save_survey(survey_id):
    connection = get_connection()
    cursor = connection.cursor()
    check_survey(survey_id, cursor)
    if (user := request.cookies.get('user')) is None:
        user = uuid4().hex

    cursor.execute(
        'SELECT block.id '
        'FROM block '
        'JOIN page ON block.page_id = page.id '
        'WHERE page.survey_id = (?) ',
        [survey_id])
    survey_block_ids = {block['id'] for block in cursor.fetchall()}

    request_block_id = {int(block_id) for block_id in request.form}
    if not (request_block_id <= survey_block_ids):
        return abort(403)

    cursor.execute(
        'SELECT 1 '
        'FROM answer '
        'WHERE user = (?) '
        f'AND block_id IN ({",".join("?" * len(survey_block_ids))})',
        [user] + list(survey_block_ids))
    if cursor.fetchone():
        return abort(403)

    for block_id in request.form:
        for value in request.form.getlist(block_id):
            cursor.execute(
                'INSERT INTO answer VALUES (NULL, ?, ?, ?)',
                (user, value, block_id))

    connection.commit()
    cursor.close()

    response = redirect(url_for('thank_you'))
    response.set_cookie('user', user, max_age=timedelta(days=60))
    return response


@app.route('/admin/')
def admin():
    cursor = get_connection().cursor()
    cursor.execute(
        'SELECT id, name '
        'FROM survey '
        'ORDER BY id')
    surveys = cursor.fetchall()
    return render_template('admin.html', surveys=surveys)


@app.route('/admin/<int:survey_id>')
def admin_survey(survey_id):
    cursor = get_connection().cursor()
    cursor.execute(
        'SELECT name, '
        '       page.id AS page_id, '
        '       block.id AS block_id, block.type, block.text, '
        '       choice.id AS choice_id, choice.value AS choice_value, '
        '       answer.id, answer.value, answer.user '
        'FROM page '
        'JOIN block ON block.page_id = page.id '
        'LEFT OUTER JOIN choice ON choice.block_id = block.id '
        'LEFT OUTER JOIN answer ON answer.block_id = block.id '
        'JOIN survey ON page.survey_id = survey.id '
        'WHERE survey_id = (?) '
        'ORDER BY page.number, block.number, choice.number ',
        (survey_id,))
    answers = cursor.fetchall()
    return render_template('admin_survey.html', answers=answers)


@app.route('/thank-you')
def thank_you():
    message = 'Thank you 💜'
    return render_template('message.html', message=message)


@app.errorhandler(403)
def error_403(error):
    message = 'This survey is closed or you already answered it 😎'
    return render_template('message.html', message=message), 403


@app.errorhandler(404)
def error_404(error):
    message = 'This page doesn’t exist 😱'
    return render_template('message.html', message=message), 404
