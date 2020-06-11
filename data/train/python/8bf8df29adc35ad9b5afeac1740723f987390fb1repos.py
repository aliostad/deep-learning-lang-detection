#-*- coding: UTF-8 -*- 
# 
from projectTeam.models.database import BaseModel
from sqlalchemy import Column,DateTime,NVARCHAR,SMALLINT,Integer,ForeignKey, Float, UnicodeText
from sqlalchemy.orm import relationship
 
#from projectTeam.models.project import Project
from projectTeam.models.repositoryprofile import RepositoryProfile



class Repository(BaseModel):
 
    __tablename__ = 'Repository'
    RepositoryId = Column('RepositoryId', Integer,primary_key=True,nullable=False,autoincrement=True)
    RepositoryName = Column('RepositoryName', NVARCHAR(30),nullable = False)
#     RepositoryCategory = relationship('RepositoryProfile')



