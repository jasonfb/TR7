class Conversation < ApplicationRecord

  include ActionView::RecordIdentifier

  after_update_commit lambda {
    broadcast_replace_to self, target: "#{dom_id(self)}", partial: "welcome/conversation"
  }

  after_update_commit lambda {
    broadcast_replace_to self, target: "conversation__#{self.id}", partial: "admin/conversations/line"
  }

end
