class PadsController < ApplicationController
  include Etherpad
  include Mediawiki
  layout 'pad', only: [:show]
  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_pad, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :pad
  skip_authorize_resource only: [:edit, :update]

  # GET /pads
  # GET /pads.json
  def index
    if user_signed_in? && params[:group_id].present?
      @group = Group.find(params[:group_id])
    else
      @group = Group.find_or_create_by(name: 'ungrouped')
    end

    @pads = @group.pads.joins('LEFT JOIN users ON users.id = pads.creator_id')
    @pads = @pads.where("is_public = 't' or is_public_readonly = 't'") if current_user.nil?
    @pads = @pads.order(sort_column + ' ' + sort_direction)
  end

  # GET /p/1
  # GET /p/1.json
  def show
    cookies[:sessionID] = nil

    if user_signed_in?
      @author = ether.author(current_user.name, name: current_user.name)
      @author.sessions.each do |sess|
        if sess.expired? || !@pad.group.users.include?(current_user)
          sess.delete
        end
      end
      if @pad.group.users.include?(current_user) || @pad.group.managers.include?(current_user) || @pad.group.name == 'ungrouped'
        sess = @pad.group.ep_group.create_session(@author, 480)
        cookies[:sessionID] = {:value => sess.id}
      end
    end

    @has_drawer = can? :update, @pad
    @is_public_readonly = !user_signed_in? && @pad.is_public_readonly
    @group = @pad.group
  end

  # GET /pads/new
  def new
    @group = Group.find(params[:group_id])
    @pad = @group.pads.build
  end

  # GET /pads/1/edit
  def edit
    authorize! :update, @pad
    @group = @pad.group
  end

  # POST /pads
  # POST /pads.json
  def create
    @group = Group.find(params[:group_id])
    @pad = Pad.new(pad_params)
    @pad.group_id = @group.id

    @pad.creator_id = current_user.id

    respond_to do |format|
      if @pad.save
        format.html {
          pad_url = '/p/'+@group.name+'/'+@pad.name
          pad_url = '/p/'+@pad.name if @group.name == 'ungrouped'
          redirect_to pad_url, notice: t('pad_created')
        }
        format.json { render action: 'show', status: :created, location: @pad }
      else
        format.html { render action: 'new', error: 'Error' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pads/1
  # PATCH/PUT /pads/1.json
  def update
    authorize! :update, @pad
    @group = @pad.group
    if pad_params[:wiki_page].present?
      mw.edit(pad_params[:wiki_page], @pad.ep_pad.text, :summary => 'via Eplmgmt by '+current_user.name)
    end

    @pad.is_public = (params[:pad][:options] != 'closed')
    @pad.is_public_readonly = (params[:pad][:options] == 'read')
    @pad.save

    respond_to do |format|
      if @pad.update(pad_params) || params[:pad][:delete_ep_pad] == 'true'
        format.html {
          if (params[:pad][:delete_ep_pad] == 'true') && pad_params[:wiki_page].present?
            @pad.destroy
            redirect_to @pad.wiki_url, notice: t('pad_destroyed')
          elsif params[:pad][:delete_ep_pad] == 'true'
            @pad.destroy
            if @pad.group.name == 'ungrouped'
              redirect_to '/pads', notice: t('pad_destroyed')
            else
              redirect_to @pad.group
            end
          elsif pad_params[:wiki_page].present?
            redirect_to @pad.wiki_url, notice: t('pad_updated')
          else
            if @pad.group.name == 'ungrouped'
              redirect_to named_pad_path(@pad.name), notice: t('pad_updated')
            else
              redirect_to named_group_pad_path(@pad.group.name, @pad.name), notice: t('pad_updated')
            end
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pads/1
  # DELETE /pads/1.json
  def destroy
    @pad.destroy
    respond_to do |format|
      format.html {
        if @pad.group.name == 'ungrouped'
          redirect_to named_pads_url
        else
          redirect_to group_url(@pad.group)
        end
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pad
      if params[:pad].present? || params[:id].present?
        @pad = Pad.find(params[:id]) rescue nil
        @pad ||= Pad.find_by(name: params[:pad])
        @pad = Pad.find_or_create_by(name: params[:pad],
                                     creator_id: current_user.id) if @pad.nil? && !current_user.nil?
        @pad = Pad.find_by(readonly_id: params[:pad]) if @pad.nil? && current_user.nil?
      elsif params[:pad].present? && params[:group].present?
        group = Group.find_by(name: params[:group])
        @pad = group.pads.find_by(name: params[:pad]) rescue nil
        @pad = group.pads.find_or_create_by(name: params[:pad],
                                            creator_id: current_user.id) if @pad.nil?
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pad_params
      params.require(:pad).permit(:name, :password, :options, :wiki_page, :delete_ep_pad)
    end
end
