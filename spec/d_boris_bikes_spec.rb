require 'csv'
require 'd_boris_bikes'
require 'Timecop'

describe Bike do

	let(:bike) { Bike.new }

	it "should have a serial number when created" do
		expect(bike.serial).not_to be nil
	end

	it "should have a nine-digit numerical serial number" do
		expect(bike.serial.to_s).to match(/\d{9}/)
	end

	it "should have a unique serial number" do
		expect(bike.serial.to_s).not_to eq(Bike.new.serial.to_s)
	end


	it "should not be broken when it is created" do
		expect(bike.broken?).to be false
	end

	it "should be able to break" do
		bike.break!
		expect(bike).to be_broken
	end

	it "should be able to get fixed" do
		bike.break!
		bike.fix!
		expect(bike).not_to be_broken
	end

	it "should know if it has been rented or not" do
		expect(bike.rented?).to eq false
	end

	it "should be able to be rented by a user" do
		bike.rent!
		expect(bike.rented?).to eq true
	end

	it "should know the time at which it has been rented" do
		t = Time.now.round(0)
		bike.rent!
		expect(bike.checkout_time).to eq t	
	end

	it "should be able to be returned by a user" do
		bike.rent!
		bike.return!
		expect(bike.rented?).to eq false
	end

	it "should know the time it has been returned" do
		bike.rent!
		t = Time.now.round(0)
		bike.return!
		expect(bike.checkin_time).to eq t	
	end

	it "should know it has been gone for 900 seconds" do
		bike.rent!
		Timecop.travel(900)
		bike.return!
		expect(bike.seconds_rented).to eq 900
	end

	it "should know it has been gone for 1801 seconds" do 
		bike.rent!
		Timecop.travel(1801)
		expect { bike.return! }.to raise_error BikeGoneTooLongError
		expect(bike.seconds_rented).to eq 1801
	end

	it "should raise a custom error if it's been gone for more than half an hour" do
		bike.rent!
		Timecop.travel(1801)
		expect{ bike.return! }.to raise_error(BikeGoneTooLongError, "You took the bike out for more than half an hour!")
	end

	it "should, on initialization, write its attributes to a CSV" do
		bike1 = Bike.new
		file = CSV.read("./lib/bikes.csv")
		expect(file).to include([bike1.serial])
	end
	it "writes all attributes for a bike to a CSV row" do 
		bike1 = Bike.new
		file = CSV.read("./lib/bikes.csv")
		expect(file.last).to eq [bike1.serial,bike1.broken?,bike1.rented?]
	end

end









