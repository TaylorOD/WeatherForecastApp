require 'httparty'
require 'json'

class PokemonService
  def initialize(pokemon_name)
    @pokemon_name = pokemon_name
  end

  def get_pokemon
    return { error: 'Invalid Pokemon name' } unless @pokemon_name

    api_key = ENV['POKEMON_API_KEY']
    url = "https://pokeapi.co/api/v2/pokemon/#{@pokemon_name}"
    response = HTTParty.get(url)

    if response.success?
      pokemon_data = parse_response(response)
      { data: pokemon_data }
    else
      { error: 'Could not retrieve Pokemon data' }
    end
  end

  private

  def parse_response(response)
    {
      name: response['name'],
      height: response['height'],
      weight: response['weight'],
      abilities: response['abilities'].map { |ability| ability['ability']['name'] }
    }
  end

end
