module Admin
  class MedicinesController < ApplicationController
    def index
      @medicines = Medicine.all
    end

    def show
      @medicine = Medicine.find(params[:id])
    end

    def new
      @medicine = Medicine.new
    end

    def create
      @medicine = Medicine.new(medicine_params)
      if @medicine.save
        redirect_to admin_medicine_path(@medicine), notice: "Medicine created successfully."
      else
        render :new
      end
    end

    def edit
      @medicine = Medicine.find(params[:id])
    end

    def update
      @medicine = Medicine.find(params[:id])
      if @medicine.update(medicine_params)
        redirect_to admin_medicine_path(@medicine), notice: "Medicine updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @medicine = Medicine.find(params[:id])
      @medicine.destroy
      redirect_to admin_medicines_path, notice: "Medicine deleted successfully."
    end

    private

    def medicine_params
      params.require(:medicine).permit(:name, :description, :price, :stock, :category_id)
      # Adjust permitted parameters based on your Medicine model.
    end
  end
end
