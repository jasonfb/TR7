require 'rails_helper'

describe "interaction for Admin::ConversationsController", type: :feature do
  include HotGlue::ControllerHelper
    #HOTGLUE-SAVESTART
  #HOTGLUE-END
  

  let!(:conversation1) {create(:conversation , name: FFaker::Movie.title )}
     

  describe "index" do
    it "should show me the list" do
      visit admin_conversations_path
      expect(page).to have_content(conversation1.name)
    end
  end

  describe "new & create" do
    it "should create a new Conversation" do
      visit admin_conversations_path
      click_link "New CONVERSATION"
      expect(page).to have_selector(:xpath, './/h3[contains(., "New CONVERSATION")]')
      new_name = 'new_test-email@nowhere.com' 
      find("[name='conversation[name]']").fill_in(with: new_name)
      click_button "Save"
      expect(page).to have_content("Successfully created")
      expect(page).to have_content(new_name)
    end
  end


  describe "edit & update" do
    it "should return an editable form" do
      visit admin_conversations_path
      find("a.edit-conversation-button[href='/admin/conversations/#{conversation1.id}/edit']").click

      expect(page).to have_content("Editing #{conversation1.name.squish || "(no name)"}")
      new_name = 'new_test-email@nowhere.com' 
      find("[name='conversation[name]']").fill_in(with: new_name)
      click_button "Save"
      within("turbo-frame#conversation__#{conversation1.id} ") do
        expect(page).to have_content(new_name)
      end
    end
  end 

  describe "destroy" do
    it "should destroy" do
      visit admin_conversations_path
      accept_alert do
        find("form[action='/admin/conversations/#{conversation1.id}'] > input.delete-conversation-button").click
      end
      expect(page).to_not have_content(conversation1.name)
      expect(Conversation.where(id: conversation1.id).count).to eq(0)
    end
  end
end

