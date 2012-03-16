class ProductsController < ApplicationController
  helper :rank
  helper :share
  include ProductsFilter
  include ResourcesFilter

  before_filter :find_page

  def index
    present(@page)

    products!

    if @not_found
      return error_404
    end
    @branch = params[:kind] ? params[:kind] : params[:resource]
    @leaf = params[:kind_name] ? params[:kind_name] : params[:filter_name]
    
  end

  def show
    @product = Product.find(params[:id])
    @related_videos = Video.by_product @product

    present(@page)
  end
  
protected

  def find_page
    @page = Page.where(:link_url => "/products").first
  end
  
end
