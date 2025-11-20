#!/usr/bin/env python3
"""Ensure the alembic_version.version_num column can accept longer revision ids.

This script is safe to run multiple times and will not raise on failure.
It connects using `DATABASE_URL` environment variable and runs a guarded ALTER TABLE.
"""
import os
import sys
from urllib.parse import urlparse

COLUMN_LENGTH = max(32, int(os.getenv("ALEMBIC_VERSION_LENGTH", "168")))

try:
    import psycopg2
except Exception:
    print("psycopg2 not available; skipping ALTER on alembic_version.")
    sys.exit(0)


def main() -> int:
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("DATABASE_URL not set; skipping ALTER on alembic_version.")
        return 0

    parsed = urlparse(db_url)
    user = parsed.username
    password = parsed.password
    host = parsed.hostname or "localhost"
    port = parsed.port or 5432
    dbname = parsed.path.lstrip("/")

    try:
        conn = psycopg2.connect(user=user, password=password, host=host, port=port, dbname=dbname)
        conn.autocommit = True
        cur = conn.cursor()
        cur.execute(
            "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'alembic_version');"
        )
        exists = cur.fetchone()[0]
        if not exists:
            cur.execute(
                f"CREATE TABLE alembic_version (version_num VARCHAR({COLUMN_LENGTH}) NOT NULL);"
            )
            print(f"Created alembic_version table with VARCHAR({COLUMN_LENGTH}).")
        else:
            cur.execute(
                f"ALTER TABLE alembic_version ALTER COLUMN version_num TYPE varchar({COLUMN_LENGTH});"
            )
            print(f"Ensured alembic_version.version_num is VARCHAR({COLUMN_LENGTH}).")
        try:
            cur.close()
        except Exception:
            pass
        try:
            conn.close()
        except Exception:
            pass
        return 0
    except Exception as exc:
        print("Warning: could not ALTER alembic_version.version_num:", str(exc))
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
