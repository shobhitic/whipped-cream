require 'spec_helper'

describe WhippedCream::Server do
  subject(:server) { described_class.new(plugin) }

  let(:plugin) {
    WhippedCream::Plugin.build do
      button "Open/Close", pin: 1
    end
  }

  before do
    Rack::Server.stub :start
  end

  it "creates a runner with the plugin" do
    server.runner.stub :sleep

    server.runner.open_close
  end

  it "reuses the same runner" do
    expect(server.runner).to eq(server.runner)
  end

  it "builds up a Sinatra application from a plugin" do
    server.start

    expect(
      server.web.routes['GET'].find { |route| route.first.match('/open_close') }
    ).to be_true
  end

  it "starts the Sinatra application" do
    expect(Rack::Server).to receive(:start)

    server.start
  end
end
