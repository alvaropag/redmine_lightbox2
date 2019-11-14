module AttachmentsModelPatch
  require_dependency 'attachment'

  # Patches Redmine's Issues dynamically.  Adds a relationship
  # Issue +belongs_to+ to client

  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      #belongs_to :group_restrict, class_name: 'Group', foreign_key: :group_restrict_id
      safe_attributes 'restricted'

      before_create do
        self.restricted = User.current.allowed_to_globally?({:controller => :attachments, :action => :toggle_restricted})
      end

    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end
end


# Add module to Issue
Attachment.send(:include, AttachmentsModelPatch)
