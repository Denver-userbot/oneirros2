require 'pp'

module RegionCostHelper
 EMPIRICAL_FACTORS = {
   # Cash Gold Oil Ore Diamond Uranium
   "hospital" =>         [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "military_base" =>    [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "school" =>           [ 2078.4, 40155.5, 809.6,  341.6,  0.0,     0.0 ],
   "missile" =>          [ 12649.2, 965.74, 12.649, 12.649, 0.01173, 0.0 ],
   "port"    =>          [ 12649.2, 965.74, 12.649, 12.649, 0.01173, 0.0 ],
   "airport" =>          [ 12649.2, 965.74, 12.649, 12.649, 0.01173, 0.0 ],
   "power_plant" =>      [ 35768.2, 341.44, 49.99,  49.99,  0.00722, 35.768 ],
   "spaceport" =>        [ 185857,  965.74, 65.710, 49.99,  0.01173, 65.710 ],
   "housing_fund" =>     [ 65.72,  1269.78, 25.600, 10.800, 0.0,     0.0 ]
 }   
 
 def compute_all_loot(region_metrics_hash)
   total = Hash.new
   total["cash"] = 0.0
   total["gold"] = 0.0
   total["oil"] = 0.0
   total["ore"] = 0.0
   total["dia"] = 0.0
   total["ura"] = 0.0

   ["hospital", "military_base", "school", "missile", "port", "airport", "power_plant", "spaceport"].each do |building|
     remaining = (region_metrics_hash[building] / 2).to_i   # Only half is looted
     cost = compute_cost(building, region_metrics_hash[building], remaining)
     total.keys.each do |resource|
       total[resource] += cost[resource] / 2    # Half lost in looting
     end
   end

   return total
 end
 
 def compute_all_cost(region_metrics_hash)
   total = Hash.new
   total["cash"] = 0.0
   total["gold"] = 0.0
   total["oil"] = 0.0
   total["ore"] = 0.0
   total["dia"] = 0.0
   total["ura"] = 0.0

   ["hospital", "military_base", "school", "missile", "port", "airport", "power_plant", "spaceport", "housing_fund"].each do |building|
     cost = compute_cost(building, region_metrics_hash[building])
     total.keys.each do |resource|
       total[resource] += cost[resource]
     end
   end

   return total
 end

 def compute_cost(type, level, starting_level = 0) 
   return {
     "cash" => compute_cost_primitive(type, 0, level) - compute_cost_primitive(type, 0, starting_level),
     "gold" => compute_cost_primitive(type, 1, level) - compute_cost_primitive(type, 1, starting_level),
     "oil"  => compute_cost_primitive(type, 2, level) - compute_cost_primitive(type, 2, starting_level),
     "ore"  => compute_cost_primitive(type, 3, level) - compute_cost_primitive(type, 3, starting_level),
     "dia"  => compute_cost_primitive(type, 4, level) - compute_cost_primitive(type, 4, starting_level),
     "ura"  => compute_cost_primitive(type, 5, level) - compute_cost_primitive(type, 5, starting_level)
   } 
 end

 def compute_cost_primitive(type, resource_idx, level)
   return 0 unless level > 0
   return EMPIRICAL_FACTORS[type][resource_idx] * (1.5 + level.to_f) * (level.to_f ** 1.5)
 end
end
