class KaiValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.count("\n") <= 25
      record.errors[attribute] << (options[:message] || "/n over 20")
    end
  end
end