# frozen_string_literal: true

class ImportsController < ApplicationController
  before_action :find_import, only: %i[start edit update destroy]

  def index
    @created_imports = Import.created
    @started_imports = StartedImportDecorator.decorate_collection(
      Import.started
    )
    @completed_imports = CompletedImportDecorator.decorate_collection(
      Import.completed
    )
  end

  def create
    result = Imports::Create.new(create_params).call
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
    result = Imports::Start.new(@import).call

    # do not handle error case for now
    redirect_to imports_url if result[:success]
  end

  def edit; end

  def update
    result = Imports::Update.new(@import, update_params).call

    if result[:success]
      redirect_to imports_url
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
