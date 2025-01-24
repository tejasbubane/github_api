require 'spec_helper'
require 'json'
require_relative '../paginator'
require_relative '../client'

def build_response(array)
  double("response", body: array.to_json)
end

RSpec.describe Github::Paginator do
  let(:client) { instance_double(Github::Client) }
  let(:issues_first_page) { [{ id: 1, title: 'Update gem' }, { id: 2, title: 'Create release' }] }
  let(:issues_second_page) { [{ id: 3, title: 'Returns invalid' }, { id: 4, title: 'Bug xyz' }] }
  let(:issues_third_page) { [{ id: 5, title: 'Returns invalid' }, { id: 6, title: 'Bug xyz' }] }

  subject { described_class.new(client) }

  describe ".paginate" do
    it "fetches data from all pages" do
      expect(client).to receive(:get).ordered.with(a_string_matching("&page=1")) do
        build_response(issues_first_page)
      end
      expect(client).to receive(:get).ordered.with(a_string_matching("&page=2")) do
        build_response(issues_second_page)
      end
      expect(client).to receive(:get).ordered.with(a_string_matching("&page=3")) do
        build_response(issues_third_page)
      end
      expect(client).to receive(:get).ordered.with(a_string_matching("page=4")) { build_response([]) }

      issues = subject.paginate("/issues?status=closed")
      received_issue_ids = issues.map { |issue| issue['id'] }

      expect(received_issue_ids).to match_array([1, 2, 3, 4, 5, 6])
    end
  end
end
