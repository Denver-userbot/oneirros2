module RegionCostHelper
 REGION_COST_EMPIRICAL_FACTORS = {
   # Cash Gold Oil Ore Diamond Uranium Scale Factor
   "hospital" =>         [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "military_base" =>    [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "school" =>           [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "missile" =>          [ 12649.2, 965.74, 12.649, 12.649, 2.9477,  0.0 ],
   "port"    =>          [ 12649.2, 965.74, 12.649, 12.649, 2.9477,  0.0 ],
   "airport" =>          [ 12649.2, 965.74, 12.649, 12.649, 2.9477,  0.0 ],
   "power_plant" =>      [ 35768.2, 341.44, 49.99,  49.99,  1.1815,  35.768 ],
   "spaceport" =>        [ 185857,  965.74, 65.710, 49.99,  2.9477,  65.710 ],
   "housing_fund" =>     [ 65.72,  1269.78, 25.600, 10.800, 0.0,     0.0 ]
 }

 REGION_COST_BUILDING_LIST = ["hospital", "military_base", "school", "missile", "port", "airport", "power_plant", "spaceport", "housing_fund"]
 REGION_COST_RESOURCES = ["state_cash", "state_gold", "oil", "ore", "dia", "ura"]  
 
 def compute_all_loot(region_metrics_hash)
   total = Hash.new
   REGION_COST_RESOURCES.each do |res|
      total[res] = 0.0
   end

   # Housing Fund not looted
   ["hospital", "military_base", "school", "missile", "port", "airport", "power_plant", "spaceport"].each do |building|
     remaining = (region_metrics_hash[building] / 2).to_i   # Only half is looted
     cost = compute_cost(building, region_metrics_hash[building], remaining)
     total.keys.each do |resource|
       total[resource] += cost[resource] / 2    # Half lost in looting
     end
   end

   return total
 end

 def sum_costs(cost_array) 
   total = Hash.new
   REGION_COST_RESOURCES.each do |res|
      total[res] = 0.0
   end
   
   cost_array.each do |batch|
     REGION_COST_RESOURCES.each do |res|
       total[res] += batch[res]
     end
   end
  
   return total
 end
 
 def compute_all_cost(region_metrics_hash)
   total = Hash.new
   REGION_COST_RESOURCES.each do |res|
      total[res] = 0.0
   end

   REGION_COST_BUILDING_LIST.each do |building|
     cost = compute_cost(building, region_metrics_hash[building])
     REGION_COST_RESOURCES.each do |resource|
       total[resource] += cost[resource]
     end
   end

   return total
 end

 def compute_cost(type, level, starting_level = 0) 
   return {
     "state_cash" => compute_cost_primitive(type, 0, level) - compute_cost_primitive(type, 0, starting_level),
     "state_gold" => compute_cost_primitive(type, 1, level) - compute_cost_primitive(type, 1, starting_level),
     "oil"  => compute_cost_primitive(type, 2, level) - compute_cost_primitive(type, 2, starting_level),
     "ore"  => compute_cost_primitive(type, 3, level) - compute_cost_primitive(type, 3, starting_level),
     "dia"  => compute_cost_primitive(type, 4, level) - compute_cost_primitive(type, 4, starting_level),
     "ura"  => compute_cost_primitive(type, 5, level) - compute_cost_primitive(type, 5, starting_level)
   } 
 end

 def compute_cost_primitive(type, resource_idx, level)
   return 0 unless level > 0
   return REGION_COST_EMPIRICAL_FACTORS[type][resource_idx] * (1.5 + level.to_f) * (level.to_f ** 1.5) unless resource_idx == 4
   # Different formulae for diamonds
   return REGION_COST_EMPIRICAL_FACTORS[type][resource_idx] * (1.5 + level.to_f) * (level.to_f ** 0.702)
 end
end
