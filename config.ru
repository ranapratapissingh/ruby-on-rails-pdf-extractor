# encoding: UTF-8
require 'rubygems'
require 'bundler'
Bundler.require

# Disable LittleCMS when running in JVM >= 1.8
# https://pdfbox.apache.org/2.0/getting-started.html
jvmajor, jvminor = java.lang.System.getProperty('java.specification.version').split('.')
if !jvminor.nil? && jvminor.to_i >= 8
  java.lang.System.setProperty("sun.java2d.cmm", "sun.java2d.cmm.kcms.KcmsServiceProvider")
end

require_relative './webapp/tabula_settings.rb'
require_relative './webapp/tabula_web.rb'

potential_root_uri_without_slashes = (defined?($servlet_context) ? $servlet_context.getContextPath : ENV["ROOT_URI"])

if potential_root_uri_without_slashes.nil? || potential_root_uri_without_slashes == ''
  ROOT_URI = '/'
else
  ROOT_URI = (potential_root_uri_without_slashes[0] == "/" ? '' : '/') + potential_root_uri_without_slashes +  (potential_root_uri_without_slashes[-1] == "/" ? '' : '/')
end

puts "running under #{ROOT_URI} as root URI" 


map ROOT_URI do 
  run Cuba
end

if "#{$PROGRAM_NAME}".include?("tabula.jar")
  # only do this if running as jar or app. (if "rackup", we don't
  # actually use 8080 by default.)

  require 'java'

  # don't do "java_import java.net.URI" -- it conflicts with Ruby URI and
  # makes Cuba/Rack really really upset. just call "java.*" classes
  # directly.
  port = java.lang.Integer.getInteger('warbler.port', 8080)
  url = "http://127.0.0.1:#{port}"

  puts "============================================================"
  puts url
  puts "============================================================"

  # Open browser after slight delay. (The server may take a while to actually
  # serve HTTP, so we are trying to avoid a "Could Not Connect To Server".)
  uri = java.net.URI.new(url)
  sleep 0.5

  puts "should we open browser?"
  puts "java.lang.Boolean.getBoolean('tabula.openBrowser'): #{java.lang.Boolean.getBoolean('tabula.openBrowser')}"
  have_desktop = false
  if java.lang.Boolean.getBoolean('tabula.openBrowser')
    puts "java.awt.Desktop.isDesktopSupported: #{java.awt.Desktop.isDesktopSupported}"
    if java.awt.Desktop.isDesktopSupported
      begin
        desktop = java.awt.Desktop.getDesktop()
      rescue
        puts "java.awt.Desktop.getDesktop(): no"
        desktop = nil
      else
        puts "java.awt.Desktop.getDesktop(): yes"
        have_desktop = true
      end
    end
  end

  # if running as a jar or app, automatically open the user's web browser if
  # the system supports it.
  if have_desktop
    puts "\n======================================================"
    puts "Launching web browser to #{url}\n\n"

    begin
      desktop.browse(uri)
    rescue
      puts "Unable to launch your web browser, you will have to"
      puts "manually open it to the above URL."
    else
      puts "If it does not open in 10 seconds, you may manually open"
      puts "a web browser to the above URL."
    end

    puts "When you're done using the Tabula interface, you may"
    puts "return to this window and press \"Control-C\" to close it."
    puts "======================================================\n\n"
  else
    puts "\n======================================================"
    puts "Server now listening at: #{url}\n\n"
    puts "You may now open a web browser to the above URL."
    puts "When you're done using the Tabula interface, you may"
    puts "return to this window and press \"Control-C\" to close it."
    puts "======================================================\n\n"
  end
end
