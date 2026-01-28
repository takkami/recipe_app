class FavoritesController < ApplicationController
  def index
    @recipes = current_user.favorited_recipes.includes(:user).order("favorites.created_at DESC")
  end

  def create
    recipe = Recipe.find(params[:recipe_id])
    current_user.favorites.create!(recipe: recipe)
    redirect_back fallback_location: recipes_path, notice: "お気に入りに追加しました"
  rescue ActiveRecord::RecordNotUnique
    redirect_back fallback_location: recipes_path
  end

  def destroy
    recipe = Recipe.find(params[:recipe_id])
    current_user.favorites.find_by!(recipe: recipe).destroy!
    redirect_back fallback_location: recipes_path, notice: "お気に入りを解除しました"
  end
end
