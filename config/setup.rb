PROJECT_BASE_DIR = File.join(File.dirname(__FILE__), '..')

def join_with_base(path)
  File.join(PROJECT_BASE_DIR, path)
end

MODULE_DIR  = join_with_base('modules')
LIB_DIR     = join_with_base('lib')
CONFIG_DIR  = join_with_base('config')
PRESETS_DIR = join_with_base('presets')

$:.unshift(LIB_DIR)
