class OverviewController < ApplicationController
before_action :authenticate_user!

    # Get totals of paid invoiced and created invoices over various time frames..
    # MAKE THIS DATE SEARCHABLE?
    
    def all 
        year_invoices = Invoice.where("issue_date < ? AND issue_date > ? AND user_id = ?", DateTime.now, DateTime.now - 1.year, current_user.id)
        week_invoices = year_invoices.where("issue_date < ? AND issue_date > ?", DateTime.now, DateTime.now - 1.week)
        month_invoices = week_invoices.where("issue_date < ? AND issue_date > ?", DateTime.now, DateTime.now - 1.month)

        totals = {
            invoiced_week: sum(week_invoices),
            invoiced_month: sum(month_invoices),
            invoiced_year: sum(year_invoices),
            paid_week: sum(week_invoices.filter { |inv| inv.status === 1}),
            paid_month: sum(month_invoices.filter { |inv| inv.status === 1}),
            paid_year: sum(year_invoices.filter { |inv| inv.status === 1})
        }

        render json: totals
    end

    private
    def sum(invoices)
        invoices.reduce(0) { |sum, inv| sum + inv.total }
    end

end

#status = 0: unpiad, 1:paid, 2:overdue