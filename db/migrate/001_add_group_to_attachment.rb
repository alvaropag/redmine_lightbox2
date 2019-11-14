class AddGroupToAttachment < ActiveRecord::Migration[4.2]
  def change
    #add_reference :attachments, :group_restrict, references: :groups, index: true
    #add_foreign_key :attachments, :group, column: :group_restrict_id
    add_column :attachments, :restricted, :boolean, default: false
  end
end
