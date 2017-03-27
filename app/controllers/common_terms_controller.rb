class CommonTermsController < ApplicationController
  before_action :require_admin, except: [:login, :authenticate]
  before_action :set_common_term, only: [:show, :edit, :update, :destroy]

  # GET /common_terms
  # GET /common_terms.json
  def index
    @common_terms = CommonTerm.all
  end

  # GET /common_terms/1
  # GET /common_terms/1.json
  def show
  end

  # GET /common_terms/new
  def new
    @common_term = CommonTerm.new
  end

  # GET /common_terms/1/edit
  def edit
  end

  # POST /common_terms
  # POST /common_terms.json
  def create
    @common_term = CommonTerm.new(common_term_params)

    respond_to do |format|
      if @common_term.save
        format.html { redirect_to @common_term, notice: 'Common term was successfully created.' }
        format.json { render :show, status: :created, location: @common_term }
      else
        format.html { render :new }
        format.json { render json: @common_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /common_terms/1
  # PATCH/PUT /common_terms/1.json
  def update
    respond_to do |format|
      if @common_term.update(common_term_params)
        format.html { redirect_to @common_term, notice: 'Common term was successfully updated.' }
        format.json { render :show, status: :ok, location: @common_term }
      else
        format.html { render :edit }
        format.json { render json: @common_term.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /common_terms/1
  # DELETE /common_terms/1.json
  def destroy
    @common_term.destroy
    respond_to do |format|
      format.html { redirect_to common_terms_url, notice: 'Common term was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def login
    
  end
  
  def authenticate
    sleep 0.5
    if params[:password] == ENV['ADMIN_PASSWORD']
      session[:login_expires_at] = Time.now.to_i + 1.week
      session[:token] = authenticity_token
      redirect_to common_terms_path
    else 
      logger.info("Invalid password provided.")
      flash[:error] = 'Please try again.'
      redirect_to login_path
    end
  end    
  
  private
    def require_admin
      if Time.now.to_i > session[:login_expires_at].to_i ||
         session[:token] != authenticity_token
        redirect_to login_path
      end        
    end

    def authenticity_token
      Digest::SHA2.hexdigest(ENV['SALT'] + session[:login_expires_at].to_s)
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_common_term
      @common_term = CommonTerm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def common_term_params
      params.require(:common_term).permit(:search_term, :pages)
    end
end
