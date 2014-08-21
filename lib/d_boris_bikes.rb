require 'csv'

class BikeGoneTooLongError < StandardError
	def message
		"You took the bike out for more than half an hour!"
	end
end


class Bike

	BIKE_LOG_CSV = "./lib/bikes.csv"

	attr_reader :serial, :checkout_time, :checkin_time, :location

	def initialize
		@broken = false
		@rented = false
		@serial = (1..9).inject(""){ |memo| memo += rand(9).to_s } 
		@location = "detached"
		write_details_to_csv		
	end

	# def write_details_to_csv
	# 	CSV.foreach("./lib/bikes.csv") do |row|
	# 		if row[0] == @serial 
	# 			row =	[@serial,broken?,rented?,location]
	# 			return true
	# 		end
	# 	end 
	# 	CSV.open("./lib/bikes.csv","a") do |csv|
	# 		csv << [@serial,broken?,rented?,location]
	# 	end
	# end	

	def write_details_to_csv
		append_status_to_csv unless update_status_in_csv			
	end

	def append_status_to_csv			
		CSV.open(BIKE_LOG_CSV,"a") do |csv|
			csv << update_bike_data
		end
	end


	def update_status_in_csv
		CSV.foreach(BIKE_LOG_CSV) { |row| return update_bike_data(row) if row.include? @serial }; nil
	end

	def update_bike_data(row = 0 )
		row = [@serial,broken?,rented?,location]
	end

	def broken?
		@broken
	end

	def break!
		@broken = true
	end

	def fix!
		@broken = false
	end

	def rented?
		@rented
	end
	
	def rent!
		@rented = true
		@checkout_time = Time.now.round(0)
	end
	
	def return!
		@rented = false
		@checkin_time = Time.now.round(0)
		raise BikeGoneTooLongError if seconds_rented > 1800
	end

	def seconds_rented
		@checkin_time - @checkout_time
	end

end