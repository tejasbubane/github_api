require 'spec_helper'
require_relative '../client'
require 'securerandom'

RSpec.describe Github::Client do
  let(:token) { SecureRandom.uuid }
  let(:repo_url) { 'https://api.github.com/repos/paper-trail-gem/paper_trail' }
  let(:url) { "/issues?state=open"}
  let(:expected_headers) do
    {
      'Authorization' => "Bearer #{token}",
      'User-Agent' => 'Github Client'
    }
  end

  subject { described_class.new(token, repo_url) }

  it 'calls given URL with correct headers' do
    expect(HTTParty).to receive(:get).with("#{repo_url}#{url}", headers: expected_headers)

    subject.get(url)
  end
end
