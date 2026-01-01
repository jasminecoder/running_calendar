module ApplicationHelper
  # Format race cost for display
  # Returns "Gratis" for free races, "$X MXN" for paid races
  def format_race_cost(cost)
    if cost.nil? || cost.zero?
      "Gratis"
    else
      "$#{cost.to_i} MXN"
    end
  end
end
