from mini import db

REPOSITORY_ROLES = ["none", "find", "read", "comment", "write", "mod", "admin"]

class Permission(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    access = db.Column(db.Enum(*REPOSITORY_ROLES), default = "none")

    member = db.relationship("Member", backref="repository_permissions")
    member_id = db.Column(db.Integer, db.ForeignKey("member.id"))

    repository = db.relationship("Repository", backref="permissions")
    repository_id = db.Column(db.Integer, db.ForeignKey("repository.id"))

    def __init__(self, member, repository, access):
        self.member = member
        self.repository = repository
        self.access = access

    def satisfies(self, access):
        return access in REPOSITORY_ROLES and REPOSITORY_ROLES.index(self.access) >= REPOSITORY_ROLES.index(access)
