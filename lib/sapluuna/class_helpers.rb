require_relative 'ip'

class Sapluuna
  module ClassHelpers

    class ::String
      def ip
        IP.new(self).ip
      end
      def acl
        IP.new(self).acl
      end
      def net
        IP.new(self).net
      end
      def cidr
        IP.new(self).cidr
      end
    end

    class ::Array
      def as_ip format_string
        as_method 'ip', format_string
      end

      def as_acl format_string
        as_method 'acl', format_string
      end

      def as_cidr format_string
        as_method 'cidr', format_string
      end

      private

      def as_method method, format_string
        map do |str|
          format_string % str.send(method)
        end.join("\n")
      end
    end

  end
end
