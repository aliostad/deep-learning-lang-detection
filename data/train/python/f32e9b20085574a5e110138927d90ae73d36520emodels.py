from app import db

class Base(db.Model):
        __abstract__  = True
        id = db.Column(db.Integer, primary_key=True)

class RepositoryPackage(Base):
        __tablename__ = 'repository_package'
        repository_id = db.Column(db.Integer, db.ForeignKey('repository.id'))
        package_id = db.Column(db.Integer, db.ForeignKey('package.id'))

        def __init__(self, repository_id=None, package_id=None):
                self.repository_id = repository_id
                self.package_id = package_id

        def __repr__(self):
                return '<RepositoryPackage %r>' % (self.id) 
