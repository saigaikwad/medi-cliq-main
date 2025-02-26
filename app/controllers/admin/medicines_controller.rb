module Admin
  class MedicinesController < ApplicationController
    before_action :authenticate_admin_user!
    before_action :set_medicine, only: %i[show edit update destroy]

    def index
      @q = Medicine.ransack(params[:q])
      @medicines = @q.result.order(created_at: :desc).page(params[:page])
    end

    def show; end

    def new
      @medicine = Medicine.new
    end

    def create
      @medicine = Medicine.new(medicine_params)
      if @medicine.save
        redirect_to admin_medicine_path(@medicine), notice: "✅ Medicine successfully created."
      else
        flash.now[:alert] = "Unable to create medicine. Please check the errors below."
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @medicine.update(medicine_params)
        redirect_to admin_medicine_path(@medicine), notice: "✅ Medicine successfully updated."
      else
        flash.now[:alert] = "Unable to update medicine. Please check the errors below."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @medicine.destroy
        redirect_to admin_medicines_path, notice: "Medicine successfully deleted."
      else
        redirect_to admin_medicines_path, alert: "Unable to delete medicine. It might have dependent records."
      end
    end

    private

    def set_medicine
      @medicine = Medicine.find(params[:id])
    end

    def medicine_params
      params.require(:medicine).permit(:name, :exp_date, :form, :manufacturer, :category_id, :batch_no, :prescribed, :quantity, :price)
    end
  end
end
