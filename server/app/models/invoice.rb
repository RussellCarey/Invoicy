# Fields
# t.timestamps
# t.string :title
# t.datetime :issue_date
# t.datetime :due_date
# t.datetime :last_send_date
# t.integer :status
# t.integer :discount
# t.float :tax

class Invoice < ApplicationRecord
    belongs_to :client
    has_many :invoice_items, dependent: :delete_all
    after_initialize :defaults

    # Filters 
    #! Filter by array and user params from array - if nil then wouldnt run the condiiton..
    # Filter by duraion / properties..
    scope :filter_by_status, -> (status) { where("status = ?", status) }
    scope :filter_due_date, -> (due_date) { where("due_date = ?", due_date) }
    scope :filter_due_date_gt, -> (due_date) { where("due_date > ?", due_date) }
    scope :filter_due_date_lt, -> (due_date) { where("due_date < ?", due_date) }
    scope :filter_issue_date, -> (issue_date) { where("issue_date = ?", issue_date) }
    scope :filter_issue_date_gt, -> (issue_date) { where("issue_date > ?", issue_date) }
    scope :filter_issue_date_lt, -> (issue_date) { where("issue_date < ?", issue_date) }
    scope :filter_total, -> (total) { where("total = ?", total) }
    scope :filter_total_lt, -> (total) { where("total < ?", total) }
    scope :filter_total_gt, -> (total) { where("total > ?", total) }

    #Validations
    validates :title, presence: :true, length: { minimum: 1, maximum: 30 }
    validates :issue_date, presence: :true
    validates :due_date, presence: :true, comparison: { greater_than: Date.today }
    validates :status, presence: :true
    validates :tax, numericality: { in: 0..100}
    validates :discount, numericality: { in: 0..100}
    validates :client_id, presence: :true
    validates :user_id, presence: :true


    def get_total
        invoice_items.blank? ? 0 : invoice_items.sum('total') 
    end

    def calculate_percentage_of_discount
        (self.total / 100) * self.discount
    end

    def calculate_percentage_of_tax
        (self.total / 100) * self.tax
    end

    private
    def defaults
      self.issue_date ||= DateTime.now
      self.tax ||= 0
      self.discount ||= 0
      self.pre_total ||= 0
      self.total ||= 0
    end

end


