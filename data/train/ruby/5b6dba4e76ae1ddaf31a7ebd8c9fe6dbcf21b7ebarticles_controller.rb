class Manage::ArticlesController < Manage::ApplicationController
  def new
    @issue = Issue.find(params[:issue_id])
    add_breadcrumb "Список выпусков", manage_issue_path(@issue)
    add_breadcrumb "Новая статья", new_manage_issue_article_path(@issue)
    @article = Article.new
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @article = @issue.articles.create(article_params)
    respond_with :manage, @issue, @article, location: -> { manage_issue_path(@issue) }
  end

  def edit
    @issue = Issue.find(params[:issue_id])
    @article = Article.find(params[:id])
    add_breadcrumb "Список выпусков", manage_issue_path(@issue)
    add_breadcrumb "Редактировать статью", edit_manage_issue_article_path(@issue, @article)
  end

  def update
    @issue = Issue.find(params[:issue_id])
    @article = Article.find(params[:id])
    @article.update(article_params)
    respond_with :manage, @issue, @article, location: -> { manage_issue_path(@issue) }
  end

  def destroy
    Article.find(params[:id]).destroy
    redirect_to manage_issue_path(Issue.find(params[:issue_id]))
  end

  private
    def article_params
      params.require(:article).permit(:title, :article_type, :annotation, :content)
    end
end
