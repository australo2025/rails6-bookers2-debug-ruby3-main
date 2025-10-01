module UsersHelper
  def percent_change(numerator, denominator)
    return '—'   if denominator.zero? && numerator.zero?
    return '∞%'  if denominator.zero? && numerator.positive?
    "#{(numerator.to_f / denominator * 100).round}%"
  end
end