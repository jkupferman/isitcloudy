
# Add a nice output method to exceptions to provide better output
class Exception
  def pretty_printer
    "#{self.class.to_s} - #{self.message.to_s}:\n#{self.backtrace.join("\n")}"
  end
end
