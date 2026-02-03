class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: %i[show]
  before_action :set_my_recipe, only: %i[edit update destroy]

  def index
    @q = Recipe.includes(:user).ransack(params[:q])
    @recipes = @q.result(distinct: true).order(created_at: :desc)
  end

  def mine
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).order(created_at: :desc)
  end

  def show
  end

  def new
    @recipe = current_user.recipes.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "レシピを登録しました"
    else
      flash.now[:alert] = "入力内容を確認してください"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @recipe.update(recipe_params)
      redirect_to @recipe, notice: "レシピを更新しました"
    else
      flash.now[:alert] = "入力内容を確認してください"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy!
    redirect_to recipes_path, notice: "レシピを削除しました"
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :source_url, :ingredients, :memo, :image)
  end

  def set_recipe
    @recipe = Recipe.includes(:user).find_by(id: params[:id])
    return if @recipe

    redirect_to recipes_path, alert: "レシピが見つかりませんでした"
  end

  def set_my_recipe
    @recipe = current_user.recipes.find_by(id: params[:id])
    return if @recipe

    redirect_to recipes_path, alert: "レシピが見つかりませんでした"
  end
end
