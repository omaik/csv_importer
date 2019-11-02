class ImportsController < ApplicationController
  def index
    # CHANGE ME
    @created_imports = Import.created
    @started_imports = Import.started
    @finished_imports = Import.finished
  end

  def create
    @import = Import.new(import_params)
    if @import.save
      redirect_to imports_url
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
