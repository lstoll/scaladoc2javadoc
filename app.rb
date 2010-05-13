require 'sinatra'
require 'rack'
require 'nokogiri'
require 'open-uri'


configure :development do
  Sinatra::Application.reset!
  use Rack::Reloader
end

enable :inline_templates

get "/" do
  "Tack the URL of the target document to the end of this url, minus the http"
end


get "/*" do
  url = params["splat"][0]
  if url =~ /(.*)\/allclasses-frame.html$/
    classes = []
    # Request for the index page, do it!
    doc = Nokogiri::HTML(open("http://#{$1}/all-classes.html"))
    doc.css("ul.list li a").each do |i|
      cls = { }
      cls[:href] = i.attributes["href"].value
      pkg_arr = i.attributes["href"].to_s.split('/')
      pkg_arr.slice!(-1)
      cls[:package] = pkg_arr.join('.')
      cls[:name] = i.inner_text
      classes << cls
    end

    erb :javadoc_index, :locals => { :classes => classes }
  else
    # Redirect to URL
    redirect "http://#{url}", 301
  end
end

__END__

@@ javadoc_index

 <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<!--NewPage--> 
<HTML> 
<HEAD> 
<!-- Generated by javadoc (build 1.6.0_06) on Tue Apr 13 12:22:28 CEST 2010 --> 
<TITLE> 
All Classes
</TITLE> 
 
<META NAME="date" CONTENT="2010-04-13"> 
 
<LINK REL ="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"> 
 
 
</HEAD> 
 
<BODY BGCOLOR="white"> 
<FONT size="+1" CLASS="FrameHeadingFont"> 
<B>All Classes</B></FONT> 
<BR> 
 
<TABLE BORDER="0" WIDTH="100%" SUMMARY="">
<TR> 
<TD NOWRAP><FONT CLASS="FrameItemFont">

<% classes.each do |cls| %>
<A HREF="<%=cls[:href]%>" title="class in <%=cls[:package]%>" target="classFrame"><%=cls[:name]%></A>
<BR>
<% end %>

</FONT></TD> 
</TR> 
</TABLE> 
 
</BODY> 
</HTML>
