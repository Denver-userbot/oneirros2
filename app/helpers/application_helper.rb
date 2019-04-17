module ApplicationHelper
  # Slow due to instanciating a new engine. Care !
  def render_haml(template, locals = {})
    engine = Haml::Engine.new(template.gsub(/^#{template[/^\s+/]}/, ''))
    engine.render(self, locals)
  end

  def get_human_cash(value)
    return "<strong>#{'%.2f' % (value / 1000000000000)} T$</strong>"
  end
  def get_human_gold(value)
    return "<strong class='uk-text-warning'>#{'%.2f' % (value / 1000000000000)} TG</strong>"
  end
  def get_human_oil(value)
    return "<strong class='uk-text-emphasis'>#{'%.2f' % (value / 1000000000)} KKK bbl</strong>"
  end
  def get_human_ore(value)
    return "<strong class='uk-text-danger'>#{'%.2f' % (value / 1000000000)} KKK kg</strong>"
  end
  def get_human_ura(value)
    return "<strong class='uk-text-success'>#{'%.2f' % (value / 1000000)} KK g</strong>"
  end
  def get_human_dia(value)
    return "<strong class='uk-text-primary'>#{'%.2f' % (value / 1000)} K pcs.</strong>"
  end

  def map_res_name_to_readable_name(str)
    return "Diamonds" unless str != "dia"
    return "Uranium" unless str != "ura" 
    return map_attribute_to_readable_name(str)
  end

  def map_attribute_to_readable_name(str)
    return str.capitalize.tr('_', ' ')
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
