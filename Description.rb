

module Description

  def descriptions(unlinked: false, shared: false, matching: false)
    shared ? shared_description(unlinked: unlinked, matching: matching) : unshared_description
  end

  def titles(shared: false)
    shared ? shared_title : unshared_title
  end

  def apartment_size
    [
      "#{bedrooms}b#{bedrooms}b",
      "#{bedrooms} bedroom #{bedrooms} bathroom",
      "#{sqft} sq/ft #{bedrooms}b#{bedrooms}b"
    ].sample
  end

  def adjusted_rent(shared: false)
    shared ? rent / max_tenants : rent
  end

  def formatted_rent(shared: false)
    number_with_commas = adjusted_rent(shared: shared).to_s.reverse
      .gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    "$#{number_with_commas}"
  end

  def contact(unlinked: false)
    unlinked ? "For more information or to start your own roommate match group, call/text at 310-694-4660" : "Sign up here: https://strathmore-roommate-match.herokuapp.com"
  end

  def date_available
    self.available = Date.today unless self.available > Date.today
    last_7_days = Date.new(available.year, available.month, -7)
    available < last_7_days ?
      Date::MONTHNAMES[(available + 8).month] :
      Date::MONTHNAMES[available.month]
  end

  def amenities
    building
      .amenities[0..rand(0..building.amenities.size)]
      .join('/')
  end

  def shared_cost
    (1...max_tenants)
      .map {|t| "#{t} roommates: $#{rent/(t+1)}"}
      .join(', ')
  end

  def distance_to_UCLA(unlinked: true)
    unlinked ? "Just a 10 minute stroll to campus." : "\nGoogle Maps: #{building.distance_to_UCLA}\n"
  end

  def roommate_match_group(group)
    sex_count = group[:people].each_with_object({}) do |person, hash|
      hash[person[:sex]] = (hash[person[:sex]] || 0) + 1
    end
    sex_count.map do |sex,count|
      pluralize = count > 1 ? "s" : ""
      "#{count} #{sex}#{pluralize}"
    end.join(' & ')
  end

  def roommate_reqests(group)
    options = (group[:roommate_high] - group[:roommate_low]) + 1
    people_count = group[:people].count
    (1..options).map do |n|
      "#{n} roommate#{n>1 ? 's' : ''} at $#{rent/(people_count + n)}/month"
    end.join(' or ')
  end

  def roommate_match_dates(group)
    move_in = Date.parse(group[:move_in_start].to_s).strftime("%b %e")
    move_out = Date.parse(group[:move_in_end].to_s).strftime("%b %e")
    "for move-in anytime between #{move_in} and #{move_out}"
  end

  def aggregate_roommate_requests(unlinked: false)
    if roommate_match.count > 1
      pluralize = 's'
      intro = "I have #{roommate_match.count} group#{pluralize} looking for roommates in a #{apartment_size}. details below:"
    else
      pluralize = ''
      intro = ''
    end

    intro = "ROOMMATE#{pluralize.upcase} WANTED: #{intro}\n"
    details = roommate_match.map do |group|
      # 2 males looking for 1 roommate for a 1 bedroom 1 bathroom apartment.
      "• #{roommate_match_group(group)} looking for #{roommate_reqests(group)} #{roommate_match_dates(group)}"
    end.join("\n") + "\n\n"
    amenities_list = "Amenities include #{amenities}\n\n"
    included_intro = roommate_match.count < (max_tenants - 1) ? intro : ""
    included_intro + details + amenities_list + contact(unlinked: unlinked)
  end

  def shared_description(unlinked: false, matching: false)
    if matching == true && roommate_match != nil && roommate_match.count > 0
      aggregate_roommate_requests(unlinked: unlinked)
    else
      [
        "**Roommate Match:** #{contact(unlinked: unlinked)}\n#{apartment_size} apartment, very close to #{building.close_to.join(', ')}. Available in #{date_available}. Whole apartment: $#{rent}, #{shared_cost}. Comes with #{amenities}",
        "#{apartment_size} apartment, #{lease} lease. Live affordably in a peaceful complex that won't get in the way of your studies/pursuits. Now accepting applications for our roommate match. ($#{rent/max_tenants}/month. #{contact(unlinked: unlinked)}). This is for sharing a #{bedrooms} bedroom apartment with #{max_tenants - 1} others. We will help you find roommates and apply for an apartment",
        "#{distance_to_UCLA(unlinked: unlinked)} This posting is for sharing a #{apartment_size} apartment. Comes with #{amenities}. Total rent cost is $#{rent}. If you are interested, sign up for the apartment roommate match. #{contact(unlinked: unlinked)}"
      ].sample
    end
  end

  def unshared_description(unlinked: true)
    # [
    #   "Currently taking applications for 1 Bedroom/Bathroom apartment close to UCLA (Strathmore/Veteran) Available December 5th. 10-minute stroll to UCLA, very close to Target/CVS/Whole Foods/Ralphs Comes with a parking spot Take the apartment for yourself for $2240 or sign up for our roommate match for an easy arrangement of a double ($1,120) or triple ($747). Has reserved parking/swimming pool/On-sight laundry facility",
    #   "Available December 5th! 1b1b apartment. Very close to UCLA. Get it all for yourself ($2240/month) or sign up for our roommate match. ($747/month. PM if you'd like to sign up).",
    #   "1b1b Apartment available December 5th. These units are very close to UCLA (11090 Strathmore Dr.) We are currently accepting applications for a unit that will be available starting December 5th. The whole unit is $2240/month but you are welcome to sign up for our roommate match so you can split the cost and save some dollars. PM or call with inquiries 310-694-4660",
    #   "Details:\n
    #   • Rent Total is $2240. Double: $1120, Triple: $747\n
    #   • We do roommate matching. Call/Text if interested 310-694-4660\n
    #   • 1 bedroom 1 bathroom apartment\n
    #   • 6-8 month lease\n
    #   • Close to UCLA (Strathmore Dr. / Veteran Ave.)\n
    #   • Available December 10th\n
    #   • Includes 1 parking spot\n
    #   • Utilities are separate\n
    #   • On-Sight Laundry Facility",
    #   "Get the best of both worlds at Strathmore Arms apartments, convenience and comfort. We are situated in Westwood, CA minutes away from UCLA, and nearby the I-405. All our apartments come equipped with central air and assigned parking.  There is also additional storage space to satisfy your storage needs. You can enjoy your day by the pool, or spend the day at Westwood Park, go shopping, eat at one of the many restaurants in the area, or take in a movie! At Strathmore Arms, you will find yourself surrounded by all the possibilities you've dreamed of. 11090 Strathmore Dr. Los Angeles, CA",
    #   "Strathmore Arms rests on the peaceful corner of Veteran and Strathmore. These unfurnished one bedroom apartments, complete with kitchen and common living space, provide a sweet repose from the daily demands of life. Strathmore Arms is a perfect union of minimalism and luxury, complete with laundry facility, swimming pool, and barbecue area while maintaining relative affordability for a property that is such short distance from UCLA campus. Call 310-694-4660 to schedule a tour of your future home or take a virtual tour by visiting rentstrathmore.com.",
    #   "This 1 bedroom 1 bathroom apartment is exceptionally close to UCLA buts maintains a peaceful atmosphere perfect for those who want to live close to the conveniences of Westwood Village but far from the chaos. The unit comes with a fully functioning kitchen, bathroom, and bedroom.Take a dip in the pool, grill on our community grill, or take your adventure out into Los Angeles with ease because of the free parking included with your unit!\nFeel free to check out more details at www.RentStrathmore.com or call the on-sight property manager",
    #   "Strathmore Arms is a great living environment just a few blocks from UCLA and exciting Westwood Village with upscale dining, shopping, and entertainment. Abundant with closets and cupboards, each one bedroom floor plan is uniquely appointed with 1950's architecture. Kitchens include gas stoves, refrigerators, and separate dining areas. Plush carpet and modern verticals are included throughout. Our cozy community has the feel of living on the periphery of a bustling Westwood Village with serene vibes; Strathmore Arms is a great place to live and commute. Call 310-694-4660 to schedule a tour of your future home or take a virtual tour by visiting rentstrathmore.com.",
    #   "Welcome to the apartment of your dreams, a real doers apartment complex that has all that you need and the space just for you. Get the best of both worlds at Strathmore Arms apartments, convenience and comfort. We are situated in Westwood, CA minutes away from UCLA, and nearby the I-405. All our apartments come equipped with central air and assigned parking.  There is also additional storage space to satisfy your storage needs. You can enjoy your day by the pool, or spend the day at Westwood Park, go shopping, eat at one of the many restaurants in the area, or take in a movie! At Strathmore Arms, you will find yourself surrounded by all the possibilities you've dreamed of."
    # ].sample
    [
      "#{apartment_size} apartment, very close to #{building.close_to.join(', ')}. Available in #{date_available}. Whole apartment: $#{rent}, #{shared_cost}. Comes with #{amenities}",
      "Lovely #{apartment_size} apartment, for a #{lease} lease. Entire apartment is $#{rent}. Comes with #{amenities} #{contact(unlinked: unlinked)}",
      "Serene apartment complex very close to UCLA. #{distance_to_UCLA(unlinked: unlinked)} This posting is for sharing a #{apartment_size} apartment. Comes with #{amenities}.\nIf you are interested, sign up for the apartment roommate match. #{contact(unlinked: unlinked)}",
      "#{apartment_size}:
        • Whole apartment: $#{rent}
        • #{shared_cost}
        • Available: #{date_available}
        • Amenities: #{amenities}
        • #{distance_to_UCLA(unlinked: unlinked)}
      "
    ].sample

  end

  def shared_title
    [
      "**RoommateMatch** Shared Room in #{apartment_size} UCLA",
      "WESTWOOD #{apartment_size} Shared Room. in  UCLA",
      "UCLA ROOMMATE MATCH: near #{building.close_to.join(', ')}",
      "ROOMMATE MATCH #{apartment_size} near #{building.close_to.join(', ')}",
      "#{apartment_size} Shared apartment near #{building.close_to.join(', ')}"
    ].sample
  end

  def unshared_title
    [
      "WESTWOOD: 1 bed/bath close to UCLA",
      "UCLA: 1 Bed/Bath near Westwood Village",
      "WESTWOOD/UCLA: 1 bed/bath near Campus/Westwood Village",
      "UCLA/WESTWOOD: One bedroom / one bathroom 6-8 month lease",
      "1 bedroom apartment, Westwood, Includes parking spot.",
      "1b1b Close to UCLA"
    ].sample
  end

end
