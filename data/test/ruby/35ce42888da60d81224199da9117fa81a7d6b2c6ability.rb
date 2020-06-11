class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
      user ||= User.new
      if user
       if user.has_role? :admin
        can :manage, :all
      elsif user.has_role? :jefe
        can :manage, [Evaluacion] if user.is? :jefe
      elsif user.has_role? :aprendiz
        can :manage, [Estudiante, Bitacora, Actividad, AsignarProy, User]
      elsif user.has_role? :directivo
        can :manage, [Estudiante, Empresa, Evaluacion, User, Jefe]
     elsif user.has_role? :monitor
        can :manage, :all
      end
    end
  end
end


   
 

