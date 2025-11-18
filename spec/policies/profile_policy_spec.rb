require "rails_helper"

RSpec.describe ProfilePolicy do
  subject(:policy) { described_class.new(user, record) }

  let(:record) { owner }
  let(:owner) { create(:user) }

  context "when user is the record" do
    let(:user) { owner }

    it "permits profile access" do
      expect(policy.show?).to be(true)
      expect(policy.edit?).to be(true)
      expect(policy.update?).to be(true)
    end
  end

  context "when user is different" do
    let(:user) { create(:user) }

    it "forbids profile access" do
      expect(policy.show?).to be(false)
      expect(policy.edit?).to be(false)
      expect(policy.update?).to be(false)
    end
  end
end
