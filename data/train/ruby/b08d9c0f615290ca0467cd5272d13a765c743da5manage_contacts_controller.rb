class ManageContactsController < ApplicationController
  # GET /manage_contacts
  # GET /manage_contacts.json
  def index
    @manage_contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manage_contacts }
    end
  end

  # GET /manage_contacts/1
  # GET /manage_contacts/1.json
  def show
    @manage_contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manage_contact }
    end
  end

  # GET /manage_contacts/new
  # GET /manage_contacts/new.json
  def new
    @manage_contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manage_contact }
    end
  end

  # GET /manage_contacts/1/edit
  def edit
    @manage_contact = Contact.find(params[:id])
  end

  # POST /manage_contacts
  # POST /manage_contacts.json
  def create
    @manage_contact = Contact.new(params[:manage_contact])

    respond_to do |format|
      if @manage_contact.save
        format.html { redirect_to @manage_contact, notice: 'Manage contact was successfully created.' }
        format.json { render json: @manage_contact, status: :created, location: @manage_contact }
      else
        format.html { render action: "new" }
        format.json { render json: @manage_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manage_contacts/1
  # PUT /manage_contacts/1.json
  def update
    @manage_contact = Contact.find(params[:id])

    @manage_contact.update_attributes(params[:contact])

    respond_to do |format|
      if @manage_contact.update_attributes(params[:contact])
        format.html { redirect_to manage_contacts_url, notice: 'Manage contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manage_contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manage_contacts/1
  # DELETE /manage_contacts/1.json
  def destroy
    @manage_contact = Contact.find(params[:id])
    @manage_contact.destroy

    respond_to do |format|
      format.html { redirect_to manage_contacts_url }
      format.json { head :no_content }
    end
  end
end
