require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"
IRB.conf[:SAVE_HISTORY] = 1000

begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue
end
