require 'rubygems'
require 'antir-core'

Antir::Core.load_config('/opt/core.yml')
core = Antir::Core.local
core.start
