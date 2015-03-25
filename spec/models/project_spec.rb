require "rails_helper"

describe Project do
  describe "#owner?" do
    it "returns true if the user is a owner of the project" do
      project = create_project
      user = create_user
      create_membership(project_id: project.id, user_id: user.id, role: "Owner")

      expect(project.owner?(user)).to eq true
    end

    it "returns false if the user is a member of the project" do
      project = create_project
      user = create_user(first_name: "Hank the tank")
      create_membership(project_id: project.id, user_id: user.id, role: "Member")

      expect(project.owner?(user)).to eq false
    end

    it "returns false if the user is not associated to the project" do
      project = create_project
      user = create_user(first_name: "Hank the tank")

      expect(project.owner?(user)).to eq false
    end
  end
end