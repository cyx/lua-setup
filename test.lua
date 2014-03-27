local msgpack = require('cmsgpack')

print(msgpack.unpack(msgpack.pack({ hello = 'there' })))
