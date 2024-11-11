class PokemonController < ApplicationController
  def index
    if params[:pokemon].present?
      pokemon_service = PokemonService.new(params[:pokemon])
      result = pokemon_service.get_pokemon

      if result[:error]
        flash[:error] = result[:error]
        @pokemon_data = nil
      else
        @pokemon_data = result[:data]
      end
    else
      flash[:error] = 'Pokemon name is required'
    end
  end
end
