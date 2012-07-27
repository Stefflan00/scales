class TracksController < ApplicationController
  # GET /tracks
  # GET /tracks.json
  def index
    @tracks = Track.all

    html = respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
    Scales.push :json => @tracks.to_json, :to => "/tracks.json"
    Scales.push :html => html,            :to => "/tracks"
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])

    html = respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
    Scales.push :json => @track.to_json,  :to => "/tracks/#{@track.id}.json"
    Scales.push :html => html,            :to => "/tracks/#{@track.id}"
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new

    html = respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
    Scales.push :html => html, :to => "/tracks/new"
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
    Scales.push :html => render, :to => "/tracks/#{@track.id}/edit"
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])

    respond_to do |format|
      if @track.save
        Scales.update "/tracks/#{@track.id}", "/tracks/#{@track.id}/edit", "/tracks", :format => :html
        format.html { redirect_to @track, notice: 'Track was successfully created.' }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])

    respond_to do |format|
      if @track.update_attributes(params[:track])
        Scales.update "/tracks/#{@track.id}", "/tracks/#{@track.id}/edit", "/tracks", :format => :html
        format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    
    Scales.destroy "/tracks/#{@track.id}", "/tracks/#{@track.id}.json", "/tracks/#{@track.id}/edit"
    Scales.update "/tracks", :format => :html
    
    respond_to do |format|
      format.html { redirect_to tracks_url }
      format.json { head :no_content }
    end
  end
end