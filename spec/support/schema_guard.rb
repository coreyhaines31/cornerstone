RSpec.shared_context "requires table" do |table_name|
  before do
    unless ActiveRecord::Base.connection.data_source_exists?(table_name)
      skip "Skipping: table #{table_name} is missing in the test database"
    end
  end
end
