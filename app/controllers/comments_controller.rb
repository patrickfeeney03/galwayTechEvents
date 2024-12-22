class CommentsController < ApplicationController
  before_action :set_event

  # GET /comments or /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    # logger.warn(params[:id])
    @event = Event.find(params[:event_id])
    @comment = Comment.find(params[:id])
  end

  # POST /comments or /comments.json
  def create
    comments = @event.comments
    user = User.find(session[:user_id])
    form_parameter = params.expect(comment: [:body])
    comment_to_save = comments.new(form_parameter)
    comment_to_save[:author] = user.name
    comment_to_save[:user_id] = user.id
    # Something to remember... I was using comment.create
    # but .create always returns the comment object even
    # if it fails to save lol. So the if statement was always
    # evaluating to true...
    if comment_to_save.save
      redirect_to @event
    else
      redirect_to @event, alert: "There was an error trying to save your comment:
                                  #{comment_to_save.errors.full_messages.to_sentence}.
                                  Please Sign Out and Sign Back In."
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to comments_path, status: :see_other, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.expect(comment: [:author, :body])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end
end
