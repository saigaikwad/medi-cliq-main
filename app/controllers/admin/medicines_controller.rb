module Admin
  class MedicinesController < ApplicationController
    before_action :set_medicine, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_admin_user!
    def index
      @medicines = Medicine.all.group_by { |m| m.name.presence || "Unnamed Medicine" }
    end

    def show
      @related_batches = Medicine.where(name: @medicine.name).order(:exp_date)
    end

    def new
      @medicine = Medicine.new
    end

    def create
      existing_medicine = Medicine.find_by(name: medicine_params[:name])

      if existing_medicine
        # Create a new batch (a new record)
        new_batch = Medicine.new(medicine_params)

        if new_batch.save
          redirect_to admin_medicine_path(new_batch), notice: "New batch added for existing medicine."
        else render :new, status: :unprocessable_entity
        end
      else # Create a brand new medicine entry
        @medicine = Medicine.new(medicine_params)

        if @medicine.save
          redirect_to admin_medicine_path(@medicine), notice: "Medicine was successfully created."
        else render :new, status: :unprocessable_entity
        end
      end
    end

    def edit; end

    def update
      if @medicine.update(medicine_params)
        redirect_to admin_medicine_path(@medicine), notice: "Medicine was successfully updated."
      else render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @medicine.destroy
      redirect_to admin_medicines_path, notice: 'Medicine deleted successfully.'
    end

    private

    def set_medicine
      @medicine = Medicine.find(params[:id])
    end

    def medicine_params
      params.require(:medicine).permit(:name, :exp_date, :form, :manufacturer, :category_id, :batch_no, :prescribed, :quantity, :price)
    end
  end


  # GET /admin/medicines/:id/new_batch
  def new_batch
    @medicine = Medicine.find(params[:id])
    @batch = Medicine.new(
      name: @medicine.name,
      category_id: @medicine.category_id,
      form: @medicine.form,
      manufacturer: @medicine.manufacturer,
      prescribed: @medicine.prescribed
    )
  end


  # POST /admin/medicines/:id/create_batch
  def create_batch
    @medicine = Medicine.find(params[:id])
    @batch = Medicine.new(batch_params)
    @batch.name = @medicine.name
    @batch.category_id = @medicine.category_id
    @batch.form = @medicine.form
    @batch.manufacturer = @medicine.manufacturer
    @batch.prescribed = @medicine.prescribed

    if @batch.save
      redirect_to admin_medicine_path(@batch), notice: 'New batch added successfully.'
    else
      render :new_batch, status: :unprocessable_entity
    end
  end


  private

  def set_medicine
    @medicine = Medicine.find(params[:id])
  end

  def batch_params
    params.require(:medicine).permit(:batch_no, :exp_date, :form, :manufacturer, :quantity, :price, :prescribed)
  end
end
