Puppet::Type.type(:a2mod).provide(:redhat) do
  desc "Manage Apache 2 modules on RedHat family OSs"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  attr_accessor :modfile
  class << self
    attr_accessor :modpath
    def preinit
      @modpath = "/etc/httpd/mod.d"
    end
  end

  self.preinit

  def create
    File.open(modfile,'w') do |f|
      f.puts "LoadModule #{resource[:name]}_module modules/mod_#{resource[:name]}.so"
    end
  end

  def destroy
    File.delete(modfile)
  end

  def exists?
    File.exists?(modfile)
  end

  def self.instances
    modules = []
    Dir.glob("#{modpath}/*.load").each do |file|
      File.readlines(file).each do |line|
        m = line.match(/^LoadModule (\w+)_module /)
        modules << m[1] if m
      end
    end

    modules.map  do |mod|
      new(
        :name     => mod,
        :ensure   => :present,
        :provider => :redhat
      )
    end
  end

  def modfile
    modfile ||= "#{self.class.modpath}/#{resource[:name]}.load"
  end
end
