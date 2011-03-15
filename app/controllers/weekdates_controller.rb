class WeekdatesController < ApplicationController
  # GET /weekdates
  # GET /weekdates.xml
  def index
    @weekdates = Weekdate.order("qmw").page(params[:page]).per(13)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @weekdates }
    end
  end

  # GET /weekdates/1
  # GET /weekdates/1.xml
  def show
    @weekdate = Weekdate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @weekdate }
    end
  end

  # GET /weekdates/new
  # GET /weekdates/new.xml
  def new
    @weekdate = Weekdate.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @weekdate }
    end
  end

  # GET /weekdates/1/edit
  def edit
    @weekdate = Weekdate.find(params[:id])
  end

  # POST /weekdates
  # POST /weekdates.xml
  def create
    @weekdate = Weekdate.new(params[:weekdate])

    respond_to do |format|
      if @weekdate.save
        format.html { redirect_to(@weekdate, :notice => 'Weekdate was successfully created.') }
        format.xml  { render :xml => @weekdate, :status => :created, :location => @weekdate }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @weekdate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /weekdates/1
  # PUT /weekdates/1.xml
  def update
    @weekdate = Weekdate.find(params[:id])

    respond_to do |format|
      if @weekdate.update_attributes(params[:weekdate])
        format.html { redirect_to(@weekdate, :notice => 'Weekdate was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @weekdate.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /weekdates/1
  # DELETE /weekdates/1.xml
  def destroy
    @weekdate = Weekdate.find(params[:id])
    @weekdate.destroy

    respond_to do |format|
      format.html { redirect_to(weekdates_url) }
      format.xml  { head :ok }
    end
  end
end
