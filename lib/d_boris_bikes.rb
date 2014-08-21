require 'csv'

class BikeGoneTooLongError < StandardError
	def message
		"You took the bike out for more than half an hour!"
	end
end


class Bike

	attr_reader :serial, :checkout_time, :checkin_time

	def initialize
		@broken = false
		@rented = false
		@serial = (1..9).inject(""){ |memo| memo += rand(9).to_s } 
		write_details_to_csv		
	end

	def write_details_to_csv
		CSV.foreach("./lib/bikes.csv") do |row|
			if row[0] = @serial 
				row =	[@serial,broken?,rented?]
				return true
			end
		end 
		CSV.open("./lib/bikes.csv","a") do |csv|
			csv << [@serial,broken?,rented?]
		end

	end	

	def check_uniqueness
		file = CSV.read("./lib/bikes.csv")
		file.flatten.count(serial) == 0 
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