require 'uri'

def paramaterize(query_array)
  params_hash = Hash.new

  # for each item in query_array
  query_array.each do |keys, val|
    current_level = params_hash
    while keys.length > 1
      key = keys.shift
      current_level[key] ||= {}
      current_level = current_level[key]
    end
    current_level[keys.shift] = val
  end
  params_hash
end

def parse_key(key)
  key.split(/\]\[|\[|\]/)
end

simple = [[['password'], '12345']]
complex = [
  [['user', 'address', 'street'], 'main'],
  [['user', 'address', 'zip'], '89436']
]

# puts "Simple test: should return \n{'password' => '12345'}"
# p paramaterize(simple)
# puts "Complex test: should return \n{ 'user' => { 'address' => { 'street' => 'main', 'zip' => '89436' } } }"
# p paramaterize(complex)
#
 simple_q = 'password=12345'
 complex_q = 'user[address][street]=main&user[address][zip]=89436'
 simple_params = URI::decode_www_form(simple_q)
 p complex_params = URI::decode_www_form(complex_q)

single_key = URI::decode_www_form("key=val").map{|key, val| [parse_key(key), val]}


 simple_params.map{|key, val| [parse_key(key), val]}
p complex_params.map{|key, val| [parse_key(key), val]}

