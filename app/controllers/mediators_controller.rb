class MediatorsController < ApplicationController
  def new
    @mediator = Mediator.new
    p 'Sir'
  end

  # GET /castles/1/edit
  def edit
  end

  # POST /castles
  # POST /castles.json
  def create
    p 'creation'
    prm = lead_params
    @mediator = Mediator.new
    @mediator.auth
    @mediator.new_lead(
       prm['name'],
       prm['email'],
       prm['phone'],
       prm['comment']
    )
    
    render :new
  
  end
  
  def show
   
  end

  # PATCH/PUT /castles/1

  private



 
  def lead_params
    params.require(:mediator).permit(
    
    :name,
    :phone,
    :email,
    :comment
    
    )
  end
end
