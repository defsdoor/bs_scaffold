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

  def created_at_formatted
    h.l created_at
  end

  def updated_at_formatted
    h.l updated_at
  end

  def deleted_at_formatted
    h.l deleted_at
  end

  
end

