module ApartmentRanking
  #apartments that reach certain criterian are weighted heavier than other apartments so they will be posted more often. criteria for weighting is in 
  def apartment_weighted_sample
    # original algorithm found below
    # https://gist.github.com/O-I/3e0654509dd8057b539a
    distribute_points.max_by { |_, weight| rand ** (1.0 / weight) }.first
  end

  def give_points
    points = apartments.map do |apartment|
      [
        true,
        apartment.roommate_groups.count > 0,
        apartment.roommate_groups.count > 0,
        apartment.roommate_groups.count > 0,
        apartment.roommate_groups.count > 0,
        apartment.roommate_groups.count > 1,
        apartment.roommate_groups.count > 2,
        apartment.available <= Date.today
      ].select{|trues| trues}.count
    end
    apartments.zip(points)
      .sort { |(k1,v1), (k2,v2)| v2 <=> v1 }.to_h
  end

  def distribute_points
    keys = give_points.keys 
    values = give_points.values
    sum = 0
    percentages = values.map do |n|
      if sum >= 10
        0
      elsif n >= 10
        sum += 10
        10
      elsif sum + n >= 10
        difference = (10.0 - sum) / 10
        sum += 10 - sum
        difference
      else
        sum += n
        n / 10.0
      end
    end
    keys.zip(percentages)
  end
end