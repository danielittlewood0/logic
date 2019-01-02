require File.expand_path(File.dirname(__FILE__)) + "/propositions.rb"
require "/home/daniel/repos/cfg/lib/cfg_new.rb"

#while true
1.times do
  puts "Type some input, and press Ctrl-D."
# inp = $stdin.read.chomp
  ls = "P".to_pseudo
  rs = "(P => P)".to_pseudo
  rule_1 = rule(ls,rs)
  rule_2 = rule('P'.to_pseudo,'a'.to_pseudo)
  rule_3 = rule('P'.to_pseudo,'b'.to_pseudo)
  rules = [rule_1,rule_2,rule_3]
# p rules.map(&:write)
  to_parse = "((a => b) => (b => a))".to_pseudo
  derivation = to_parse.parse(rules)
  p derivation.map{|step| step.write}
  p to_parse.write
  puts "Thanks."
end
