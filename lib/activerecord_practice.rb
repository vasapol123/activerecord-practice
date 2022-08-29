require 'sqlite3'
require 'active_record'
require 'byebug'
require 'time'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    Customer.where(first: "Candice")
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
  end
  
  def self.with_valid_email
    Customer.where("email LIKE ?", "%@%")
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
  end

  def self.with_dot_org_email
    Customer.where("email LIKE ?", "%.org")
  end

  def self.with_invalid_email
    Customer.where.not("email LIKE ?", "%@%")
  end

  def self.with_blank_email
    Customer.where(email: [nil, ""])
  end

  def self.born_before_1980
    Customer.where("birthdate < ?", Date.new(1980,1,1))
  end

  def self.with_valid_email_and_born_before_1980
    Customer.where("email LIKE ? AND DATE( birthdate ) < DATE( ? )", "%@%", "1980-01-01")
  end

  def self.last_names_starting_with_b
    Customer.where("last LIKE ?", "B%").order(birthdate: :asc)
  end

  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    Customer.find_by(first: "Gussie", last: "Murray").update(birthdate: Time.parse("February 8,2004"))
  end

  def self.change_all_invalid_emails_to_blank
    Customer.where.not("email LIKE ?", "%@%").update(:all, email: "")
  end

  def self.delete_meggie_herman
    Customer.find_by(first: "Meggie", last: "Herman").destroy
  end

  def self.delete_everyone_born_before_1978
    Customer.destroy_by("DATE( birthdate ) < DATE( ? )", Time.parse("31 Dec 1977"))
  end
end
