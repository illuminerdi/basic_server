require 'test/unit'
require 'basic_server'

class TestBasicServer < Test::Unit::TestCase
  def setup
    @request = BasicServer::Request.new("GET / HTTP/1.1\r\n\r\n")
    @not_found = BasicServer::Request.new("GET /notfound.htm HTTP/1.1\r\n\r\n")
    @erb = BasicServer::Request.new("GET /test.html.erb HTTP/1.1\r\n\r\n")
    @time = BasicServer::Request.new("GET /time HTTP/1.1\r\n\r\n")
    @error = BasicServer::Request.new("GET /error HTTP/1.1\r\n\r\n")
    @quotes = BasicServer::Request.new("GET /random_quote HTTP/1.1\r\n\r\n")
  end
  
  def test_request_has_a_method_and_path
    assert_equal "public_html/index.htm", @request.path.to_s
    assert_equal "GET", @request.method
  end
  
  def test_ok_header
    header = @request.create_header(200)
    assert_match /HTTP\/0.9 200 OK/, header
  end
  
  def test_not_found_header
    header = @request.create_header(404)
    assert_match /HTTP\/0.9 404 Not Found/, header
  end
  
  def test_exception_header
    header = @request.create_header(500)
    assert_match /HTTP\/0.9 500 Internal Server Error/, header
  end
  
  def test_time_servlet
    assert_match /Current server time/, @request.time
  end
  
  def test_error_servlet
    assert_raise Exception do
      @request.error
    end
  end
  
  def test_quotes_servlet
    assert_match /-Oscar Wilde/, @request.random_quote
  end
  
  def test_html_response_http_code
    response = @request.respond
    assert_equal "HTTP/0.9 200 OK", get_status(response)
  end
  
  def test_html_response_header_info
    response = @request.respond
    response.pop
    response[0].split("\r\n").each {|line|
      assert_match /HTTP|Server|Date|Last-Modified|Content-Length|Content-Type/, line
    }
  end
  
  def test_erb_response
    response = @erb.respond
    assert_equal "HTTP/0.9 200 OK", get_status(response)
    assert_match /<html>/, response.last
  end
  
  def test_time_servlet_response
    response = @time.respond
    assert_equal "HTTP/0.9 200 OK", get_status(response)
    assert_match /Current server time is:/, response.last
  end
  
  def test_quotes_servlet_response
    response = @quotes.respond
    assert_equal "HTTP/0.9 200 OK", get_status(response)
    assert_match /-Oscar Wilde/, response.last
  end
  
  def test_error_servlet_response
    # we're passing the exception back through to the calling module method, which will handle the http 500
    assert_raise(Exception) do
      response = @error.respond
    end
  end
  
  def test_file_not_found
    response = @not_found.respond
    assert_equal "HTTP/0.9 404 Not Found", get_status(response)
  end
  
  def get_status(response)
    response[0].split("\r\n").first
  end
end