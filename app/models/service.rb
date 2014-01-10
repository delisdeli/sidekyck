class Service < ActiveRecord::Base
  
  belongs_to :listing
  belongs_to :customer, :class_name => "User"
  belongs_to :provider, :class_name => "User"

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

  def approve
    self.status = 'complete'
    #pay customer
    self.completion_time = Time.now
    self.save!
  end

  def quit
    self.status = 'quit'
    self.completion_time = Time.now
    self.notes = ''
    self.save!
  end

  def submit_for_approval
    self.status = 'pending'
    self.completion_time = Time.now
    self.notes = ''
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
    self.notes = ''
    self.listing.open_position
    self.save!
  end

end
