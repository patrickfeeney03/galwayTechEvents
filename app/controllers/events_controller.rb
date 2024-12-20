class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :check_ownership, only: %i[ edit destroy update ]

  # GET /events or /events.json
  def index
    user_id = session[:user_id]
    @events = Event.where(user_id: user_id).or(Event.where(visibility: "Public"))
    @user = User.find(user_id)
  end

  # GET /events/1 or /events/1.json
  def show
    user_id = session[:user_id]
    # Check if it should be accessible for User
    unless @event.user_id == user_id || @event.visibility == "Public"
      redirect_to events_path
    end
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.user_id = session[:user_id]

    unless event_params[:image].nil?
      logger.info "The uploaded image has a size of #{(event_params[:image].size.to_f / 1.megabyte).round(2)}MB"
      image_size_mb = (event_params[:image].size.to_f / 1.megabyte).round(2)
      maximum_size_mb = 1.5
      if image_size_mb > maximum_size_mb
        logger.warn "Image Too big"
        redirect_to new_event_path, notice: "The file size is too big. Maximum size #{maximum_size_mb}MB"
        return
      else
        logger.info "Image Accepted. Image size #{image_size_mb}, maximum size #{maximum_size_mb}"
      end
    end

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to events_path, status: :see_other, notice: "Event was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params.expect(:id))
  end

  def check_ownership
    user_id = session[:user_id]
    unless @event.user_id == user_id
      redirect_to @event
    end
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.expect(event: [:title, :body, :date, :location, :image, :visibility])
  end
end
