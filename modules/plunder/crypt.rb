require 'exhumer/module/plunder'

class Awesomesauce < Exhumer::Module::Plunder

  MCF_CHAR_STRICT = '[\d[a-z][A-Z]./]'
  MCF_CHAR = '[\d[a-z][A-Z]./,=_-]'

  def initialize  
    super

    # $2a$12$GhvMmNVjRW29ulnudl.LbuAnUtN/LRfe1JsBm1Xu6LE3059z5Tr8m
    add_pattern :bcrypt_mcf, /\$2a?\$\d{2}\$#{MCF_CHAR}{53}/

    # $1$3azHgidD$SrJPt7B.9rekpmwJwtON31
    add_pattern :md5_unix, /\$1\$#{MCF_CHAR}{0,8}\$#{MCF_CHAR}{22}/

    # $md5,rounds=5000$GUBv0xjJ$$mSwgIswdjlTY0YxV7HBVm0'
    add_pattern :md5_sun, /\$md5(?:,rounds=\d+)?\$#{MCF_CHAR}{0,8}\${2}#{MCF_CHAR}{22}/

    # $sha1$40000$jtNX3nZ2$hBNaIXkt4wBI2o5rsi8KejSjNqIq
    add_pattern :sha1_mcf, /\$sha1\$\d+\$#{MCF_CHAR}{0,64}\$#{MCF_CHAR}{28}/

    # $6$rounds=40000$JvTuqzqw9bQ8iBl6$SxklIkW4gz00LvuOsKRCfNEllLciOqY/FSAwODHon45YTJEozmy.QAWiyVpuiq7XMTUMWbIWWEuQytdHkigcN/
    add_pattern :sha512_mcf, /\$6\$(?:rounds=\d+\$)?#{MCF_CHAR}{0,16}\$#{MCF_CHAR}{86}/
    add_pattern :sha512_mcf, /\$5\$(?:rounds=\d+\$)?#{MCF_CHAR}{0,16}\$#{MCF_CHAR}{43}/
  end

  def dorks
    {
      :bcrypt     => ['"root:$2a"'],
      :md5_unix   => ['"root:$1" daemon'],
      :md5_sun    => ['"root:$md5,rounds"'],
      :sha256_mcf => ['"root:$5" daemon'],
      :sha512_mcf => ['"root:$6" daemon'],
    }
  end
end
