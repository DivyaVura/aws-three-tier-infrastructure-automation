
import os
import json
import boto3
import mysql.connector

from flask import (
    Flask,
    request,
    render_template_string,
    redirect,
    url_for
)

app = Flask(__name__)


def get_db_credentials():
    client = boto3.client("secretsmanager", region_name="ap-south-1")
    response = client.get_secret_value(
        SecretId="rds/terraform/credentials"
    )
    return json.loads(response["SecretString"])


def get_connection():
    credentials = get_db_credentials()

    return mysql.connector.connect(
        host=os.environ["DB_HOST"],
        user=credentials["username"],
        password=credentials["password"],
        database="threetierdb"
    )


HTML = """
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Management</title>

<style>
* { box-sizing: border-box; }

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f3f6fb;
    color: #1e293b;
}

header {
    background: #172554;
    color: white;
    padding: 22px 8%;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

header h2 { margin: 0; font-size: 22px; }
header span { color: #bfdbfe; font-size: 14px; }

.container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 0 20px;
}

.welcome { margin-bottom: 28px; }
.welcome h1 { margin-bottom: 8px; font-size: 28px; }
.welcome p { color: #64748b; margin: 0; }

.cards {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 24px;
}

.card {
    background: white;
    border-radius: 12px;
    padding: 26px;
    box-shadow: 0 3px 15px rgba(0,0,0,.05);
}

.card h3 { margin-top: 0; margin-bottom: 22px; }

label {
    display: block;
    font-size: 14px;
    font-weight: bold;
    margin: 16px 0 7px;
}

input {
    width: 100%;
    padding: 12px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    font-size: 14px;
}

input:focus {
    outline: none;
    border-color: #2563eb;
}

.add-button {
    width: 100%;
    margin-top: 22px;
    padding: 13px;
    border: none;
    border-radius: 7px;
    background: #2563eb;
    color: white;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
}

.add-button:hover { background: #1d4ed8; }

.count {
    background: #eff6ff;
    color: #1d4ed8;
    padding: 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: bold;
}

.table-wrap { overflow-x: auto; }

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 500px;
}

th, td {
    padding: 14px 12px;
    text-align: left;
    border-bottom: 1px solid #e2e8f0;
    font-size: 14px;
}

th {
    color: #64748b;
    background: #f8fafc;
}

.course {
    background: #dcfce7;
    color: #166534;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
}

.delete-button {
    background: #fee2e2;
    color: #b91c1c;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
}

.delete-button:hover {
    background: #fecaca;
}

.message {
    padding: 12px 16px;
    margin-bottom: 20px;
    border-radius: 8px;
    background: #dcfce7;
    color: #166534;
}

.empty {
    color: #64748b;
    text-align: center;
    padding: 30px;
}

footer {
    text-align: center;
    color: #94a3b8;
    padding: 30px;
    font-size: 13px;
}

@media(max-width: 750px) {
    .cards { grid-template-columns: 1fr; }
    .container { margin-top: 25px; }
    header { padding: 20px; }
}
</style>
</head>

<body>

<header>
    <h2>StudentHub</h2>
    <span>Student Management System</span>
</header>

<div class="container">

    <div class="welcome">
        <h1>Student Dashboard</h1>
        <p>Manage student registrations and records in one place.</p>
    </div>

    {% if message %}
        <div class="message">{{ message }}</div>
    {% endif %}

    <div class="cards">

        <section class="card">
            <h3>Register New Student</h3>

            <form method="POST" action="{{ url_for('home') }}">

                <label>Student Name</label>
                <input name="name"
                       placeholder="Enter full name"
                       maxlength="100"
                       required>

                <label>Email Address</label>
                <input name="email"
                       type="email"
                       placeholder="Enter email address"
                       maxlength="150"
                       required>

                <label>Course</label>
                <input name="course"
                       placeholder="Enter course name"
                       maxlength="100"
                       required>

                <button class="add-button" type="submit">
                    + Add Student
                </button>

            </form>
        </section>

        <section class="card">

            <h3>Student Records</h3>

            <div class="count">
                Total Students: {{ students|length }}
            </div>

            <div class="table-wrap">

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Course</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>

                        {% for student in students %}
                        <tr>
                            <td>{{ student[0] }}</td>
                            <td>{{ student[1] }}</td>
                            <td>{{ student[2] }}</td>
                            <td>
                                <span class="course">
                                    {{ student[3] }}
                                </span>
                            </td>
                            <td>
                                <form method="POST"
                                      action="{{ url_for('delete_student',
                                      student_id=student[0]) }}"
                                      onsubmit="return confirm(
                                      'Are you sure you want to delete this student?'
                                      );">

                                    <button class="delete-button"
                                            type="submit">
                                        Delete
                                    </button>

                                </form>
                            </td>
                        </tr>

                        {% else %}
                        <tr>
                            <td colspan="5" class="empty">
                                No student records available.
                            </td>
                        </tr>
                        {% endfor %}

                    </tbody>
                </table>

            </div>
        </section>

    </div>
</div>

<footer>
    StudentHub | AWS Three-Tier Architecture Project
</footer>

</body>
</html>
"""


@app.route("/", methods=["GET", "POST"])
def home():

    if request.method == "POST":

        name = request.form["name"].strip()
        email = request.form["email"].strip()
        course = request.form["course"].strip()

        if not name or not email or not course:
            return redirect(url_for("home"))

        connection = get_connection()

        try:
            cursor = connection.cursor()

            cursor.execute(
                """
                INSERT INTO students (name, email, course)
                VALUES (%s, %s, %s)
                """,
                (name, email, course)
            )

            connection.commit()

        finally:
            cursor.close()
            connection.close()

        return redirect(url_for("home", added=1))

    connection = get_connection()

    try:
        cursor = connection.cursor()

        cursor.execute(
            """
            SELECT id, name, email, course
            FROM students
            ORDER BY id DESC
            """
        )

        students = cursor.fetchall()

    finally:
        cursor.close()
        connection.close()

    message = None

    if request.args.get("added"):
        message = "Student added successfully!"

    elif request.args.get("deleted"):
        message = "Student deleted successfully!"

    return render_template_string(
        HTML,
        students=students,
        message=message
    )


@app.route("/students/<int:student_id>/delete", methods=["POST"])
def delete_student(student_id):

    connection = get_connection()

    try:
        cursor = connection.cursor()

        cursor.execute(
            "DELETE FROM students WHERE id = %s",
            (student_id,)
        )

        connection.commit()

    finally:
        cursor.close()
        connection.close()

    return redirect(url_for("home", deleted=1))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
