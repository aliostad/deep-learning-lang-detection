import sqlite3

import jarvis.db.dal as dal


class DockerhubDal(dal.Dal):
    def create_follow(cur, uuid, repository):
        try:
            cur.execute(""" INSERT INTO dockerhub_repository
                              (uuid, repository)
                            VALUES (?, ?)
                        """, [uuid, repository])
            return True
        except sqlite3.IntegrityError:
            return False

    def delete_follow(cur, uuid, repository):
        cur.execute(""" DELETE FROM dockerhub_repository
                        WHERE uuid = ?
                        AND repository = ?
                    """, [uuid, repository])

    def read_by_repository(cur, repository):
        return cur.execute(""" SELECT uuid
                               FROM dockerhub_repository
                               WHERE repository = ?
                           """, [repository]).fetchone()

    def read_by_username(cur, username):
        return cur.execute(""" SELECT uuid
                               FROM dockerhub_username
                               WHERE username = ?
                           """, [username]).fetchone()

    def update_username(cur, uuid, username):
        cur.execute(""" INSERT OR REPLACE INTO dockerhub_username
                          (uuid, username)
                        VALUES (?, ?)
                    """, [uuid, username])
