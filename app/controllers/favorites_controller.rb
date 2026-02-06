class FavoritesController < ApplicationController
  def index
    favorite_recipe_ids = current_user.favorites
                                      .order(created_at: :desc)
                                      .pluck(:recipe_id)

    @q = Recipe.where(id: favorite_recipe_ids).ransack(params[:q])
    @recipes = @q.result.includes(:user)

    if @recipes.present? && params[:q].blank?
      @recipes = @recipes.sort_by { |recipe| favorite_recipe_ids.index(recipe.id) }
    end
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
