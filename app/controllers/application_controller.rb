class ApplicationController < Sinatra::Base
  set :default_content_type, "application/json"

  get "/games" do
    games = Game.all.order(:title).limit(10)
    games.to_json
  end

  get "/games/:id" do
    game = Game.find(params[:id])

    game.to_json(only: [:id, :title, :genre, :price], include: {
                   reviews: { only: [:comment, :score], include: {
                     user: { only: [:name] },
                   } },
                 })
  end

  delete "/reviews/:id" do
    game = Review.find(params[:id])
    game.destroy
    game.to_json
  end

  post "/reviews" do
    review = Review.create(
      score: params[:score],
      comment: params[:comment],
      game_id: params[:game_id],
      user_id: params[:user_id],
    )
    review.to_json
  end

  patch "/reviews/:id" do 
    rev = Review.find(params[:id])
    rev.update(
      score: params[:score],
      comment: params[:comment]
    )
    rev.to_json
  end

end
