class BooksController < ApplicationController

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: 'your post was successfully'
    else
      @errors_list = @book
      @books = Book.all
      @book = Book.new
      @user = current_user
      flash.now[:alert] = 'your post was failed'
      render :index
      #redirect_to books_path
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @new_book = Book.new
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def edit
    @book = Book.find(params[:id])
    if !user_signed_in?
      redirect_to new_user_session_path
    else
      if @book.user != current_user
        redirect_to books_path
      end
    end
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      redirect_to book_path(book.id), notice: 'your update was successfully'
    else
      @errors_list = book
      @book = Book.find(params[:id])
      flash.now[:alert] = 'your update was failed'
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    if book.destroy
      redirect_to books_path, notice: 'your destroy was successfully'
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

end
