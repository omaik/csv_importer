class ImportsController < ApplicationController
  def index
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      redirect_to :index
    else
      render :new
    end
  end

  def new
    @import = Import.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def import_params
    params.require(:import).permit(:title, :file)
  end
end
