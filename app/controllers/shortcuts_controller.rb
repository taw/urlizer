class ShortcutsController < ApplicationController
  def index
    @shortcuts = Shortcut.all
    @shortcut = Shortcut.new
  end

  def create
    slug = Shortcut.random_slug
    target = params.require(:shortcut)[:target]
    if target.present? and target !~ /\A(https?:)/
      target = "http://#{target}"
    end
    @shortcut = Shortcut.create(target: target, slug: slug)
    if @shortcut.save
      redirect_to action: :index
    else
      @shortcuts = Shortcut.all
      render :index
    end
  end

  def show
    slug = params.require(:id)
    shortcut = Shortcut.where(slug: slug).first!
    redirect_to shortcut.target
  end
end
