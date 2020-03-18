require "tty-prompt"

module CLI

  @@prompt = TTY::Prompt.new

  attr_accessor :matching, :shared

  def get_options
    set_defaults if @@prompt.yes?('Use default settings?')
  end

  def set_defaults
    @matching = true 
    @shared = true
    @marketplace_shared = false 
    @marketplace_matching = false
  end


end
