from User import User
from User_manager import User_manager

class Register_controller:

      def GetRegisterData(self, Fname, Lname, Email, Pass, Relationship, Sex, Bday, Route_visible,Pics_visible,User_ID=0 ):
              user = User(Fname,Lname,Email,Pass,Relationship,Sex,Bday,Route_visible,Pics_visible,User_ID)
              return user

      def Check_Name(self,user):
            manage = User_manager()
            return manage.Check_Name(user)

      def Check_Email(self,user):
            manage = User_manager()
            return manage.Check_Email(user)
      
      def register(self, user):
              manage = User_manager()
              output = manage.Register_user(user)
              
      def CheckUsername(self,user):
              return true
              
