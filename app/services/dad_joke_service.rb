require 'httparty'
require 'json'

class DadJokeService
  def get_joke
    url = 'https://icanhazdadjoke.com/'
    response = HTTParty.get(url, headers: { 'Accept' => 'application/json' })

    if response.success?
      joke_data = parse_response(response)
      { data: joke_data }
    else
      { error: 'Could not retrieve joke data' }
    end
  end

  def parse_response(response)
    response['joke']
  end
end
