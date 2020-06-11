class RankProject

  attr_accessor :user
  attr_accessor :score
  attr_accessor :project

  CATEGORY_WEIGHT = 30
  SUBCATEGORY_WEIGHT = 20
  LOCATION_WEIGHT = 10
  STAGE_WEIGHT = 5
  TECH_WEIGHT = 10
  AFFILIATION_WEIGHT = 10

  def initialize(project, user)
    @project = project
    @user = user
    @prefs = @user.project_preferences
    @project.score = 0.0
    @score = 0.0
    @total_score = 0.0
    calculate_project_score
  end

  def calculate_project_score
    calculate_category_relevance
    calculate_subcategory_relevance
    calculate_location_relevance
    calculate_stage_relevance
    calculate_tech_relevance
    calculate_affiliation_relevance

    p "#{@project.name} : #{@score}"
    @project.score = @score / @total_score
    p "#{@project.name} : #{@project.score}"
    @project
  end

  def calculate_category_relevance
    if @prefs[:categories] && @prefs[:categories].include?(@project.category)
      @score += CATEGORY_WEIGHT
    end

    @total_score += CATEGORY_WEIGHT
  end

  def calculate_subcategory_relevance
    matches = (@prefs[:subcategories] & @project.subcats) || []
    if matches.length > 0
      p "IM INSIDE SUBCAT PROJECT RANK"
      @score += SUBCATEGORY_WEIGHT
    end

    @total_score += SUBCATEGORY_WEIGHT
  end


  def calculate_location_relevance
    if @prefs[:locations] && @prefs[:locations].include?(@project.location)
      @score += LOCATION_WEIGHT
    end

    @total_score += LOCATION_WEIGHT
  end  

  def calculate_stage_relevance
    if @prefs[:stages] && @prefs[:stages].include?(@project.stage)
      @score += STAGE_WEIGHT
    end

    @total_score += STAGE_WEIGHT
  end    

  def calculate_tech_relevance
    matches = (@prefs[:technologies] & @project.technologies) || []
    if (@prefs[:technologies] & @project.technologies)
      @score += TECH_WEIGHT if matches.length > 0
    end

    @total_score += TECH_WEIGHT
  end

  def calculate_affiliation_relevance
    matches = (@prefs[:affiliations] & @project.affiliations) || []
    if (@prefs[:affiliations] & @project.affiliations)
      @score += AFFILIATION_WEIGHT if matches.length > 0
    end

    @total_score += AFFILIATION_WEIGHT
  end         

end






