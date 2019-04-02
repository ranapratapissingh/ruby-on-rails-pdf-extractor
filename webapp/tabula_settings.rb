# encoding: UTF-8
require 'fileutils'

module TabulaSettings

  ########## Defaults ##########
  DEFAULT_DEBUG = true
  DEFAULT_DISABLE_VERSION_CHECK = false
  DEFAULT_DISABLE_NOTIFICATIONS = false

  ########## Helpers ##########
  def self.getDataDir
    # OS X: ~/Library/Application Support/Tabula
    # Win:  %APPDATA%/Tabula
    # Linux: ~/.tabula

    # when invoking as "java -Dtabula.data_dir=/foo/bar ... -jar tabula.war"
    data_dir = java.lang.System.getProperty('tabula.data_dir')
    unless data_dir.nil?
      return java.io.File.new(data_dir).getPath
    end

    # when invoking with env var
    data_dir = ENV['TABULA_DATA_DIR']
    unless data_dir.nil?
      return java.io.File.new(data_dir).getPath
    end

    # use the usual directory in (system-dependent) user home dir
    data_dir = nil
    case java.lang.System.getProperty('os.name')
    when /Windows/
      # APPDATA is in a different place (under user.home) depending on
      # Windows OS version. so use that env var directly, basically
      appdata = ENV['APPDATA']
      if appdata.nil?
        home = java.lang.System.getProperty('user.home')
      end
      data_dir = java.io.File.new(appdata, '/Tabula').getPath

    when /Mac/
      home = java.lang.System.getProperty('user.home')
      # data_dir = File.join(home, '/Library/Application Support/Tabula')
      data_dir = File.join(home, 'webapp/upload')


    else
      # probably *NIX
      home = java.lang.System.getenv('XDG_DATA_HOME')
      if !home.nil?
        # XDG
        data_dir = File.join(home, '/tabula')
      else
        # other, normal *NIX systems
        home = java.lang.System.getProperty('user.home')
        home = '.' if home.nil?
        # data_dir = File.join(home, '/.tabula')
        data_dir = File.join(File.expand_path(''), 'webapp/upload')
      end
    end # /case

    data_dir
  end

  def self.enableDebug
    # when invoking as "java -Dtabula.debug=1 ... -jar tabula.war"
    debug = java.lang.System.getProperty('tabula.debug')
    unless debug.nil?
      return (debug.to_i > 0)
    end

    # when invoking with env var
    debug = ENV['TABULA_DEBUG']
    unless debug.nil?
      return (debug.to_i > 0)
    end

    DEFAULT_DEBUG
  end

  def self.disableVersionCheck
    disable_version_check = java.lang.System.getProperty('tabula.disable_version_check')
    unless disable_version_check.nil?
      return (disable_version_check.to_i > 0)
    end

    DEFAULT_DISABLE_VERSION_CHECK
  end

  def self.disableNotifications
    disable_notifications = java.lang.System.getProperty('tabula.disable_notifications')
    unless disable_notifications.nil?
      return (disable_notifications.to_i > 0)
    end

    DEFAULT_DISABLE_NOTIFICATIONS
  end

  ########## Constants that are used around the app, based on settings ##########

  ROOT_DIR = File.expand_path('')
  DOCUMENTS_BASEPATH = File.join(self.getDataDir, 'pdfs')
  ENABLE_DEBUG_METHODS = self.enableDebug
  DOCUMENTS_RELATIVEPATH = File.join('webapp', 'upload', 'pdfs')
  DOCUMENTS_OUTPUTPATH = File.join('webapp', 'static', 'export')

  if ENV['RACK_ENV'] == 'production'
    MONGODB_ENDPOINT = '54.183.42.219'
    MONGODB_PORT = '27017'
    DATABASE = 'xml-extractor'
    DB_USER = 'testuser'
    DB_PASSWORD = 'amadeus'

  elsif ENV['RACK_ENV'] == 'development'
    MONGODB_ENDPOINT = '127.0.0.1'
    # MONGODB_ENDPOINT = '54.183.136.45'
    MONGODB_PORT = '27017'
    DATABASE = 'xml-extractor'
    DB_USER = 'testuser'
    DB_PASSWORD = 'amadeus'

  else ENV['RACK_ENV'] == 'local'
    MONGODB_ENDPOINT = '127.0.0.1'
    MONGODB_PORT = '27017'
    DATABASE = 'xml-extractor'
    DB_USER = 'testuser'
    DB_PASSWORD = 'amadeus'
  end

  puts "ROOT_DIR = #{ROOT_DIR}"
  puts "DATA_DIR = #{self.getDataDir}"
  puts "DOCUMENTS_BASEPATH = #{DOCUMENTS_BASEPATH}"
  puts "ENABLE_DEBUG_METHODS = #{ENABLE_DEBUG_METHODS}"
  puts "DOCUMENTS_RELATIVEPATH = #{DOCUMENTS_RELATIVEPATH}"
  puts "DOCUMENTS_OUTPUTPATH = #{DOCUMENTS_OUTPUTPATH}"
  puts "MONGO ENDPOINT = #{MONGODB_ENDPOINT}:#{MONGODB_PORT}"

  ########## Initialize environment, using helpers ##########
  FileUtils.mkdir_p(DOCUMENTS_BASEPATH)
  FileUtils.mkdir_p(DOCUMENTS_OUTPUTPATH)
end
