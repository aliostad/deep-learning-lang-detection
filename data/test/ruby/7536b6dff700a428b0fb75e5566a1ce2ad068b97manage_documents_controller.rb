class Document::ManageDocumentsController < ApplicationController
  before_action :set_manage_document, only: [:edit, :update, :destroy]

  def index
    @manage_documents = paginated_records_for ManageDocument.includes(:document_category)
  end

  def new
    @manage_document = ManageDocument.new
  end

  def edit
    @documents = paginated_records_for @manage_document.documents.order("updated_at DESC")
  end

  def create
    @manage_document = ManageDocument.new(manage_document_params)

    respond_to do |format|
      if @manage_document.save
        format.html { redirect_to document_manage_documents_path(pagination_params), notice: t("model.create", kind: "Document") }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @manage_document.valid?
        @manage_document.publishes.destroy_all
        @manage_document.update(manage_document_params)
        format.html { redirect_to document_manage_documents_path(pagination_params), notice: t("model.update", kind: "Document") }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @manage_document.destroy
    respond_to do |format|
      format.html { redirect_to document_manage_documents_path(pagination_params), notice: t("model.destroy", kind: "Document") }
    end
  end

  private

  def set_manage_document
    @manage_document = ManageDocument.find(params[:id])
  end

  def manage_document_params
    params.require(:manage_document).permit(
        :topic, :description, :document_category_id, :published_at, publishes_attributes: [:id, :publish_to]
      )
  end

end
