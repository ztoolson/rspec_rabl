describe "Error Messages" do
  it "renders a helpful error message without root or object_root options" do
    example = nil
    group = RSpec.describe "user.rabl" do
      include_context "user_context"
      example = it{ expect(subject).to render_attribute(:guid).with_value("Imma derp derp") }
    end
    group.run
    lines = RSpec::Core::Notifications::FailedExampleNotification.new(example).message_lines.join("\n")

    expect(lines).to include("with_value(")
    expect(lines).to include("Imma derp derp")
    expect(lines).to include("  expected \"Imma derp derp\" in [\"guid\"]")
    expect(lines).to include("    got nil")
  end

  it "renders a helpful error message for root and object_root" do
    example = nil
    group = RSpec.describe "user.rabl" do
      include_context "user_context"
      rabl_data(:object_root => "user"){ [user] }
      example = it{ expect(subject).to render_attribute(:guid).with_value("Imma derp derp") }
    end
    group.run
    lines = RSpec::Core::Notifications::FailedExampleNotification.new(example).message_lines.join("\n")

    expect(lines).to include("with_value(")
    expect(lines).to include("Imma derp derp")
    expect(lines).to include("  expected \"Imma derp derp\" in [\"user\"][\"guid\"]")
    expect(lines).to include("    got \"abc\"")
  end

  it "renders a helpful error message for root and object_root" do
    example = nil
    group = RSpec.describe "index.rabl" do
      include_context "user_context"
      rabl_data(:root => "users", :object_root => "user"){ [user] }
      example = it{ expect(subject).to render_attribute(:guid).with_value("Imma derp derp") }
    end
    group.run
    lines = RSpec::Core::Notifications::FailedExampleNotification.new(example).message_lines.join("\n")

    expect(lines).to include("with_value(")
    expect(lines).to include("Imma derp derp")
    expect(lines).to include("  expected \"Imma derp derp\" in [\"users\"][\"user\"][\"guid\"]")
    expect(lines).to include("    got \"abc\"")
  end
end
