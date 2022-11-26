class Admin::ConversationsController < Admin::BaseController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_conversation, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }
 
  def load_conversation
    @conversation = (Conversation.find(params[:id]))
  end
  

  def load_all_conversations 
    @conversations = ( Conversation.page(params[:page]))  
  end

  def index
    load_all_conversations
    respond_to do |format|
       format.html
    end
  end

  def new
    
    @conversation = Conversation.new()
   
    respond_to do |format|
      format.html
    end
  end

  def create
    modified_params = modify_date_inputs_on_params(conversation_params.dup)


    @conversation = Conversation.create(modified_params)

    if @conversation.save
      flash[:notice] = "Successfully created #{@conversation.name}"
      load_all_conversations
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to admin_conversations_path }
      end
    else
      flash[:alert] = "Oops, your conversation could not be created. #{@hawk_alarm}"
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    modified_params = modify_date_inputs_on_params(conversation_params)
      
 if @conversation.update(modified_params)
      flash[:notice] = (flash[:notice] || "") << "Saved #{@conversation.name}"
      flash[:alert] = @hawk_alarm if @hawk_alarm
    else
      flash[:alert] = (flash[:alert] || "") << "Conversation could not be saved. #{@hawk_alarm}"

    end

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def destroy
    begin
      @conversation.destroy
    rescue StandardError => e
      flash[:alert] = "Conversation could not be deleted."
    end
    load_all_conversations
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_conversations_path }
    end
  end

  def conversation_params
    params.require(:conversation).permit( [:name] )
  end

  def namespace
    "admin/" 
  end
end


