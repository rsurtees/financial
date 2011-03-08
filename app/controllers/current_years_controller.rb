class CurrentYearsController < ApplicationController
  # GET /current_years
  # GET /current_years.xml
  def index
    @current_years = CurrentYear.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @current_years }
    end
  end

  # GET /current_years/1
  # GET /current_years/1.xml
  def show
    @current_year = CurrentYear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @current_year }
    end
  end

  # GET /current_years/new
  # GET /current_years/new.xml
  def new
    @current_year = CurrentYear.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @current_year }
    end
  end

  # GET /current_years/1/edit
  def edit
    @current_year = CurrentYear.find(params[:id])
  end

  # POST /current_years
  # POST /current_years.xml
  def create
    @current_year = CurrentYear.new(params[:current_year])

    respond_to do |format|
      if @current_year.save
        format.html { redirect_to(@current_year, :notice => 'Current year was successfully created.') }
        format.xml  { render :xml => @current_year, :status => :created, :location => @current_year }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @current_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /current_years/1
  # PUT /current_years/1.xml
  def update
    @current_year = CurrentYear.find(params[:id])

    respond_to do |format|
      if @current_year.update_attributes(params[:current_year])
        format.html { redirect_to(@current_year, :notice => 'Current year was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @current_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /current_years/1
  # DELETE /current_years/1.xml
  def destroy
    @current_year = CurrentYear.find(params[:id])
    @current_year.destroy

    respond_to do |format|
      format.html { redirect_to(current_years_url) }
      format.xml  { head :ok }
    end
  end
end
