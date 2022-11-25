class WelcomeController < ApplicationController
  def index
    @conversation = Conversation.first
  end
end
