$:.unshift (File.dirname(__FILE__))
require 'lib/routine'

puts `clear`
puts "Welcome to your music collection!"

routine = Routine.new
routine.run_sequence