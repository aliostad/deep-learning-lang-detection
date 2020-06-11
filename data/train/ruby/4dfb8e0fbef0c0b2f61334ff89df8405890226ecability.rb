class Ability
  include CanCan::Ability

  def initialize(user)
     
        if user.role == "Admin"

        	can :manage, Home
          #can :manage, User
          can :create, User
          can :read, User
          can :update, User
          can :destroy, User
          

        elsif user.role == "Kepala Kantor"

          can :manage, Home
          can :manage, Report, :user_id => user.id
          can :report, User
          can :penilaian, User
          can :task, User

          #nilai task Kepala Seksi
          can :manage, Task do |task|
            task.user.role == "Kepala Seksi"
          end

          can :manage, Detailtask do |detailtask|
            detailtask.task.user.role == "Kepala Seksi"
          end

          can :manage, Penilaian do |penilaian|
            penilaian.task.user.role == "Kepala Seksi"
          end

        elsif user.role == "Kepala Seksi"

          can :manage, Home
          can :manage, Report, :user_id => user.id
          can :report, User
          can :penilaian, User
          can :task, User
          can :manage, Task, :user_id => user.id


          #nilai task Kepala Sub Seksi
          can :manage, Task do |task|
            task.user.role == "Kepala Sub Seksi"
          end

          can :manage, Detailtask do |detailtask|
            detailtask.task.user.role == "Kepala Sub Seksi"
          end

          can :manage, Penilaian do |penilaian|
            penilaian.task.user.role == "Kepala Sub Seksi"
          end

        elsif user.role == "Kepala Sub Seksi"

          can :manage, Home
          can :manage, Report, :user_id => user.id
          can :report, User
          can :penilaian, User
          can :task, User
          can :manage, Task, :user_id => user.id


          #nilai task Pelaksana only
          can :manage, Task do |task|
            task.user.role == "Pelaksana"
          end

          can :manage, Detailtask do |detailtask|
            detailtask.task.user.role == "Pelaksana"
          end

          can :manage, Penilaian do |penilaian|
            penilaian.task.user.role == "Pelaksana"
          end
          

        elsif user.role == "Pelaksana"

        	can :manage, Home
          can :manage, Report, :user_id => user.id
          can :report, User
          can :task, User
        	can :manage, Task, :user_id => user.id

        end
  end
end
