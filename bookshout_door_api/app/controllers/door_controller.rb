require 'net/http'

class DoorController < ApplicationController
    
    
    before_action :add_headers
    
    def grant_access
        response = HTTParty.get('http://192.168.120.254/cgi-bin/vertx_xml.cgi?XML=<?xml version="1.0" encoding="UTF-8"?><VertXMessage><hid:Doors action="CM" command="grantAccess"/></VertXMessage>',
                                :headers => @headers)
        puts response
        render json: {"success": "true"}
    end

    def close_door
        response = HTTParty.get('http://192.168.120.254/cgi-bin/vertx_xml.cgi?XML=<?xml version="1.0" encoding="UTF-8"?><VertXMessage><hid:Doors action="CM" command=
"lockDoor"/></VertXMessage>', :headers => @headers)
        puts response
        render json: {"success": "true"}
    end
                                
    # Returns "open", "closed", or "unknown"
    def door_status
        response = HTTParty.get('http://192.168.120.254/cgi-bin/vertx_xml.cgi?XML=<?xml version="1.0" encoding="UTF-8"?><VertXMessage><hid:Doors action="LR" responseFormat="status" /></VertXMessage>', :headers => @headers)
        statusHash = Hash.from_xml(response.body)
        #render json: statusHash
        begin
            status = statusHash["VertXMessage"]["Doors"]["Door"]["relayState"]
            render json: {"status": status == "set" ? "unlocked" : "locked"}
        rescue NoMethodError => e
            render json: {"status": "unknown"}
        end
                                
    end
                                
    private
                                
    def add_headers
        @headers = { "Authorization" => "Basic YWRtaW46RDAwclBhc3M=" }
    end
end
