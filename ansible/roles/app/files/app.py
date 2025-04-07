from flask import Flask, render_template
import psycopg2
import config

app = Flask(__name__)


def get_team_members():
    conn = psycopg2.connect(
        host=config.DB_HOST,
        database=config.DB_NAME,
        user=config.DB_USER,
        password=config.DB_PASS
    )
    cur = conn.cursor()
    cur.execute("SELECT name, role FROM users")  # Modified to include roles
    members = [{"name": row[0], "role": row[1]} for row in cur.fetchall()]
    cur.close()
    conn.close()
    return members


@app.route("/")
def home():
    team_members = get_team_members()
    return render_template("index.html", team_members=team_members)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)  #nosec = B104
