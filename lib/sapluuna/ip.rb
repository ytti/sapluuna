require 'ipaddr'

class Sapluuna
  class IP < IPAddr

    def initialize(addr = '::', family = Socket::AF_UNSPEC)
      addr_org, _family_org = addr, family
      prefix, _prefixlen = addr_org.split('/')
      @addr_org = prefix
      super
      if @family == Socket::AF_UNSPEC or @family == Socket::AF_INET
        @addr_org = in_addr(@addr_org)
      else
        @addr_org = in6_addr(@addr_org)
      end
    end

    def ip
      addr_tmp = @addr
      @addr = @addr_org
      ip = self.to_s
      @addr = addr_tmp
      ip
    end

    def mask_cidr
      @mask_addr.to_s(2).delete('0').size
    end

    def mask_wild
      _to_string ~@mask_addr
    end

    def mask_net
      _to_string @mask_addr
    end

    def cidr
      ip + '/' + mask_cidr.to_s
    end

    def acl
      ip + ' '+ mask_wild
    end

    def net
      ip + ' ' + mask_net
    end

  end
end
