class Service < ActiveRecord::Base
  
  belongs_to :listing
  belongs_to :customer, :class_name => "User"
  belongs_to :provider, :class_name => "User"

  before_create :set_hire_price

  def associate
    if self.listing.category == 'customer'
      return self.provider
    elsif self.listing.category == 'provider'
      return self.customer
    end
  end

  def pending_approval?
    self.status == 'pending'
  end

  def active?
    self.status == 'active'
  end

  def complete?
    self.status == 'complete'
  end

  def can_quit?
    pending_approval? or active?
  end

  def approve
    self.status = 'complete'
    # self.customer.pay_with_frozen_balance(provider, self.hire_price)
    self.customer.pay(provider, self.hire_price)
    self.completion_time = Time.now
    self.notes = "Completed on #{format_time(self.completion_time)}."
    self.save!
  end

  def quit
    self.status = 'quit'
    self.completion_time = Time.now
    self.notes = "Quit on #{format_time(self.completion_time)}."
    self.save!
  end

  def submit_for_approval
    self.status = 'pending'
    self.completion_time = Time.now
    self.save!
  end

  def rehire notes
    self.status = 'active'
    self.notes = notes
    self.save!
  end

  def relist
    self.status = 'fired'
    self.completion_time = Time.now
    self.notes = "Dismissed on #{format_time(self.completion_time)}."
    self.listing.open_position
    self.save!
  end

  def format_time datetime
    datetime.strftime("%A %m/%e/%y @ %I:%M %p")
  end

  private

  def set_hire_price
    self.hire_price = self.listing.price
  end

end
