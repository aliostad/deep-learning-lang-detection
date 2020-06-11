authorization do

  role :admin do
    has_omnipotence
    has_permission_on :authorization_rules, :to => :read
    has_permission_on [:home],  :to => [:index, :hr, :timetable, :settings]
    has_permission_on [:students],  :to => [:manage, :image]
    has_permission_on [:evaluation_structures],  :to => :manage
    has_permission_on [:periods],  :to => :manage
    has_permission_on [:schedules],  :to => :manage
    has_permission_on [:class_timings],  :to => :manage
    has_permission_on [:relationships],  :to => :manage
    has_permission_on [:employees],  :to => [:manage, :assign_subjects, :save_subjects]
    has_permission_on [:courses],  :to => :manage
    has_permission_on [:subjects],  :to => :manage
    has_permission_on [:batches],  :to => :manage
    has_permission_on [:batch_subjects],  :to => :manage
    has_permission_on [:evaluations],  :to => [:manage, :assign_grades, :save_grades]
    has_permission_on [:timetable_entries],  :to => [:manage, :assign_employee, :save_employee]
    has_permission_on [:batches],  :to => :manage
  end

  role :student do
    has_permission_on [:home],  :to => [:index]
  
    has_permission_on :students, :to=> [:show, :academic_status, :schedule, :final_grades] do 
      if_attribute :id => is {user.authenticatable.id}
    end
     has_permission_on :batches, :to => :read do 
        if_attribute :students => contains {user.authenticatable}
      end
    has_permission_on :relationships, :to => :index do 
      if_attribute :student => is {user.authenticatable}
    end
    has_permission_on :batch_subjects, :to => :read do 
         if_permitted_to :read, :batch
      end
    has_permission_on :evaluations, :to => :read do 
      if_attribute :students => contains {user.authenticatable}
    end
   
  end

end

privileges do 
  privilege :manage do
    includes :read, :create,:update,:delete
  end
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end

