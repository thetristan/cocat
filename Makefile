all :
	node_modules/.bin/coffee --compile --output lib/ src/

test : all
	node_modules/.bin/jasmine-node --coffee spec
