class DadJokeController < ApplicationController
  
  def index
    dad_joke_service = DadJokeService.new
    result = dad_joke_service.get_joke

    if result[:error]
      flash[:error] = result[:error]
      @joke_data = nil
    else
      @joke_data = result[:data]
    end

  end
end
