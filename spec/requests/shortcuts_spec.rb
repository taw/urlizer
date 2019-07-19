require 'rails_helper'

RSpec.describe "Shortcuts", type: :request do
  describe "GET /shortcuts" do
    let(:links) { document_root_element.css("a").map{|a| a["href"] } }

    it "lists all shortcuts" do
      Shortcut.create(target: "https://twitter.com", slug: "abcd").save!
      Shortcut.create(target: "https://en.wikipedia.org", slug: "defg").save!
      get "/shortcuts"
      expect(response).to have_http_status(200)
      expect(links).to include "/abcd"
      expect(links).to include "https://twitter.com"
      expect(links).to include "/defg"
      expect(links).to include "https://en.wikipedia.org"
    end
  end

  describe "POST /shortcuts" do
    it "creates a shortcut and redirects to /" do
      post "/shortcuts", params: {shortcut: {target: "http://en.wikipedia.org"}}
      expect(Shortcut.count).to eq(1)
      expect(Shortcut.first.target).to eq("http://en.wikipedia.org")
      expect(response).to redirect_to "/shortcuts"
    end

    it "supports https: urls" do
      post "/shortcuts", params: {shortcut: {target: "https://twitter.com/"}}
      expect(Shortcut.count).to eq(1)
      expect(Shortcut.first.target).to eq("https://twitter.com/")
      expect(response).to redirect_to "/shortcuts"
    end

    it "prepends http:// if necessary" do
      post "/shortcuts", params: {shortcut: {target: "www.google.com"}}
      expect(Shortcut.count).to eq(1)
      expect(Shortcut.first.target).to eq("http://www.google.com")
      expect(response).to redirect_to "/shortcuts"
    end

    it "shows error if target is missing" do
      post "/shortcuts", params: {shortcut: {target: ""}}
      expect(Shortcut.count).to eq(0)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /shortcuts/:slug" do
    it "redirects to target url" do
      Shortcut.create(target: "https://twitter.com", slug: "abcd").save!
      get "/abcd"
      expect(response).to redirect_to "https://twitter.com"
    end

    it "returns 404 if no such shortcut" do
      Shortcut.create(target: "https://twitter.com", slug: "abcd").save!
      # That's 404 in production mode
      expect{ get "/efgh" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
