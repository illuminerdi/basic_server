#!/usr/bin/env ruby -w

require 'gserver'
require 'socket'
require 'pathname'
require 'erb'
require 'thread'

module BasicServer
  VERSION = '0.0.1'
  RESPONSES = {
    200 => "OK",
    404 => "Not Found",
    500 => "Internal Server Error"
  }
  HTTP_VERSION = "HTTP/0.9"
  FILE_404 = "public_html/404.html"
  FILE_500 = "public_html/500.html"
  
  class Request
    attr_reader :method, :path

    def initialize(request)
      @method, path = request.match(/^(\w+)\s(\S+)\s(\S+)/)[1,2]
      path = "/index.htm" if path.match(/^\/$/)
      @path = Pathname.new("public_html#{path}")
    end
    
    def create_header rnum
      header = "#{HTTP_VERSION} #{rnum} #{RESPONSES[rnum]}\r\n"
      header += "Date: #{Time.now}\r\n"
      header += "Server: BasicServer\r\n"
      if @path.exist? && @path.file?
        header += "Last-Modified: #{@path.mtime}\r\n"
        header += "Content-Length: #{@path.size}\r\n"
      end
      header += "Content-Type: text/html\r\n\r\n" 
    end
    
    def respond
      response = []
      template = @path.split.last.to_s
      if self.respond_to?(template.to_sym)
        # we are a servlet
        response << create_header(200)
        response << self.send(template)
        return response
      end
      
      unless @path.exist? && @path.file?
        response << create_header(404)
        response << Pathname.new(FILE_404).read
        return response
      end
      
      response << create_header(200)
      case @path.extname
      when '.erb'
        response << ERB.new(@path.read.gsub(/^  /, '')).result
      when /^(\.htm|\.html)/
        response << @path.read
      end
    end
    
    def time
      "Current server time is: #{Time.now.to_s}"
    end
    
    def error
      raise Exception, "You should be seeing an error."
    end
    
    def random_quote
      quotes = [
        "A little sincerity is a dangerous thing, and a great deal of it is absolutely fatal. -Oscar Wilde",
        "A man can be happy with any woman as long as he does not love her. -Oscar Wilde",
        "Always forgive your enemies; nothing annoys them so much. -Oscar Wilde",
        "America is the only country that went from barbarism to decadence without civilization in between. -Oscar Wilde",
        "Anyone who lives within their means suffers from a lack of imagination. -Oscar Wilde"
      ]
      quote = (rand(0)*quotes.size).floor
      quotes[quote]
    end
  end
  
  def respond io
    begin
      request = Request.new(io.gets)
      request.respond.each do |line|
        io << line
      end
    rescue Exception => e
      io.print "#{HTTP_VERSION} 500/Internal Server Error\r\n"
      io.print "Date: #{Time.now}\r\n"
      io.print "Content-Type: text/html\r\n"
      #io.print "ERROR: #{e.to_s}\r\n\r\n"
      io << Pathname.new(FILE_500).read
    end
  end
end

class BasicGServer < GServer
  include BasicServer
  def serve(io)
    respond(io)
  end
end

class BasicTCPServer
  include BasicServer
  
  def initialize(port, num_threads=10)
    @port = port
    @num_threads = num_threads
  end
  
  def start
    server = TCPServer.new(@port)
    threads = ThreadGroup.new
    while session = server.accept
      if threads.list.size <= @num_threads
        t = Thread.new(session) do |my_session|
          respond(my_session)
          my_session.close
        end
        threads.add(t)
      end
    end
  end
end