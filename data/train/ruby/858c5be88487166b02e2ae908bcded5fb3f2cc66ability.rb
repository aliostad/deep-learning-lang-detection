class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user.role == "Admin"
        
        if user.email == "visualboard@globalwayindonesia.com"
            #menu
            can :home, User
            can :visual_board, User

            can :manage, Home
            can :manage, Board 
            can :read, Ad


        elsif user.email == "machineproblem@globalwayindonesia.com"
            #menu
            can :home, User
            can :visual_problem, User

            can :manage, Home
            can :manage, Problem
        else
            #menu
            can :home, User
            can :visual_board, User
            can :visual_problem, User
            can :line, User
            can :masteremail, User
            can :running_text, User
            can :image, User

            can :manage, Home
            can :manage, Line #master LINE
            can :manage, User #master User/ pegawai
            can :manage, Board 
            can :manage, Problem
            can :manage, Masteremail
            can :data, Report do |report|
                report.line.user.role == "Admin"
            end
            can :manage, Ad
            can :manage, Image
            can :manage, Article
        end
            

    elsif user.role == "User"
        can :manage, Home
        #can :manage, Line #master 

        can :manage, Report do |report|
            if report.line != nil
                report.line.user.id == user.id
            else
                :all
            end
        end

        can :manage, Detailreport do |detailreport|
            detailreport.line.user.id == user.id
        end

        #menu
        can :update, User, :id => user.id

    end
  end
end
