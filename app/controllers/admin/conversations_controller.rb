class Admin::ConversationsController < Admin::BaseController
  helper :hot_glue
  include HotGlue::ControllerHelper

  
  
  before_action :load_conversation, only: [:show, :edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.format.symbol ==  :turbo_stream }
 
  def load_conversation
    @conversation = (Conversation.find(params[:id]))
  end
  

  def load_all_conversations(page = params[:page] || 1)
    @conversations = ( Conversation.page(page))
  end

  def index
    load_all_conversations
  end

  def new 
    @conversation = Conversation.new()
   
  end

  def create
    modified_params = modify_date_inputs_on_params(conversation_params.dup)


    @conversation = Conversation.create(modified_params)

    if @conversation.save
      flash[:notice] = "Successfully created #{@conversation.name}"


      @page = (Conversation.count() / Conversation.default_per_page)
      @page += 1 if (Conversation.count() % Conversation.default_per_page) > 0

      load_all_conversations(@page)
      render :create
    else
      flash[:alert] = "Oops, your conversation could not be created. #{@hawk_alarm}"
      render :create, status: :unprocessable_entity
    end
  end


  def edit
    render :edit
  end

  def update
    modified_params = modify_date_inputs_on_params(conversation_params)
      

    if @conversation.update(modified_params)
      
      flash[:notice] = (flash[:notice] || "") << "Saved #{@conversation.name}"
      flash[:alert] = @hawk_alarm if @hawk_alarm
      render :update
    else
      flash[:alert] = (flash[:alert] || "") << "Conversation could not be saved. #{@hawk_alarm}"
      render :update, status: :unprocessable_entity
    end
  end

  def destroy
    begin

      @conversation.destroy
    rescue StandardError => e
      flash[:alert] = "Conversation could not be deleted."
    end
    load_all_conversations
  end

  def conversation_params
    params.require(:conversation).permit( [:name] )
  end

  def namespace
    "admin/" 
  end
end


