# require_relative 'Post'

module Description

  def descriptions
    {
      shared: shared_description,
      unshared: unshared_description
    }
  end

  def titles
    {
      shared: shared_title,
      unshared: unshared_title
    }
  end

  def shared_description
    [
      "**Roommate Match:** Sign up here: https://strathmore-roommate-match.herokuapp.com\n1b1b Apartment very close to UCLA. Available December/January. Single: $2240, Double: $1120, triple: $750. Comes with parking/pool/on-sight laundry.",
      "1b1b apartment 6-8 month lease. Live affordably in a peaceful complex that won't get in the way of your studies/pursuits. Now accepting applications for Strathmore Arms Roommate Match. ($747/month. PM if you'd like to sign up). This is for sharing a 1 bedroom apartment with two others. We're interested in simplifying the housing search as much as possible, so we match roommates by setting up conference calls every weekend so folks can get to know one another's lifestyles/schedules/cleanliness, etc. After that, we can help all of those who are interested in the application process.",
      "Peaceful apartment complex very close to UCLA\nGoogle Maps: https://goo.gl/maps/QpGkpdjgNG2NsDgm7\n\nThis posting is for sharing a 1b1b apartment. Each apartment comes un has a bedroom/bathroom/living room/kitchen. Comes with a parking spot.\nIf you are intersted, sign up for the apartment roommate match at https://strathmore-roommate-match.herokuapp.com/"
    ].sample
  end

  def unshared_description
    [
      "Currently taking applications for 1 Bedroom/Bathroom apartment close to UCLA (Strathmore/Veteran) Available December 5th. 10-minute stroll to UCLA, very close to Target/CVS/Whole Foods/Ralphs Comes with a parking spot Take the apartment for yourself for $2240 or sign up for our roommate match for an easy arrangement of a double ($1,120) or triple ($747). Has reserved parking/swimming pool/On-sight laundry facility",
      "Available December 5th! 1b1b apartment. Very close to UCLA. Get it all for yourself ($2240/month) or sign up for our roommate match. ($747/month. PM if you'd like to sign up).",
      "1b1b Apartment available December 5th. These units are very close to UCLA (11090 Strathmore Dr.) We are currently accepting applications for a unit that will be available starting December 5th. The whole unit is $2240/month but you are welcome to sign up for our roommate match so you can split the cost and save some dollars. PM or call with inquiries 310-694-4660",
      "Details:\n
      • Rent Total is $2240. Double: $1120, Triple: $747\n
      • We do roommate matching. Call/Text if interested 310-694-4660\n
      • 1 bedroom 1 bathroom apartment\n
      • 6-8 month lease\n
      • Close to UCLA (Strathmore Dr. / Veteran Ave.)\n
      • Available December 10th\n
      • Includes 1 parking spot\n
      • Utilities are separate\n
      • On-Sight Laundry Facility",
      "Get the best of both worlds at Strathmore Arms apartments, convenience and comfort. We are situated in Westwood, CA minutes away from UCLA, and nearby the I-405. All our apartments come equipped with central air and assigned parking.  There is also additional storage space to satisfy your storage needs. You can enjoy your day by the pool, or spend the day at Westwood Park, go shopping, eat at one of the many restaurants in the area, or take in a movie! At Strathmore Arms, you will find yourself surrounded by all the possibilities you've dreamed of. 11090 Strathmore Dr. Los Angeles, CA",
      "Strathmore Arms rests on the peaceful corner of Veteran and Strathmore. These unfurnished one bedroom apartments, complete with kitchen and common living space, provide a sweet repose from the daily demands of life. Strathmore Arms is a perfect union of minimalism and luxury, complete with laundry facility, swimming pool, and barbecue area while maintaining relative affordability for a property that is such short distance from UCLA campus. Call 310-694-4660 to schedule a tour of your future home or take a virtual tour by visiting rentstrathmore.com.",
      "This 1 bedroom 1 bathroom apartment is exceptionally close to UCLA buts maintains a peaceful atmosphere perfect for those who want to live close to the conveniences of Westwood Village but far from the chaos. The unit comes with a fully functioning kitchen, bathroom, and bedroom.Take a dip in the pool, grill on our community grill, or take your adventure out into Los Angeles with ease because of the free parking included with your unit!\nFeel free to check out more details at www.RentStrathmore.com or call the on-sight property manager",
      "Strathmore Arms is a great living environment just a few blocks from UCLA and exciting Westwood Village with upscale dining, shopping, and entertainment. Abundant with closets and cupboards, each one bedroom floor plan is uniquely appointed with 1950's architecture. Kitchens include gas stoves, refrigerators, and separate dining areas. Plush carpet and modern verticals are included throughout. Our cozy community has the feel of living on the periphery of a bustling Westwood Village with serene vibes; Strathmore Arms is a great place to live and commute. Call 310-694-4660 to schedule a tour of your future home or take a virtual tour by visiting rentstrathmore.com.",
      "Welcome to the apartment of your dreams, a real doers apartment complex that has all that you need and the space just for you. Get the best of both worlds at Strathmore Arms apartments, convenience and comfort. We are situated in Westwood, CA minutes away from UCLA, and nearby the I-405. All our apartments come equipped with central air and assigned parking.  There is also additional storage space to satisfy your storage needs. You can enjoy your day by the pool, or spend the day at Westwood Park, go shopping, eat at one of the many restaurants in the area, or take in a movie! At Strathmore Arms, you will find yourself surrounded by all the possibilities you've dreamed of."
    ].sample

  end

  def shared_title
    [
      "Shared Room in Triple. 1 Bed Apt. UCLA"
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
