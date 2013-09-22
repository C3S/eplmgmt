require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PadsController do

  # This should return the minimal set of attributes required to create a valid
  # Pad. As you add validations to Pad, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "pad_id" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PadsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all pads as @pads" do
      pad = Pad.create! valid_attributes
      get :index, {}, valid_session
      assigns(:pads).should eq([pad])
    end
  end

  describe "GET show" do
    it "assigns the requested pad as @pad" do
      pad = Pad.create! valid_attributes
      get :show, {:id => pad.to_param}, valid_session
      assigns(:pad).should eq(pad)
    end
  end

  describe "GET new" do
    it "assigns a new pad as @pad" do
      get :new, {}, valid_session
      assigns(:pad).should be_a_new(Pad)
    end
  end

  describe "GET edit" do
    it "assigns the requested pad as @pad" do
      pad = Pad.create! valid_attributes
      get :edit, {:id => pad.to_param}, valid_session
      assigns(:pad).should eq(pad)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Pad" do
        expect {
          post :create, {:pad => valid_attributes}, valid_session
        }.to change(Pad, :count).by(1)
      end

      it "assigns a newly created pad as @pad" do
        post :create, {:pad => valid_attributes}, valid_session
        assigns(:pad).should be_a(Pad)
        assigns(:pad).should be_persisted
      end

      it "redirects to the created pad" do
        post :create, {:pad => valid_attributes}, valid_session
        response.should redirect_to(Pad.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved pad as @pad" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        post :create, {:pad => { "pad_id" => "invalid value" }}, valid_session
        assigns(:pad).should be_a_new(Pad)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        post :create, {:pad => { "pad_id" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested pad" do
        pad = Pad.create! valid_attributes
        # Assuming there are no other pads in the database, this
        # specifies that the Pad created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Pad.any_instance.should_receive(:update).with({ "pad_id" => "MyString" })
        put :update, {:id => pad.to_param, :pad => { "pad_id" => "MyString" }}, valid_session
      end

      it "assigns the requested pad as @pad" do
        pad = Pad.create! valid_attributes
        put :update, {:id => pad.to_param, :pad => valid_attributes}, valid_session
        assigns(:pad).should eq(pad)
      end

      it "redirects to the pad" do
        pad = Pad.create! valid_attributes
        put :update, {:id => pad.to_param, :pad => valid_attributes}, valid_session
        response.should redirect_to(pad)
      end
    end

    describe "with invalid params" do
      it "assigns the pad as @pad" do
        pad = Pad.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        put :update, {:id => pad.to_param, :pad => { "pad_id" => "invalid value" }}, valid_session
        assigns(:pad).should eq(pad)
      end

      it "re-renders the 'edit' template" do
        pad = Pad.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Pad.any_instance.stub(:save).and_return(false)
        put :update, {:id => pad.to_param, :pad => { "pad_id" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested pad" do
      pad = Pad.create! valid_attributes
      expect {
        delete :destroy, {:id => pad.to_param}, valid_session
      }.to change(Pad, :count).by(-1)
    end

    it "redirects to the pads list" do
      pad = Pad.create! valid_attributes
      delete :destroy, {:id => pad.to_param}, valid_session
      response.should redirect_to(pads_url)
    end
  end

end
