# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :find_import, only: %i[show start edit update destroy]

  def index
    @created_imports = Import.created.decorate
    @started_imports = Import.started.decorate
    @completed_imports = Import.completed.decorate
  end

  def show
    @import = ImportDecorator.decorate_one(@import)
  end

  def create
    result = Imports::Create.new(create_params).call
    @import = result[:object]
    if result[:success]
      redirect_to import_url(@import)
    else
      @errors = result[:errors]
      render :new
    end
  end

  def new
    @import = Import.new
  end

  def start
    result = Imports::Start.new(@import).call

    # do not handle error case for now
    redirect_to import_url(@import) if result[:success]
  end

  def edit; end

  def update
    result = Imports::Update.new(@import, update_params).call

    if result[:success]
      redirect_to import_url(@import)
    else
      @errors = result[:errors]
      render :edit
    end
  end

  def destroy
    result = Imports::Destroy.new(@import).call

    # do not handle error case for now
    redirect_to imports_url if result[:success]
  end

  private

  def create_params
    params.require(:import).permit(:title, :file)
  end

  def update_params
    params.require(:import).permit(:title)
  end

  def find_import
    @import = Import.find(params[:id])
  end
end
