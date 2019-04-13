class RivalRegionMetricsSerializer < ActiveModel::Serializer 
  attributes :hospital, :military_base, :school, :citizens, :residents, :initial_atk, :initial_def, :missile, :port, :power_plant, :spaceport, :airport, :housing_fund, :gold_now, :oil_now, :ore_now, :ura_now, :dia_now, :gold_base, :oil_base, :ore_base, :ura_base, :dia_base, :gold_max, :oil_max, :ore_max, :ura_max, :dia_max, :edu_index, :mil_index, :med_index, :dev_index
end
