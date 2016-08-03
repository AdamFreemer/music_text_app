require "routine"

describe Routine do
	describe "#run_sequence" do
		context "when @quit is false" do
			it "should call 'run_sequence'" do
			  expect(subject).to receive(:run_sequence)
			  subject.run_sequence
			end
		end
	end

	describe "#show_all" do
		it "should call 'list_songs'" do
		  expect(subject).to receive(:list_songs).with([])
		  subject.show_all
		end
	end
end
