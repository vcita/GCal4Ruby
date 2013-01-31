require 'gcal4ruby/recurrence'

module GCal4Ruby
  #The Freebusy Class represents a busy time slot in a calendar
  #
  class Freebusy < GData4Ruby::GDataObject
    #Creates a new Event.  Accepts a valid Service object and optional attributes hash.
    def initialize(service, attributes = {})
      super(service, attributes)
      attributes.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    
    #Sets the start time of the Event.  Must be a Time object or a parsable string representation
    #of a time.
    def start_time=(str)
      raise ArgumentError, "Start Time must be either Time or String" if not str.is_a?String and not str.is_a?Time
      @start_time = if str.is_a?String
        Time.parse(str)      
      elsif str.is_a?Time
        str
      end
    end
    
    #Sets the end time of the Event.  Must be a Time object or a parsable string representation
    #of a time.
    def end_time=(str)
      raise ArgumentError, "End Time must be either Time or String" if not str.is_a?String and not str.is_a?Time
      @end_time = if str.is_a?String
        Time.parse(str)      
      elsif str.is_a?Time
        str
      end
    end
    
    #The event start time.
    def start_time
      return @start_time
    end
    
    #The event end time.
    def end_time
      return @end_time
    end

    #Loads the event info from an XML string.
    def load(string)
      super(string)
      @xml = string
      @exists = true
      xml = REXML::Document.new(string)
      xml.root.elements.each(){}.map do |ele|
        case ele.name
          when "when"
            @start_time = Time.parse(fix_time_string(ele.attributes['startTime']))
            @end_time = Time.parse(fix_time_string(ele.attributes['endTime']))
        end
      end
    end

  
    private     

    # Adds the UTC timezone for a time string that has no time zone
    def fix_time_string(timestr)
      if timestr.match(/z$/) || timestr.match(/\+\d\d:\d\d$/)
        return timestr
      end

      return "#{timestr}Z"
    end

  end
end

