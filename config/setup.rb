PROJECT_BASE_DIR = File.join(File.dirname(__FILE__), '..')
MODULE_DIR = File.join(PROJECT_BASE_DIR, 'modules')
LIB_DIR = File.join(PROJECT_BASE_DIR, 'lib')
CONFIG_DIR = File.join(PROJECT_BASE_DIR, 'config')

$:.unshift(LIB_DIR)
