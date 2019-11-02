class ImportsController < ApplicationController
  def index
    @created_imports = Import.created
    @started_imports = Import.started
    @finished_imports = Import.finished
  end

  def create
    result = Imports::Create.new(import_params).call
    if result[:success]
      redirect_to imports_url
    else
      @import = result[:object]
      @errors = result[:errors]
      render :new
    end
  end

  def new
    @import = Import.new
  end

  def start
    result = Imports::Start.new(params[:id]).call

    # do not handle error case for now
    redirect_to imports_url if result[:success]
  end

  def edit
    @import = Import.find(params[:id])
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
