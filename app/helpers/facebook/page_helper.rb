module Facebook::PageHelper

  def powered_by_moluko
    link_to 'Powered by Moluko', APP_CONFIG[:domain_name], :target => '_blank'
  end

end
