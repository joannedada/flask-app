from flask import Flask, render_template
import psycopg2
import config

app = Flask(__name__)


def get_users():
    conn = psycopg2.connect(
        host=config.DB_HOST,
        database=config.DB_NAME,
        user=config.DB_USER,
        password=config.DB_PASS
    )
    cur = conn.cursor()
    cur.execute("SELECT name FROM users")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return [row[0] for row in rows]


@app.route("/")
def home():
    users = get_users()
    return render_template("index.html", users=users)


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000) # nosec B104
