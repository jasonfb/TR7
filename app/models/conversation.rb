class Conversation < ApplicationRecord

  include ActionView::RecordIdentifier

  # after_update_commit lambda {
  #   broadcast_replace_to self, target: "welcome__conversation__#{dom_id(self)}", partial: "welcome/conversation"
  # }

  after_update_commit lambda {
    broadcast_replace_to self, target: "admin__#{dom_id(self)}", partial: "admin/conversations/line"
  }

  after_destroy_commit lambda {
    broadcast_remove_to self, target: "admin__#{dom_id(self)}"

  }
end
