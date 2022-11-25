class Conversation < ApplicationRecord

  include ActionView::RecordIdentifier

  after_update_commit lambda {
    broadcast_replace_to self, target: "#{dom_id(self)}", partial: "welcome/conversation"
  }
end
