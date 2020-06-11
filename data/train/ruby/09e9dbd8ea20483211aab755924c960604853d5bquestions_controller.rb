class Manage::QuestionsController < Manage::BaseController
  inherit_resources
  defaults :route_prefix => 'manage'  
  belongs_to :structure, :finder => :find_by_permalink!
  
  before_filter :make_filter, :only => [:index]
  
  load_and_authorize_resource :question, :through => :structure
  
  def create
    create!{ manage_structure_questions_path(@structure.id) }
  end
  
  def update
    update!{ manage_structure_questions_path(@structure.id) }
  end
  
  def destroy
    destroy!{ manage_structure_questions_path(@structure.id) }
  end
  
  protected
    
    def begin_of_association_chain
      @structure
    end
    
    def collection
      @questions = (@questions || end_of_association_chain).merge(@search.scoped).page(params[:page])
    end
    
    def make_filter
      @search = Sunrise::ModelFilter.new(Question, :attributes => [:title])
      @search.update_attributes(params[:search])
    end
end
