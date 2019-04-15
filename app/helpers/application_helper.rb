module ApplicationHelper
  # Slow due to instanciating a new engine. Care !
  def render_haml(template, locals = {})
    engine = Haml::Engine.new(template.gsub(/^#{template[/^\s+/]}/, ''))
    engine.render(self, locals)
  end

  def get_med_index_class(value)
     return case
       when value >= 8 then "uk-text-success"
       when value >= 6 then "uk-text-warning"
       when true then "uk-text-danger"
     end
  end
  def get_mil_index_class(value)
     return case
       when value >= 6 then "uk-text-success"
       when value >= 4 then "uk-text-warning"
       when true then "uk-text-danger"
     end
  end
  def get_edu_index_class(value)
     return case
       when value >= 8 then "uk-text-success"
       when value >= 6 then "uk-text-warning"
       when true then "uk-text-danger"
     end
  end
  def get_dev_index_class(value)
     return case
       when value >= 6 then "uk-text-success"
       when value >= 2 then "uk-text-warning"
       when true then "uk-text-danger"
     end
  end
end
