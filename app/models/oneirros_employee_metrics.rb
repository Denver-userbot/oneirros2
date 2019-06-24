class OneirrosEmployeeMetrics < Influxer::Metrics
  set_series :employees

  scope :by_employee, -> (id) { where (rivals_user_id: id) }
  scope :by_factory, -> (id) { where (rivals_factory_id: id) }
  scope :by_company, -> (id) { where (oneirros_company_id: id) }
  scope :by_resource, -> (id) { where (rivals_resource_id: id) }

  tags :rivals_user_id
  tags :rivals_factory_id
  tags :oneirros_company_id

  attributes :energy, :efficiency_now, :efficiency_total
end
