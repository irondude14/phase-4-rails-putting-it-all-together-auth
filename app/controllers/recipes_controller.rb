class RecipesController < ApplicationController
  def index
    if session[:user_id]
      recipes =
        Recipe
          .all
          .includes(:user)
          .select(:id, :title, :instructions, :minutes_to_complete, :user_id)
      render json: recipes,
             include: {
               user: {
                 only: %i[username image_url bio],
               },
             },
             status: :ok
    else
      render json: {
               errors: ['You must be logged in to view recipes'],
             },
             status: :unauthorized
    end
  end

  def create
    if session[:user_id]
      recipe = Recipe.new(recipe_params)
      recipe.user_id = session[:user_id]
      if recipe.save
        render json:
                 recipe.as_json(
                   include: {
                     user: {
                       only: %i[username image_url bio],
                     },
                   },
                 ),
               status: :created
      else
        render json: {
                 errors: recipe.errors.full_messages,
               },
               status: :unprocessable_entity
      end
    else
      render json: {
               errors: ['You must be logged in to create recipes'],
             },
             status: :unauthorized
    end
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end
end
