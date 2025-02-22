require_dependency 'attachment'
module RedmineLightbox2
  module AttachmentsPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        def download_inline
          # apply before_filters
          find_attachment
          file_readable
          read_authorize

          send_file @attachment.diskfile, :filename => filename_for_content_disposition(@attachment.filename),
                    :type => detect_content_type(@attachment),
                    :disposition => 'inline'
        end

        def toggle_restricted
          @attachment = Attachment.find(params[:id])
          @attachment.toggle(:restricted)
          @attachment.save
        end

        def read_authorize
          (@attachment.visible?) and (!@attachment.restricted or (@attachment.restricted and User.current.allowed_to_globally?({:controller => :attachments, :action => :toggle_restricted}))) ? true : deny_access
        end
      end
    end
  end
end