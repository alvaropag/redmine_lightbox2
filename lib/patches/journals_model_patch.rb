module JournalsModelPatch


  #Nova versao de visible details, filtrando o que é visível para o usuário
  def visible_details(user=User.current)
    details.select do |detail|
      if detail.property == 'attachment'
        att = Attachment.find(detail.prop_key)
        !att.restricted or (att.restricted and User.current.allowed_to_globally?({:controller => :attachments, :action => :toggle_restricted}))
      elsif detail.property == 'cf'
        detail.custom_field && detail.custom_field.visible_by?(project, user)
      elsif detail.property == 'relation'
        Issue.find_by_id(detail.value || detail.old_value).try(:visible?, user)
      else
        true
      end
    end
  end
end

Journal.prepend(JournalsModelPatch)
