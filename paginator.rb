require 'json'

module Github
  class Paginator
    PER_PAGE = 100

    def initialize(client)
      @client = client
    end

    def paginate(url)
      page = 1
      all_issues = []
      loop do
        response = @client.get("#{url}&per_page=#{PER_PAGE}&page=#{page}")
        issues = JSON.parse(response.body)
        break if issues.empty?

        all_issues += issues
        page += 1
      end
      all_issues
    end
  end
end
