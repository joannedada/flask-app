import os

DB_HOST = os.getenv("DB_HOST", "172.31.81.215")
DB_NAME = os.getenv("DB_NAME", "devopsdb")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASS = os.getenv("DB_PASS", "postgres")
