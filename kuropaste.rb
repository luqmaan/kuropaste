##
# KuroPaste | DarkNet Pastebin
#
# Copyright (c) 2012 Alexander Taylor <ajtaylor@fuzyll.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
##

module KuroPaste
    Database = Sequel.sqlite("kuropaste.db")
    unless Database.table_exists?("pastes")
        Database.create_table("pastes") do
            primary_key :id
            text :name
            text :language
            text :contents
        end
    end

    class Paste < Sequel::Model; end

    class Application < Sinatra::Base

        set :public_folder, File.dirname(__FILE__) + "/content"
        set :haml, {:format => :html5}

        get "/" do
            haml :new
        end

        post "/" do
            @paste = Paste.create(:name => params[:name],
                                  :language => params[:language],
                                  :contents => params[:contents])
            if @paste
                redirect "/#{@paste[:id]}"
            else
                redirect '/'
            end
        end

        get "/:id" do
            @paste = Paste[params[:id]]
            if @paste 
                haml :show
            else
                redirect "/"
            end
        end

        run!

    end

end

