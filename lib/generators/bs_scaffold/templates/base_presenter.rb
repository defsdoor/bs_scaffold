require 'delegate'

class BasePresenter < SimpleDelegator

  def initialize(model, view)
    @model, @view = model, view
    super(@model)
  end

  def class
    __getobj__.class
  end

  def presenter?
    true
  end

  def h
    @view
  end
  
end

