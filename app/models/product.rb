class Product < ActiveRecord::Base
  def self.search(string)
    conditions = string.split(',').collect do |m|
      m.strip!
      delim = (m.include?('=') ? '=' : 'like')
      expr = m.split(/=|like/i)
      "#{expr[0].strip.downcase.tr(' ', '_')} #{delim} '#{expr[1].strip}'"
         end
    final_condition = conditions.join(' AND ')
    puts final_condition
    Product.where(final_condition)
  end
end

