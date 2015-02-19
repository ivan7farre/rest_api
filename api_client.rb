require './lib/api.rb'
require 'nokogiri'

# CRUD example with an api

def list_employees(api_object)
  puts "Current Employees:"
  doc = Nokogiri::XML.parse api_object.read
  names = doc.xpath('employees/employee/name').collect {|e| e.text }
  puts names.join(", ")
  puts ""
end

api = Api.new
list_employees(api)

# Create
puts "Creating someone..."
api.create "Bobby Flay", 1999
list_employees(api)

# Read one and do nothing with it
api.read 1

# Read all and get valid IDs
doc = Nokogiri::XML.parse api.read
ids = doc.xpath('employees/employee/id').collect {|e| e.text }

# Update last record
puts "Updating last record ..."
api.update ids.last, "Robert Flaid", 2001
list_employees(api)

# Delete
puts "deleting last record ..."
api.delete ids.last
list_employees(api)
