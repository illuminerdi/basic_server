= BasicServer

* http://github.com/illuminerdi

== DESCRIPTION:

A simple HTTP server that works under GServer and TCPServer

== FEATURES/PROBLEMS:

2 HTTP Servers (really basic HTTP 0.9/GET only):

    * gserver for thread spawning per connection
    * tcpserver w/ prespawned thread pool

requirements:

    * craft your own request / response objects
    * servelets of your own design. start with time of the day app.
    * static files from the filesystem.
    * html files served plain
    * html.erb files should render via erb.
    * no caching, no clever.

Bare minimum HTTP protocol:

    * request:

GET /index.html HTTP/1.0 CRLF CRLF

    * response:

HTTP/1.1 200 OK CRLF Date: Thu, 07 May 2009 01:06:01 GMT CRLF Last-Modified: Mon, 19 Jan 2009 23:02:19 GMT CRLF Content-Length: 3750 CRLF Content-Type: text/html CRLF CRLF …content…

    * other responses are:
    * 304 redirected
    * 404 missing
    * 500 app error


== SYNOPSIS:

  # you can start up either server directly from the command line
  
  # For the GServer implementation:
  $ bin/basic_server gserver
  
  # For the TCPServer implementation:
  $ bin/basic_server tcpserver

== REQUIREMENTS:

* ruby 1.8.6

== INSTALL:

* Download source, use.

== LICENSE:

(The MIT License)

Copyright (c) 2009 Joshua Clingenpeel

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
