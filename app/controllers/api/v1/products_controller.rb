class Api::V1::ProductsController < ApplicationController

  
   # GET /products
      def index
        products = Product.all
        render json: products
      end

      # GET /products/:id
      def show
        product = Product.find(params[:id])
        render json: product
      end

      # POST /products
      def create
        product = Product.new(product_params)

        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT /products/:id
      def update
        product = Product.find(params[:id])

        if product.update(product_params)
          render json: product
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /products/:id
      def destroy
        product = Product.find(params[:id])
        product.destroy

        render json: { message: "Product deleted successfully" }
      end

      private

      def product_params
        params.require(:product).permit(
          :name,
          :description,
          :price,
          :stock,
          :image
        )
      end

end
